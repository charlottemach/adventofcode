import System.IO
import Data.Char (ord)
import Data.List.Split
import qualified Data.Map.Lazy as Map


main = do
    withFile "input.txt" ReadMode (\handle -> do
        contents <- hGetContents handle
        let lines = splitOn "," (filter (/='\n') contents)
        putStrLn $ "A: " ++ (show (sum (Prelude.map hash lines)))
        putStrLn $ "B: " ++ (show (focus (Prelude.map splitInstr lines)))
        )

hash :: [Char] -> Int
hash s = hash_acc (s, 0)
    where
        hash_acc :: ([Char], Int) -> Int
        hash_acc ([], acc) = acc
        hash_acc (hd:tl, acc) = hash_acc (tl, (acc + (ord hd)) * 17 `mod` 256)



splitInstr :: [Char] -> ([Char],Int)
splitInstr s = if (length i) > 1 then (head i,read (last i))
               else ((filter (/='-') s), 0)
    where 
        i = splitOn "=" s


slots :: Int -> [([Char],Int)] -> Int -> Int
slots _ [] _ = 0
slots bn ((c,n):ss) si = (bn * si * n) + (slots bn ss (si+1))


power :: Int -> Map.Map Int [([Char],Int)] -> Int -> Int
power box mp acc = if (box > 255) then acc else
                    power (box + 1) mp (acc + (slots (box+1) sl 1))
    where
        sl = Map.findWithDefault [] box mp


focus :: [([Char],Int)] -> Int
focus ls = focus_help ls mp
    where
        mp = Map.fromList([(i,j) | i <- [0..255],j <- [[]] ])
        focus_help :: [([Char],Int)] -> Map.Map Int [([Char],Int)] -> Int
        focus_help [] mp = power 0 mp 0
        focus_help ((cs,n):xs) mp = if (n == 0) 
                                          then focus_help xs (rm cs h mp)
                                          else focus_help xs (add cs n h mp)
            where
                h = hash(cs)

rm :: [Char] -> Int -> Map.Map Int [([Char],Int)] -> Map.Map Int [([Char],Int)]
rm c h mp = Map.insertWithKey f h [] mp
    where
        f :: Int -> [([Char],Int)] -> [([Char],Int)] -> [([Char],Int)] 
        f key _ old = filter (\(cs,n) -> cs/=c) old

add :: [Char] -> Int -> Int -> Map.Map Int [([Char],Int)] -> Map.Map Int [([Char],Int)]
add c n h mp = Map.insertWithKey f h [] mp
    where
        f :: Int -> [([Char],Int)] -> [([Char],Int)] -> [([Char],Int)] 
        f key new old = addL old (c,n)
            where
                addL :: [([Char],Int)] -> ([Char],Int) ->  [([Char],Int)] 
                addL [] (c2,n2) = [(c2,n2)]
                addL ((c1,n1):xs) (c2,n2) = if (c1 == c2) then [(c2,n2)] ++ xs else
                                [(c1,n1)] ++ addL xs (c2,n2)
