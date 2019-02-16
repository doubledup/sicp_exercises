(define (fast-expt-old b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt-old b (/ n 2))))
        (else (* b (fast-expt-old b (- n 1))))))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((= n 1) b)
        (else (fast-expt-iter b (- n 1) b))))

(define (fast-expt-iter b n p)
  (cond ((= n 1) (* b p))
        ((even? n) (fast-expt-iter (square b) (/ n 2) p))
        (else (fast-expt-iter b (- n 1) (* b p)))))

(define (range-iter a b l)
  (if (> a b)
      l
      (range-iter a (- b 1) (cons b l))))
(define (range a b)
  (range-iter a b '()))

(fast-expt-old 2 4)
(map (lambda (x) (fast-expt 2 x)) (range 1 10))
