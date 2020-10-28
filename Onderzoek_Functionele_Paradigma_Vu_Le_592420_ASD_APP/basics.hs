-- Standard function that returns the double of the input number
doubleMe x = x + x

-- A function with an if-else statement that describes when an number
-- is even, return double the input number. Or else the same number as what you've input.
doubleWhenNumberIsEven' x = (if x `mod` 2 == 0 then x + x else x)

-- Switch-case statement to check which grade an child belongs in school. 
getSchoolClassOfChild :: Int -> String
getSchoolClassOfChild grade = case grade of
    5 -> "Go to Kindergarten"
    6 -> "Go to elementary school"
    _ -> "Go away"

-- Example of a list
grades = [1,2,3,4,5]

-- Add the list 'grades' to a new list called moreGrades, which contains more grades. 
moreGrades = grades ++ [6,7,8,9,10]

-- Grades with 'range' list
gradesWithRange = [1..10]
alphabetRange = ['a'..'z']

-- Example of pattern matching, with a function with the same name called 'activity'
activity :: String -> String
activity "" = "Activity: nothing"
activity act = "Activity: " ++ act

addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)  
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)  

-- Recursion for-loop
countDown n =
    if n > 0 
        then
        do 
            print(n)
            countDown(n - 1)
    else
        print(n)

        
-- Quicksort
quicksort :: (Ord a) => [a] -> [a]  
quicksort [] = []  
quicksort (x:xs) =   
    let smallerSorted = quicksort [a | a <- xs, a <= x]  
        biggerSorted = quicksort [a | a <- xs, a > x]  
    in  smallerSorted ++ [x] ++ biggerSorted  

-- Map type signature and sample implementation

-- map :: (a -> b) -> [a] -> [b]  
-- map _ [] = []  
-- map f (x:xs) = f x : map f xs  

-- Filter type signature and sample implementation

-- filter :: (a -> Bool) -> [a] -> [a]  
-- filter _ [] = []  
-- filter p (x:xs)   
--     | p x       = x : filter p xs  
--     | otherwise = filter p xs 




 
