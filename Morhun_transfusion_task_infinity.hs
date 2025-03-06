import Data.List (nub)

type State = (Int, Int, Int, Int)

capacity :: (Int, Int, Int, Int)
capacity = (9, 4, 7, 1000)  -- 4-та посудина - нескінченне джерело/стік

startStage :: State
startStage = (9, 4, 0, 0)

goalStage :: State -> Bool
goalStage (6, 3, 4, _) = True
goalStage _ = False

transfer :: Int -> Int -> Int -> (Int, Int)
transfer a b maxB =
    let total = a + b
    in if total <= maxB then (0, total) else (total - maxB, maxB)

pour :: State -> [State]
pour (x, y, z, w) =
    let (maxX, maxY, maxZ, maxW) = capacity
    in nub $ filter (/= (x, y, z, w))  -- Виключаємо поточний стан
        [ let (x1, y1) = transfer x y maxY in (x1, y1, z, w)
        , let (x1, z1) = transfer x z maxZ in (x1, y, z1, w)
        , let (y1, z1) = transfer y z maxZ in (x, y1, z1, w)
        , let (y1, x1) = transfer y x maxX in (x1, y1, z, w)
        , let (z1, x1) = transfer z x maxX in (x1, y, z1, w)
        , let (z1, y1) = transfer z y maxY in (x, y1, z1, w)
        , let (x1, w1) = transfer x w maxW in (x1, y, z, w1)
        , let (y1, w1) = transfer y w maxW in (x, y1, z, w1)
        , let (z1, w1) = transfer z w maxW in (x, y, z1, w1)
        , let (w1, x1) = transfer w x maxX in (x1, y, z, w1)
        , let (w1, y1) = transfer w y maxY in (x, y1, z, w1)
        , let (w1, z1) = transfer w z maxZ in (x, y, z1, w1)
        ]

bfs :: [[State]] -> Maybe [State]
bfs [] = Nothing
bfs (path@(current:_) : queue)
    | goalStage current = Just (reverse path)
    | otherwise =
        let newPaths = [next:path | next <- pour current, notElem next path]
        in bfs (queue ++ newPaths)

solve :: Maybe [State]
solve = bfs [[startStage]]

main :: IO ()
main = case solve of
    Just path -> mapM_ print path
    Nothing   -> putStrLn "No solution found"
