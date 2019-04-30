(define (search-for-primes start end)
  (if (< start end)
    (if (even? start)
        (search-for-primes (+ 1 start) end)
        (begin
          (timed-prime-test start)
          (search-for-primes (+ 2 start) end)))))

(define (timed-prime-test n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (fast-prime? n 1000)
      (report-prime n (- (runtime) start-time))))
; (define (prime? n)
;   (= n (smallest-divisor n)))
; (define (smallest-divisor n)
;   (find-divisor n 2))
; (define (find-divisor n test-divisor)
;   (cond ((> (square test-divisor) n) n)
;         ((divides? test-divisor n) test-divisor)
;         (else (find-divisor n (+ test-divisor 1)))))
; (define (divides? a b)
;   (= (remainder b a) 0))
(define (report-prime prime elapsed-time)
  (newline)
  (display prime)
  (display " *** ")
  (display elapsed-time))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))
(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

; (fast-prime? 1105 100)

(search-for-primes 100000000 100000200)
; ~ 0.05s
(search-for-primes 1000000000 1000000200)
; ~ 0.06s
(search-for-primes 10000000000 10000000200)
; ~ 0.07s
(search-for-primes 100000000000 100000000200)
; ~ 0.08s
(search-for-primes 1000000000000 1000000000200)
; ~ 0.08s

; Increasing the size of the numbers we check by a factor of 10 increases the
; amount of time taken by a constant amount (roughly 0.01s) in most cases.
