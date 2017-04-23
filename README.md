# Racket-numbers-game
Module: Theory of Algorithms
Lecturer: Ian McLoughlin
#### Project spec
For this project, I was asked to create a solution finder for the Countdown numbers round (https://en.wikipedia.org/wiki/Countdown_(game_show)#Numbers_round) in Racket. This meant using a functional programming language for the first time to solve a tricky enough problem.

#### Features of the project
To accomplish the task at hand, I had to create multiple functions that would work together to generate and check all possible solutions and return if any of them match the target number.

I started off by defining some key "variables" at the top of my script.
**possibleNumbers** is a list of all the possible values that the randomNumbers could be taken from.
**targetNumber** is the number I'm trying to find a solution for using the random numbers. This itself is a random number between 101 and 999.

The method **getRandomNumbers** deals with predefined variables so the **!set** function was to be used to update them.
This method takes a value at a random index(n) from the possibeNumbers list and adds it to the randomNumbers list.
I decided to give this method a parameter called size that to make it more scalable, however this functionality was not used further in the code.

**combineNumsOps** is a method that takes a list of numbers and a list of operators and combines them.
After checking if the list of nums is null (the end clause), the method checks if the ops from the parameters is a list.
```racket
(if (not (list? ops))
    (flatten (cons (cons (car nums) ops) (car (cdr nums)))) 
```
This was done because for a list of 2 numbers, only one operator can stand in between, hence it's not a list.
Flatten(procedure) is also used here to combine two lists into one.
If ops is a list, the method just checks back and forth between the length of nums and ops until all elements are used up.


**combineNumsAllOps** is a method that uses combineNumsOps, but for all the different permutations of the operators.

**generatePossibilites**, like combineNumsAllOps does the same thing, but this time with all the number permutations as well.


**evaluate** is a function that takes a list like (1 + 2 + 3 + 4) and evaluates it to 10. This function is used when evaluating every possiblity for the target number.
In here, I have error handling to check division by zero, as this is where I was getting the error.
```racket
(with-handlers ([exn:fail:contract:divide-by-zero?
                   (lambda (e) (cond
                                 [(or (eq? (car (cdr list)) +) (eq? (car (cdr list)) -))
                                  0]
                                 [else 1]))])
```
If an error was found, it would return a 0 if evaluate was trying to add or subtract numbers and 1 for multiplying and dividing  (Their respective identities).


**validExpr** is a function that checks if at any point in the maths expression there will be a division into fractions or subtraction into negative numbers (part of spec).
However, because of the way I do evaluation of my maths expressions, this method isn't there to check the recursive state of evaluate and so can't predict exactly what will happen.

**cdadr** is a simple function that simply returns the element of the big list (a list of lists) minus it's head

**evalAll** is a composite function of evaluate and generatePossibilities (just combines their functionality)
**checkAll** checks all different sizes of lists that are possible and returns solutions (if any)