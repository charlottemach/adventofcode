import System.IO  

main = do
    withFile "two.txt" ReadMode (\handle -> do
        contents <- hGetContents handle
        let co = move (0,0,lines contents)
        print co
        let co2 = moveB (0,0,0,lines contents)
        print co2
        )

move :: (Int, Int, [[Char]]) -> Int
move (x, y, []) = x * y
move (x, y, ln:lns) 
    | hd == "up" = move (x, y - tl, lns)
    | hd == "down" = move (x, y + tl, lns)
    | otherwise = move (x + tl, y, lns)
    where
        hd = head $ words ln
        tl = read (last $ words ln) :: Int

moveB :: (Int, Int, Int, [[Char]]) -> Int
moveB (x, y, a, []) = x*y
moveB (x, y, a, ln:lns) 
    | hd == "up" = moveB (x, y, a - tl, lns)
    | hd == "down" = moveB (x, y, a + tl, lns)
    | otherwise = moveB (x + tl, y + (tl * a), a, lns)
    where
        hd = head $ words ln
        tl = read (last $ words ln) :: Int
