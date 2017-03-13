#lang racket
; possibleNumbers is a list from which 6 random values will be removed in order to play
(define possibleNumbers (list 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 25 50 75 100))

; targetNumber is going to be chosen here. This will be the goal number of our calculations
(define targetNumber (random 101 1000))
targetNumber

; The list that we will be populated with 6 random values
(define randomNumbers null)

; The list of all operators
(define operators (list + - * /))

; A racket function that takes a list of values as a parameter and selects 6 random values from it, putting them in the randomNumbers list
(define (getRandomNumbers l)
  (define n (list-ref l (random (length l))))
  (set! randomNumbers (cons n randomNumbers))
  (set! l (remove n l))
  (if (= (length randomNumbers) 6)
      randomNumbers
      (getRandomNumbers l)))

(getRandomNumbers possibleNumbers)

; http://stackoverflow.com/questions/13978595/getting-all-possible-combinations-of-x-booleans-racket-scheme
(define (permutationsWithRepeats size elements)
  (if (zero? size)
      '(())
      (append-map (lambda (p)
                    (map (lambda (e)
                           (cons e p))
                         elements))
                  (permutationsWithRepeats (sub1 size) elements))))

(define numberPerms (combinations (permutations randomNumbers)))
numberPerms

;(define operatorPerms (permutationsWithRepeats 5 operators))

(define combs null)

;(define (combine nums ops)
;  (if (null? ops)
;      '(())
;      (if (number? (car combs))
;          (cons (car (car ops)) (combine nums (cdr (car ops))))
;          (
;  (if (null? nums)
;      '(())
;      (if (number? (car combs))
;          (cons (car numbers) (combine (cdr numbers) operators))
;          (cons 