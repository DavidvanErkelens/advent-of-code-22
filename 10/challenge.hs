import System.IO

data Instruction = Noop | AddX { amount :: Int } deriving (Show)

parseLine :: String -> Instruction
parseLine line
  | instruction == "noop" = Noop
  | instruction == "addx" = AddX (read $ elements !! 1)
  where elements = words line
        instruction = head elements

processOperation :: Instruction -> [Instruction]
processOperation Noop = [Noop]
processOperation x = [Noop, x]

executeOperation :: Int -> Instruction -> Int
executeOperation x Noop = x
executeOperation x value = x + (amount value)

getPixelValue :: Int -> Int -> Char
getPixelValue cycle x
  | pixelPos `elem` spritePos = '#'
  | otherwise = '.'
  where pixelPos = ((cycle - 1) `mod` 40)
        spritePos = [x - 1, x, x + 1]

group :: Int -> [a] -> [[a]]
group _ [] = []
group n l = (take n l) : (group n (drop n l))

main = do
  contents <- readFile "input/input.txt"
  let parsedLines = map parseLine $ lines contents

  -- Insert extra noop for addX operations to simulate it taking two cycles
  let operationAtCycle = foldl (\acc op -> acc ++ (processOperation op)) [] parsedLines
  let registerAfterCycle = scanl (\acc op -> executeOperation acc op) 1 operationAtCycle
  let cyclesToInspect = [20,60 .. (length registerAfterCycle)]
  let partOneSum = foldl (\acc idx -> acc + (idx * (registerAfterCycle !! (idx - 1)))) 0 cyclesToInspect

  print $ show partOneSum

  -- Part 2
  let pixelsDrawn = map (\idx -> (getPixelValue idx (registerAfterCycle !! (idx - 1)))) [1 .. ((length registerAfterCycle))]
  putStr $ unlines $ group 40 pixelsDrawn