; Renamed + to add here so that we can run it. If we don't rename our +
; procedure, we can't define inc without using the new definition of +, which
; calls inc itself. Even defining add as below doesn't help, as this still
; calls our newly defined +:
; (define (add x y) (+ x y))

(define (inc x) (+ x 1))
(define (dec x) (- x 1))

(define (add1 a b)
  (if (= a 0)
      b
      (inc (add1 (dec a) b))))

(add1 4 5)

; > (+ 4 5)
; > (inc (+ 3 5))
; > (inc (inc (+ 2 5)))
; > (inc (inc (inc (+ 1 5))))
; > (inc (inc (inc (inc (+ 0 5)))))
; > (inc (inc (inc (inc 5))))
; > (inc (inc (inc 6)))
; > (inc (inc 7))
; > (inc 8)
; > 9
; This process is recursive.

(define (add2 a b)
  (if (= a 0)
      b
      (add2 (dec a) (inc b))))

(add2 4 5)

; > (+ 4 5)
; > (+ 3 6)
; > (+ 2 7)
; > (+ 1 8)
; > (+ 0 9)
; > 9
; This process is iterative.
