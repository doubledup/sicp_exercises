(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

; `sqrt-iter` will never terminate. Since Scheme uses applicative order
; evaluation, it will attempt to evaluate all of the arguments to `new-if` before
; applying `new-if`.  The 3rd argument is another call to `sqrt-iter`.  To
; evaluate this, scheme also has to evaluate a `new-if` call that has a call to
; `sqrt-iter` as its 3rd argument. So to evaluate any call to `sqrt-iter`, the
; interpreter has to evaluate a call to `sqrt-iter`. This circular evaluation
; prevents the program from terminating.

; This is because sqrt-iter is a regular function that has to have all of it's
; arguments evaluated before it is applied (since Scheme use applicative order
; evaluation). Instead, it could be a special form that only evaluates either the
; consequent or alternative depending on the value of the predicate. This would
; prevent scheme from having to evaluate `sqrt-iter` even when the guess is good
; enough.
