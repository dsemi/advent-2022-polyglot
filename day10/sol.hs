{-# LANGUAGE ViewPatterns #-}

module Main where

import Data.Maybe
import Text.Printf

-- First section is for OCR
smallK :: String
smallK =
    unlines
    [ " ##  ###   ##  #### ####  ##  #  # ###   ## #  # #     ##  ###  ###   ### #  # #   # ####"
    , "#  # #  # #  # #    #    #  # #  #  #     # # #  #    #  # #  # #  # #    #  # #   #    #"
    , "#  # ###  #    ###  ###  #    ####  #     # ##   #    #  # #  # #  # #    #  #  # #    # "
    , "#### #  # #    #    #    # ## #  #  #     # # #  #    #  # ###  ###   ##  #  #   #    #  "
    , "#  # #  # #  # #    #    #  # #  #  #  #  # # #  #    #  # #    # #     # #  #   #   #   "
    , "#  # ###   ##  #### #     ### #  # ###  ##  #  # ####  ##  #    #  # ###   ##    #   ####"
    ]
smallV :: String
smallV = "ABCEFGHIJKLOPRSUYZ"

removeNewlines :: String -> String
removeNewlines = dropWhile (`elem` "\r\n") . foldr f []
    where f c [] = if c `elem` "\r\n" then [] else [c]
          f c s = c:s

separateLetters :: String -> [String]
separateLetters (removeNewlines -> input) = go (replicate (length lns) "") lns
    where lns = lines input
          ht (x:xs) = (x, xs)
          ht [] = error "0 length"
          go sofar lss
              | all null lss = if '#' `elem` letter then [letter] else []
              | any (=='#') col = go (zipWith (:) col sofar) lss'
              | '#' `elem` letter = letter : go (replicate (length lns) "") lss'
              | otherwise = go (replicate (length lns) "") lss'
              where (col, lss') = unzip $ map ht lss
                    letter = init $ unlines $ map reverse sofar

smallLetters :: [(String, Char)]
smallLetters = zip (separateLetters smallK) smallV

parseLetters :: String -> String
parseLetters = map get . separateLetters
    where get k = fromMaybe (error $ "Letter not found: " ++ k) $ lookup k smallLetters

-- Actual solution below
run :: String -> [Int]
run = scanl (+) 1 . map go . init . words
    where go "addx" = 0
          go "noop" = 0
          go n = read n

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = let (ys, zs) = splitAt n xs
             in ys : chunk n zs

solve :: String -> String
solve input = printf "Part 1: %20d\nPart 2: %20s\n" p1 p2
    where states = run input
          p1 = sum $ map (uncurry (*)) $ filter ((== 20) . (`mod` 40) . fst) $ zip [1..] states
          p2 = parseLetters $ unlines $ chunk 40
               $ zipWith (\c x -> if abs (c `mod` 40 - x) <= 1 then '#' else ' ') [0..] states

main :: IO ()
main = do
  putStrLn "Day 10: Haskell"
  interact solve
