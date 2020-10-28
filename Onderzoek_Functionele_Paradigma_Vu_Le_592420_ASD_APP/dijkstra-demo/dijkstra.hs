module Dijkstra(
    generateGraph,
    getShortestPath
) where

import Data.List
import System.IO

data Edge = Edge {destination::Vertex, cost::Weight} deriving (Show)
type Weight = Float
type Vertex = String
type Graph = [(Vertex, [Edge])]
type DestinationVertex = (Vertex, (Weight, Vertex)) -- Also known as a path in a graph

type AdjacentEdge = ((Vertex, Vertex), Weight)
type AdjacentEdges = [AdjacentEdge]

-- Create test edges (Edge: (vertex, vertex), cost)
edge0:: AdjacentEdge
edge0 = (("V0","V1"), 2)
edge1:: AdjacentEdge
edge1 = (("V0","V3"), 1)
edge2:: AdjacentEdge
edge2 = (("V1","V3"), 3)
edge3:: AdjacentEdge
edge3 = (("V1","V4"), 10)
edge4:: AdjacentEdge
edge4 = (("V2","V0"), 4)
edge5:: AdjacentEdge
edge5 = (("V2","V5"), 5)
edge6:: AdjacentEdge
edge6 = (("V3", "V2"), 2)
edge7:: AdjacentEdge
edge7 = (("V3", "V4"), 2)
edge8:: AdjacentEdge
edge8 = (("V3", "V5"), 8)
edge9:: AdjacentEdge
edge9 = (("V3", "V6"), 4)
edge10:: AdjacentEdge
edge10 = (("V4", "V6"), 6)
edge11:: AdjacentEdge
edge11 = (("V6", "V5"), 1)

-- Generate edges
aEdges:: AdjacentEdges
aEdges = [edge0] ++ [edge1] ++ [edge2] ++ [edge3] ++ [edge4] ++ [edge5] ++ [edge6] ++ [edge7] ++ [edge8] ++ [edge9] ++ [edge10] ++ [edge11]

-- Example of how immutability works:

-- aEdges = []

-- addEdge :: AdjacentEdge -> AdjacentEdges
-- addEdge edge = aEdges ++ [edge]

-- Get edges of the specified vertex
vertexEdges :: Graph -> Vertex -> [Edge]
vertexEdges graph vertex = snd . head . filter(\(v, _) -> v == vertex) $ graph

-- In order to find the shortest distance from all vertex to a given destination vertex 
-- we reverse all the edges of the directed graph and use the destination vertex as the source vertex in dijkstra’s algorithm (in generateGraph (destination)). 
reverseEdges :: [((Vertex, Vertex), Weight)] -> [((Vertex, Vertex), Weight)]
reverseEdges elements = elements ++ map (\((vertex1, vertex2), weight) -> ((vertex2, vertex1), weight)) elements

-- Generate the graph based on the test edges. 
generateGraph :: Graph
generateGraph = 
    let adjacentEdges = getAllAdjacentEdges
        -- Get all the names of the vertices in one list, nub is used to get the duplicate values out of the list
        -- when mapping the edges. 
        vertices = nub . map(fst . fst) $ adjacentEdges
        -- Get the edges of the destination vertex
        vertexEdges adjacentEdges destination = 
            let connected = filter (\((v,_),_) -> destination == v) $ adjacentEdges
            in map (\((_,v),cost) -> Edge v cost) connected 
        in map (\v -> (v, vertexEdges adjacentEdges v)) vertices       

getAllAdjacentEdges :: AdjacentEdges
getAllAdjacentEdges = let elements = reverseEdges $ aEdges
                        in elements

-- Get the cost of the specified vertex
getCost :: Vertex -> [Edge] -> Weight
getCost vertex = cost . head . filter (\e -> vertex == destination e)

-- Get connected vertices
connectedVertices :: [Edge] -> [Vertex]
connectedVertices = map destination

-- Initialisation of the initial list of vertices
initializeVertex :: Graph -> Vertex -> [DestinationVertex]
initializeVertex graph vertex =
    let costInit (v, edges) =                      
            if v == vertex                        
            then 0
            else if (vertex `elem` connectedVertices edges)
                then getCost vertex edges          
                else 1e10                              
    in map (\graphElement@(v,_) -> (v, ((costInit graphElement), vertex))) graph

