module Main where

import Text.Printf

run :: String -> [(Int, Int)]
run = zip [1..] . scanl (+) 1 . map go . init . words
    where go "addx" = 0
          go "noop" = 0
          go n = read n

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = let (ys, zs) = splitAt n xs
             in ys : chunk n zs

solve :: String -> String
solve input = printf "Part 1: %20d\nPart 2: %20s" p1 p2
    where states = run input
          p1 = sum $ map (uncurry (*)) $ filter ((`elem` [20, 60, 100, 140, 180, 220]) . fst) states
          p2 = ('\n':) $ unlines $ chunk 40
               $ map (\(c, x) -> if abs ((c - 1) `mod` 40 - x) <= 1 then '#' else ' ') states

main :: IO ()
main = do
  putStrLn "Day 9: Haskell"
  interact solve
