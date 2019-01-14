(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

(test 0 (p))

; With an interpreter that uses applicative-order evaluation, Ben will never get
; a result, as the program tries to evaluate `(p)` (which returns itself) before
; applying `test`. The definition of `p` is the evaluation of `p`, so the program
; will never finish evaluating `p` and will not halt.

; With an interpreter that uses normal-order evaluation, Ben will get the result
; 0. This is because the procedure `test` gets expanded first (before the
; argument `(p)`), then its if expression returns 0.
; The operand `(p)` wouldn't be evaluated, as `test` gets expanded first and it
; turns out that the value of `(p)`, the second argument to `test`, isn't needed.
