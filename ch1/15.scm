(define (cube x) (* x x x))
(define (p x) (begin (display "x") (- (* 3 x) (* 4 (cube x)))))
(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))

(define (range-iter a b l)
  (if (> a b)
      l
      (range-iter a (- b 1) (cons b l))))
(define (range a b)
  (range-iter a b '()))

(map (lambda (x) (begin (sine x) (display "\n"))) (range 1 100))

; (sine 12.15)
; The procedure p is applied 5 times when evaluating (sine 12.15).
; The space and number of steps used by (sine a) grows as (log a) when (sine a) is evaluated.
