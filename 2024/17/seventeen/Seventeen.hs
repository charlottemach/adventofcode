import System.IO
import Data.Bits
import Data.List.Split

main :: IO ()
main = do
  withFile "input.txt" ReadMode (\handle -> do
    contents <- hGetContents handle
    let prog = map (read :: [Char] -> Integer) (splitOn "," (last (splitOn ": " (last (lines contents)))))
    let a = read (last (splitOn ": " ((lines contents)!!0))) :: Integer
    -- putStrLn $ (show prog)
    -- putStrLn $ (show a)

    putStrLn $ "A: " ++ (show (compute prog a))
    let pot = map (\x -> oct x) (rc prog [] [0..8])
    putStrLn $ "B: " ++ (show (copy prog (pot!!0)))
    )


rc :: [Integer] -> [Integer] -> [Integer] -> [[Integer]]
rc prog cur todo
  | length cur == 15 = [cur]
  | length todo == 0 = []
  | snd (splitAt ln res) == snd (splitAt ln prog) = rc prog (cur ++ first) [0..8] ++ rc prog cur left
  | otherwise = rc prog cur left
    where
      res = compute prog (oct (cur ++ (take 1 todo)))
      ln = 16 - (length cur)
      first = take 1 todo
      left = drop 1 todo


oct :: [Integer] -> Integer
oct ls = foldr (+) 0 (zipWith (*) (reverse (map (\x -> 8^x) [0..15])) ls)


copy :: [Integer] -> Integer -> Integer
copy prog a = if (compute prog a) == prog then a
              else copy prog (a+1)


compute :: [Integer] -> Integer -> [Integer]
compute prog a0 = op 0 a0 0 0 (prog!!0) (prog!!1)
  where
    op :: Integer -> Integer -> Integer -> Integer -> Integer -> Integer -> [Integer]
    op i a b c opc opd
      | (fromInteger i) >= (length prog) = []
      | opc == 0 = op j (a `div` (2^(combo opd))) b c n1 n2
      | opc == 1 = op j a (xor b opd) c n1 n2
      | opc == 2 = op j a ((combo opd) `mod` 8) c n1 n2
      | (opc == 3) && (a == 0) = op j a b c n1 n2
      | opc == 3 = op opd a b c (prog!!(fromInteger opd)) (prog!!((fromInteger opd)+1))
      | opc == 4 = op j a (xor b c) c n1 n2
      | opc == 5 = [(combo opd) `mod` 8] ++ op j a b c n1 n2
      | opc == 6 = op j a (a `div` (2^(combo opd))) c n1 n2
      | opc == 7 = op j a b (a `div` (2^(combo opd))) n1 n2
      | otherwise = [-1]
        where
          j = i+2
          n1 = prog!!(fromInteger j)
          n2 = prog!!((fromInteger j)+1)
          combo :: Integer -> Integer
          combo 4 = a
          combo 5 = b
          combo 6 = c
          combo co = co
