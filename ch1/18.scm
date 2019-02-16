(define (double x) (* x 2))
(define (halve x) (/ x 2))

(define (fast-mul a b) (fast-mul-iter a b 0))
(define (fast-mul-iter a b s)
  (cond ((= b 1) (+ a s))
        ((even? b) (fast-mul-iter (double a) (halve b) s))
        (else (fast-mul-iter a (- b 1) (+ s a)))))

(define (range-iter a b l)
  (if (> a b)
      l
      (range-iter a (- b 1) (cons b l))))
(define (range a b)
  (range-iter a b '()))
(map (lambda (x) (fast-mul 2 x)) (range 1 10))
