(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; When b is positive, this adds b to a.
; When b is negative, this subtracts b from a.
