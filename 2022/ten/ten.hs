import System.IO

main = do
    withFile "ten.txt" ReadMode (\handle -> do
        contents <- hGetContents handle
        let (val,img) = tick(1,1,lines contents,0,"")
        putStrLn $ "A: " ++ show val
        putStrLn $ "B: \n" ++ img
        )

tick :: (Int, Int, [[Char]], Int, [Char]) -> (Int, [Char])
tick (c, v, [], sum, img) = (sum, img)
tick (c, v, x:xs, sum, img) 
    | inst == "noop" = tick (c+1, v, xs, s, i)
    | inst == "addx" = tick (c+1, v, ("x "++show inc):xs, s, i)
    | otherwise = tick (c+1, v+inc, xs, s, i)
    where
        s = if (elem c [20,60..220]) then sum+c*v else sum
        p = if elem (mod c 40) [v..v+2] then "#" else "."
        i = if (elem c [40,80..240]) then img ++ p ++ "\n" else img ++ p
        inst = head $ words x
        inc = read (last $ words x) :: Int
