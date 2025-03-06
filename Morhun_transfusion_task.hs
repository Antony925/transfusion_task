import Data.List (nub)
import qualified Data.Set as Set

type State = (Int, Int, Int)

capacity :: (Int, Int, Int)
capacity = (9, 4, 7)

startStage :: State
startStage = (9, 4, 0)

goalStage :: State
goalStage = (6, 4, 3)

-- Функція переливання
pour :: State -> [State]
pour (x, y, z) = nub $ filter (`Set.notMember` visited) newStates
  where
    (maxX, maxY, maxZ) = capacity
    newStates = [
        transfer (x, y) maxY (\x' y' -> (x', y', z)),
        transfer (x, z) maxZ (\x' z' -> (x', y, z')),
        transfer (y, x) maxX (\y' x' -> (x', y', z)),
        transfer (y, z) maxZ (\y' z' -> (x, y', z')),
        transfer (z, x) maxX (\z' x' -> (x', y, z')),
        transfer (z, y) maxY (\z' y' -> (x, y', z'))
      ]
    visited = Set.empty  -- уникаємо повторень

-- Переливаємо воду між двома ємностями
transfer :: (Int, Int) -> Int -> (Int -> Int -> State) -> State
transfer (a, b) maxB f
  | a + b <= maxB = f 0 (a + b)
  | otherwise     = f (a - (maxB - b)) maxB

-- Пошук у ширину (BFS)
bfs :: [[State]] -> Set.Set State -> [State]
bfs [] _ = []
bfs (path@(current:_):rest) visited
  | current == goalStage = reverse path
  | otherwise =
      let newStates = filter (`Set.notMember` visited) (pour current)
          newPaths = map (:path) newStates
          newVisited = foldr Set.insert visited newStates
      in bfs (rest ++ newPaths) newVisited

solve :: [State]
solve = bfs [[startStage]] Set.empty

main :: IO ()
main = print solve
