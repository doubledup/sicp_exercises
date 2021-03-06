; the procedures pascal-layer and pascal-rec both produce recursive processes
; the procedures pascal-iter and pascal produce iterative processes

(define (pascal-layer n)
  (if (= 0 n)
      '(1)
      (let ((pascal-prev (pascal-layer (- n 1))))
        (let ((next-layer (map (lambda (x) (+ (car x) (car (cdr x))))
                               (zip pascal-prev (cdr pascal-prev)))))
          (append
            '(1)
            next-layer
            '(1))))))
; (pascal-layer 500)
; (pascal-layer 0)
; (pascal-layer 1)
; (pascal-layer 2)
; (pascal-layer 3)
; (pascal-layer 4)
; (pascal-layer 5)

(define (range-iter a b l)
  (if (> a b)
      l
      (range-iter a (- b 1) (cons b l))))
(define (range a b)
  (range-iter a b '()))
; (range 0 5)
(define (pascal-rec n)
  (map pascal-layer (range 0 n)))
; (pascal-rec 300)

(define (next-layer prev-layer)
  (append
    '(1)
    (map (lambda (x) (+ (car x) (car (cdr x))))
         (zip prev-layer (cdr prev-layer)))
    '(1)))
; must have i > 0 and (car l) a list of numbers
(define (pascal-iter n i l)
  (cond ((> i n) (reverse l))
        (else (pascal-iter n (+ i 1) (cons (next-layer (car l)) l)))))
(define (pascal n)
  (if (= n 0)
      '(1)
      (pascal-iter n 1 '((1)))))
; (pascal-iter 5 1 '((1)))
; (pascal 5)
; (pascal 15)
; (pascal 300)