-- If a destination vertex is given, the current destination vertex, 
-- the vertices connected to the current destination vertex and the current destination vertex's edges 
-- return a updated destination vertex. Update the current cost when the current cost of a vertex is smaller than the updated cost.
updateVertex :: DestinationVertex -> DestinationVertex -> [Vertex] -> [Edge] -> DestinationVertex
updateVertex destinationVertex@(vertex, (cost, previousVertex)) (current, (currentCost, _)) collectionOfVertices edges =
    let vertexCost = getCost vertex edges
        updatedCost = currentCost + vertexCost
    in  if (vertex `notElem` collectionOfVertices) -- Check if destination vertex is in the queue of vertices
             then destinationVertex
        else if (updatedCost < cost) 
             then (vertex, (updatedCost, current)) 
             else destinationVertex

-- Dijkstra (recursive)
dijkstraRecursive :: Graph -> [DestinationVertex] -> [Vertex] -> [DestinationVertex] 
-- Make an empty list of DestinationVertices when performing Dijkstra
dijkstraRecursive graph destinationVertices [] = destinationVertices
dijkstraRecursive graph destinationVertices queue =
    let destinationVerticesInQueue = filter (\destinationVertex -> (fst destinationVertex) `elem` queue) destinationVertices -- Get a list of destination vertices that haven't been checked yet
        --DestinationVertex is the chosen vertex with previous chosen vertex (if there is one). The shortest DestinationVertex is chosen. 
        shortestDestinationVertex = getShortestDestinationVertex destinationVerticesInQueue
        currentVertexInQueue = getCurrentVertexInQueue shortestDestinationVertex
        -- Delete the current vertex in the queue of DestinationVertices
        updatedQueue = delete currentVertexInQueue queue
        -- Get edges of current vertex in queue
        edges = vertexEdges graph currentVertexInQueue
        -- Get new collection of vertices after current vertex has been removed from the queue
        collectionOfVertices = intersect (connectedVertices edges) updatedQueue
        -- Update list of destination vertices after current vertex has been removed from the queue
        updatedDestinationVertices = map (\destinationVertex -> updateVertex destinationVertex shortestDestinationVertex collectionOfVertices edges) destinationVertices
        --Recursive method to perform Dijkstra until all destination vertices have been cleared
    in dijkstraRecursive graph updatedDestinationVertices updatedQueue

getShortestDestinationVertex :: [DestinationVertex] -> DestinationVertex
getShortestDestinationVertex destinationVertices = 
    -- First sort the destination vertices by distance by looping through all the destinationVertices and comparing the cost of a pair of destinationVertices,
    -- to pick the destination (path) with the shortest distance (distance in ascending order), and then get the first element of the list (the one with the shortest distance) 
    let shortestDestinationVertex = head . sortBy (\(_,(cost1, _)) (_,(cost2,_)) -> compare cost1 cost2) $ destinationVertices
    in shortestDestinationVertex

getCurrentVertexInQueue :: DestinationVertex -> Vertex
getCurrentVertexInQueue shortestDestinationVertex = 
    -- Get the current vertex in the queue, we call fst because we want the first element of the DestinationVertex, which is the name of the chosen DestinationVertex
    let currentVertexInQueue = fst shortestDestinationVertex 
    in currentVertexInQueue

dijkstra :: Graph -> Vertex -> [DestinationVertex]
dijkstra graph startVertex =
    let destinationVertices = initializeVertex graph startVertex
        -- Add DestinationVertex of startname (for example V2 in the 'main.hs'-file) in the queue
        queue = map fst destinationVertices
        in dijkstraRecursive graph destinationVertices queue

-- Get path information for the destination vertex, filter is to check if one of the destination vertices matches the destination vertex as 
destinationVertexForVertex :: [DestinationVertex] -> Vertex -> DestinationVertex
destinationVertexForVertex destinationVertices currentDestVertex = head . filter (\(destVertex, _) -> (destVertex == currentDestVertex)) $ destinationVertices

-- Return the result of the shortest path when Dijkstra has been executed (let start in 'pack'-function below)
-- and a destination vertex has been given in the main-function (main.hs)
result :: [DestinationVertex] -> Vertex -> [Vertex]
result destinationVertices destinationVertex =
    let getDestinationVertex@(vertex, (cost, previousVertex )) = destinationVertexForVertex destinationVertices destinationVertex
    in 
        if vertex == previousVertex 
            then [vertex] 
            else result destinationVertices previousVertex ++ [vertex]


getShortestPath :: Graph -> Vertex -> Vertex -> [Vertex] 
getShortestPath graph startVertex destinationVertex =
    let start = dijkstra graph startVertex
    in result start destinationVertex