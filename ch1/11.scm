(define (f-rec n)
  (if (< n 3)
      n
      (+ (f-rec (- n 1))
         (* 2 (f-rec (- n 2)))
         (* 3 (f-rec (- n 3))))))

(define (f-iter n)
  (if (< n 3)
      n
      (f-inner n 2 1 0)))

(define (f-inner n a b c)
  (if (< n 3)
      a
      (f-inner (- n 1) (+ a (* 2 b) (* 3 c)) a b)))

(f-rec 4)
(f-iter 4)
; 11

(f-rec 5)
(f-iter 5)
; 25

(f-rec 6)
(f-iter 6)
; 59

(f-rec 7)
(f-iter 7)
; 142
