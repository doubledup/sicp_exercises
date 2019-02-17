(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))
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

(define (next x) (if (= x 2) 3 (+ 2 x)))

; (search-for-primes 100000000 100000200)
; ~ 0.01s
; (search-for-primes 1000000000 1000000200)
; ~ 0.02s
; (search-for-primes 10000000000 10000000200)
; ~ 0.06s
; (search-for-primes 100000000000 100000000200)
; ~ 0.2s
; (search-for-primes 1000000000000 1000000000200)
; ~ 0.6s

; Using the procedure next results in times that are roughly 2/3 of the
; original times.

; This is because we performed 6 operations on most numbers: >, square, divides?, =,
; remainder and + (note that the call to divides? is not free: inlining
; functions decreases execution time). We save on about 6 operations for each
; of half of the numbers between 2 and sqrt(n), but we introduce another 3
; operations to run next (next, = and +) on the remaining sqrt(n)/2 numbers.
; This gives a total of 8 operations for each odd number, replacing 6
; operations on each odd and even number.

; The ratio is 8:12, or 2:3, which is why we see the execution time fall to
; roughly 2/3 of the original.
