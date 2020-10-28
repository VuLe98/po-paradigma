module Main where
import Dijkstra ( generateGraph, getShortestPath )
import System.IO

main = do
    let graph = generateGraph
        path = getShortestPath graph "V1" "V5" 
    print(path)
    