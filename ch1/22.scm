(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))
(define (timed-prime-test n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime n (- (runtime) start-time))))
(define (report-prime prime elapsed-time)
  (newline)
  (display prime)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes start end)
  (if (< start end)
    (if (even? start)
        (search-for-primes (+ 1 start) end)
        (begin
          (timed-prime-test start)
          (search-for-primes (+ 2 start) end)))))

; (search-for-primes 1000 1020)
; (search-for-primes 10000 10050)
; (search-for-primes 100000 100100)
; (search-for-primes 1000000 1000100)
; (search-for-primes 10000000 10000200)
; (search-for-primes 100000000 100000200)
; ~ 0.01s
; (search-for-primes 1000000000 1000000200)
; ~ 0.03s
; (search-for-primes 10000000000 10000000200)
; ~ 0.09s
; (search-for-primes 100000000000 100000000200)
; ~ 0.3s
; (search-for-primes 1000000000000 1000000000200)
; ~ 0.9s

; The timing data do show an increase of a little over 3 (roughly sqrt(10))
; fold when the size of the numbers tested increases by 10 times.
; This ratio is relatively consistent across the different input sizes.
; The time increase seen is approximately the increase in the number of steps
; required for the computation. This shows that the time taken is likely
; proporional to the number of steps taken.
