type Position = (Int,Int)
data Color = W | B deriving (Eq, Show)
data Peg = Peg Position Color deriving (Eq, Show)
data Move = M Position deriving (Eq, Show)
type Board = [Peg]
data State = S Move Board deriving (Eq, Show)


validPos (a,b) = (a <= 1 && a >= -1 && b <= 3 && b >= -3)
					||(b >= -1 && b <= 1 && a >= -3 && a <= 3)
					
					
createBoard (a,b) | validPos (a,b) = createBoardH (-3,-1) (a,b)
				  |otherwise = error "Program error: The position is not valid."
				  
				  
createBoardH (i,j) (a,b) | i==a && j==b = [(Peg (a,b) W)] ++ (createBoardH (getNextPos (i,j)) (a,b))	 
						| (i/= a || j/=b) && (validPos (i,j))  = [(Peg (i,j) B)] ++ (createBoardH (getNextPos (i,j)) (a,b))	  
						| otherwise = []
						
						
getNextPos (a,b) | a == -3 && b == 1 = (-2,-1)
				 | a == -2 && b == 1 = (-1,-3)
				 | a == -1 && b == 3 = (0,-3)
				 | a == 0 && b == 3  = (1,-3)
				 | a == 1 && b == 3  = (2,-1)
				 | a == 2 && b == 1  = (3,-1)
				 |otherwise =(a,(b+1))

isValidMove (M (a,b)) ((Peg (c,d) W): x) =     (checkPos (a+1,b) ((Peg (c,d) W): x))
											|| (checkPos (a-1,b) ((Peg (c,d) W): x))
											|| (checkPos (a,b+1) ((Peg (c,d) W): x))
											|| (checkPos (a,b-1) ((Peg (c,d) W): x))

isValidMove (M (a,b)) ((Peg (c,d) B): x) = 	   (checkPos (a+1,b) ((Peg (c,d) B): x))
											|| (checkPos (a-1,b) ((Peg (c,d) B): x))
											|| (checkPos (a,b+1) ((Peg (c,d) B): x))
											|| (checkPos (a,b-1) ((Peg (c,d) B): x))											
											
checkPos (a,b) ((Peg (c,d) W): x)  | (not (validPos (a,b))) = False
								   | a==c && b ==d = True
								   |otherwise = (checkPos (a,b) x)

checkPos (a,b) ((Peg (c,d) B): x)  | (not (validPos (a,b))) = False
								   |otherwise = (checkPos (a,b) x)
	
checkPos (a,b) [] =False


isGoal [(Peg (a,b) W)] = True
isGoal ((Peg (a,b) W):s) = isGoal s
isGoal ((Peg (a,b) B):s) = False
isGoal [(Peg (a,b) B)] = False
isGoal [] = False


showPossibleNextStates ((Peg (a,b) W):s)  | (isGoal ((Peg (a,b) W):s)) = error "Program error: No Possible States Exist."
										  |otherwise = (returnAll (showPossibleNextStatesH ((Peg (a,b) W):s) ((Peg (a,b) W):s)) ((Peg (a,b) W):s))
showPossibleNextStates ((Peg (a,b) B):s) = (returnAll (showPossibleNextStatesH ((Peg (a,b) B):s) ((Peg (a,b) B):s)) ((Peg (a,b) B):s))

showPossibleNextStatesH ((Peg (a,b) B):s) l  |(isValidMove (M (a,b) ) l)=[(Peg (a,b) W)]++(showPossibleNextStatesH s l)
											  |otherwise =(showPossibleNextStatesH s l)

showPossibleNextStatesH ((Peg (a,b) W):s) l = (showPossibleNextStatesH s l)
showPossibleNextStatesH [] l = []

returnAll [(Peg (a,b) W)] ((Peg (c,d) B):x) = [(S (M (a,b)) (flipPeg (Peg (a,b) W) ((Peg (c,d) B):x)))]
returnAll [(Peg (a,b) W)] ((Peg (c,d) W):x) = [(S (M (a,b)) (flipPeg (Peg (a,b) W) ((Peg (c,d) W):x)))]
returnAll ((Peg (a,b) W):s) ((Peg (c,d) W):x)= [(S (M (a,b)) (flipPeg (Peg (a,b) W) ((Peg (c,d) W):x)))] ++ (returnAll s ((Peg (c,d) W):x))
returnAll ((Peg (a,b) W):s) ((Peg (c,d) B):x)= [(S (M (a,b)) (flipPeg (Peg (a,b) W) ((Peg (c,d) B):x)))] ++ (returnAll s ((Peg (c,d) B):x))


flipPeg (Peg (a,b) W) ((Peg (c,d) B):s) | a==c && b == d = ([(Peg (a,b) W)] ++s)
										| otherwise = [(Peg (c,d) B)]++(flipPeg (Peg (a,b) W) s)
										
flipPeg (Peg (a,b) W) ((Peg (c,d) W):s) | a==c && b == d = ([(Peg (a,b) W)] ++s )
										| otherwise = [(Peg (c,d) W)]++(flipPeg (Peg (a,b) W) s)
				 
flipPeg (Peg (a,b) W)  [] =[]