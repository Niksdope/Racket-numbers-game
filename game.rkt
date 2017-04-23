#lang racket
; possibleNumbers is a list from which 6 random values will be removed in order to play
(define possibleNumbers (list 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 25 50 75 100))

; targetNumber is going to be chosen here. This will be the goal number of our calculations
(define targetNumber (random 101 1000))
targetNumber

; The list that we will be populated with 6 random values
(define randomNumbers null)

; The list of all operators
(define ops (list + - * /))
(define allOps (cartesian-product ops ops ops ops ops))

; A racket function that takes a list of values as a parameter and selects 6 random values from it, putting them in the randomNumbers list
(define (getRandomNumbers l size)
  (define n (list-ref l (random (length l))))
  (set! randomNumbers (cons n randomNumbers))
  (set! l (remove n l))
  (if (= (length randomNumbers) size)
      randomNumbers
      (getRandomNumbers l size)))

(getRandomNumbers possibleNumbers 6)
(define allNums (permutations randomNumbers))

; Combine the numbers and operators of 2 lists
(define (combineNumsOps nums ops)
  (if (null? nums)
      '()
      (if (not (list? ops)) ; Check if the ops is a list of operators or a single procedure (e.g. +)
          (flatten (cons (cons (car nums) ops) (car (cdr nums)))) 
          (if (> (length nums) (length ops))
              (cons (car nums) (combineNumsOps (cdr nums) ops))
              (cons (car ops) (combineNumsOps nums (cdr ops)))))))

; Combine all op variations to one nums list
(define (combineNumsAllOps nums ops)
  (if (null? ops)
      '()
      (cons (combineNumsOps nums (car ops)) (combineNumsAllOps nums (cdr ops)))))

; Generate a list of all possibilities
(define (generatePossibilities nums ops)
  (if (null? nums)
      '()
      (cons (combineNumsAllOps (car nums) ops) (generatePossibilities (cdr nums) ops))))

; Procedure to check if in the equation at any point fractions or negative numbers happen
(define (validExpr list)
  (if (< (length list) 2)
      #t
      (cond
        [(eq? (car (cdr list)) /)
             (if (= (modulo (car list) (car (cdr (cdr list)))) 0)
                 (validExpr (cdr (cdr list)))
                 #f)]
        [(eq? (car (cdr list)) -)
             (if (< (- (car list) (car (cdr (cdr list)))) 0)
                 #f
                 (validExpr (cdr (cdr list))))]
        [else (validExpr (cdr (cdr list)))])))
                 
; Take a normal maths expression and evaluate it
(define (evaluate list)
  (with-handlers ([exn:fail:contract:divide-by-zero?
                   (lambda (e) (cond
                                 [(or (eq? (car (cdr list)) +) (eq? (car (cdr list)) -))
                                  0]
                                 [else 1]))]) ; Put in error handling if at some time in the recursion the script is trying to divide by zero
  (if (= (length list) 1)
      (car list)
      ((car (cdr list)) (car list) (evaluate (cdr (cdr list)))))))

; Mini-function to take off the head of the head of the list (racket version of this procedure is not what I need)
(define (cdadr list)
  (cons (cdar list) (cdr list)))

; Evaluate every answer and return successful ones (ones that equal the targetNumber)
(define (evalAll list)
  (if (null? list)
      '()
      (if (null? (car list))
          (evalAll (cdr list))
          (if (not (validExpr (caar list)))
              (evalAll (cdadr  list))
              (if (= (evaluate (caar list)) targetNumber)   
                  (cons (caar list) (evalAll (cdadr list)))
                  (evalAll (cdadr list)))))))

;(evalAll (remove-duplicates (generatePossibilities allNums allOps)))
;(evaluate (list 50 * 4 + 7 * 1))

; Method to get a smaller size of permutations from a big perms list (Basically just shaves the tail of the list)
(define (perms size list)
  (if (null? list)
      '()
      (cons (take (car list) size) (perms size (cdr list)))))

; Defined a method here to check number lists of size 6, 5, 4, 3 and 2
(define (checkAll)
  (evalAll (generatePossibilities allNums allOps))
  (evalAll (generatePossibilities (perms 5 allNums) (perms 4 allOps)))
  (evalAll (generatePossibilities (perms 4 allNums) (perms 3 allOps)))
  (evalAll (generatePossibilities (perms 3 allNums) (perms 2 allOps)))
  (evalAll (generatePossibilities (perms 2 allNums) ops)))

(remove-duplicates (checkAll))