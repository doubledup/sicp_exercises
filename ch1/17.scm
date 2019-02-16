(define (mul a b)
  (if (= b 0)
      0
      (+ a (mul a (- b 1)))))

(define (double x) (* x 2))
(define (halve x) (/ x 2))

(define (fast-mul a b)
  (cond ((= b 1) a)
        ((even? b) (fast-mul (double a) (halve b)))
        (else (+ a (fast-mul a (- b 1))))))

(define (range-iter a b l)
  (if (> a b)
      l
      (range-iter a (- b 1) (cons b l))))
(define (range a b)
  (range-iter a b '()))

(map (lambda (x) (fast-mul 2 x)) (range 1 10))
