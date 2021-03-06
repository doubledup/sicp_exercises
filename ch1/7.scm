(define (square x) (* x x))

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

; Our `good-enough?` procedure isn't very effective for small numbers because, as
; the number we're taking the root of gets smaller, any guess whose square is
; less than 0.001 becomes "good enough". This is because the square of the guess
; is within 0.001 of all numbers from 0 to 0.001:

; We've decided that a guess is good enough when its square is within 0.001 of
; the number we're given (x). When x is very small (less than 0.001), our sqrt
; procedure stops once the square of the guess is about 0.001, since the guess is
; now good enough for any number between 0 and 0.001.

; eg. if we square our square root approximation, we expect to get the original
; number back, within our threshold of 0.001 (since that's what we've decided
; `good-enough?` should check). Trying this with successively smaller powers of
; 10, we see that, once the original number gets smaller than 0.001, the result
; is approximately 0.001 regardless of what the original number was:

; > (square (sqrt 0.1))
; 0.10001125566203942
; > (square (sqrt 0.01))
; 0.01006526315785885
; > (square (sqrt 0.001))
; 0.0017011851721075596
; > (square (sqrt 0.0001))
; 0.0010438358335233748
; > (square (sqrt 0.00001))
; 0.0009832294718753643
; > (square (sqrt 0.000001))
; 0.0009772285838805523
; > (square (sqrt 0.0000001))
; 0.000976629102245155
; > (square (sqrt 0.00000001))
; 0.000976569160163076

; Note: for numbers less than 0.001, our square root approximation doesn't
; necessarily return a number whose square is less than 0.001, just a number
; that's approximately 0.001. As seen in the example above for 0.0001, even
; though the number is less than 0.001, the square of the root we find is greater
; than 0.001. This is just because it's the first guess we find that's within
; 0.001 of the original number.

; ________________________________________________________________________________

; From here on we use an updated version of `improve` to show the intermediate
; guesses:

(define (improve guess x)
  (begin
    (println guess)
    (average guess (/ x guess))))

; Our `good-enough?` procedure is inadequate for large numbers because we need to
; have enough precision to represent numbers smaller than 0.001 in the result of
; our subtraction `(- (square guess) x)`. When x is large enough, this subtraction
; ends up always producing a number greater than 0.001.

; To represent a reasonable approximation of 0.001 as a floating point binary
; number, we need to at least be able to represent 2**-10. This means we need at
; least 10 binary digits for negative powers of 2. IEEE 754 floating point
; numbers (the standard used in most computers) have 53 significant binary digits
; in their significand, so if we need 10 of these for negative exponents, we only
; have 43 left for non-negative ones. This means we can represent 0.001* in any
; large floating point number less than 2**43:

; > (+ 0.001 (- (expt 2.0 43) 1))
; 8796093022207.001
; > (+ 0.001 (expt 2.0 43))
; 8796093022208.002
; > (+ 0.001 (- (expt 2.0 44) 1))
; 17592186044415.002
; > (+ 0.001 (expt 2.0 44))
; 17592186044416.0

; 2**43 is the smallest number that requires 44 binary digits for non-negative
; powers of 2, leaving only 9 digits for negative powers, which isn't enough to
; represent 2**-10.

; Without at least 10 binary digits for negative powers of 2, the subtraction in
; our `good-enough?` function can only produce either 0 or at least 2**-9: we
; can't represent a number in between.  If the subtraction in `good-enough?`
; gives us 0, we consider the guess good enough and our program halts. If it
; doesn't give us 0, we try to improve it. Either the improvements eventually
; give us 0 for our subtraction (so that our guess is good enough), or we end up
; getting the same number back from `improve` (we find a fixed point of
; `improve`) that still gives us a non-zero difference. In this case, our program
; never halts as we improve the guess, get the same number back, see that it's
; not good enough and try to improve it again:

; > (square (sqrt (- (expt 2.0 43) 1)))
; 1.0
; 4398046511104.0
; 2199023255553.0
; 1099511627778.5
; 549755813893.25
; 274877906954.625
; 137438953493.3125
; 68719476778.65625
; 34359738453.328125
; 17179869354.664062
; 8589934933.33203
; 4294967978.665995
; 2147485013.3328347
; 1073744554.6651154
; 536876373.322141
; 268446378.5777382
; 134239572.622235
; 67152548.97882563
; 33641767.85605315
; 16951615.65799754
; 8735254.869318409
; 4871109.768821101
; 3338438.7691578055
; 2986615.573400723
; 2965893.194167331
; 2965820.8016412044
; 8796093022206.999
; > (square (sqrt (expt 2.0 43)))
; 1.0
; 4398046511104.5
; 2199023255553.25
; 1099511627778.625
; 549755813893.3125
; 274877906954.65625
; 137438953493.32812
; 68719476778.66406
; 34359738453.33203
; 17179869354.666016
; 8589934933.333006
; 4294967978.666483
; 2147485013.333079
; 1073744554.6652374
; 536876373.3222021
; 268446378.57776874
; 134239572.62225026
; 67152548.97883326
; 33641767.856056966
; 16951615.65799945
; 8735254.869319363
; 4871109.768821579
; 3338438.769158059
; 2986615.573400899
; 2965893.1941674994
; 2965820.801641373
; 2965820.8007578608
; 2965820.8007578608
; ...
; (doesn't halt)
; > (square (sqrt (- (expt 2.0 44) 1)))
; 1.0
; 8796093022208.0
; 4398046511105.0
; 2199023255554.5
; 1099511627781.25
; 549755813898.625
; 274877906965.3125
; 137438953514.65625
; 68719476821.32812
; 34359738538.66406
; 17179869525.33203
; 8589935274.666006
; 4294968661.332922
; 2147486378.66581
; 1073747285.3276968
; 536881834.622182
; 268457300.9777658
; 134261415.82247663
; 67196222.58623502
; 33729012.89269655
; 17125293.59271959
; 9076278.459057067
; 5507269.150110688
; 4350813.2824062845
; 4197119.0088142585
; 4194304.944013454
; 4194303.999999987
; 17592186044415.0
; > (square (sqrt (expt 2.0 44)))
; 1.0
; 8796093022208.5
; 4398046511105.25
; 2199023255554.625
; 1099511627781.3125
; 549755813898.6562
; 274877906965.3281
; 137438953514.66406
; 68719476821.33203
; 34359738538.666016
; 17179869525.333008
; 8589935274.666494
; 4294968661.333166
; 2147486378.665932
; 1073747285.3277578
; 536881834.6222125
; 268457300.97778106
; 134261415.82248425
; 67196222.58623883
; 33729012.89269846
; 17125293.592720542
; 9076278.459057543
; 5507269.150110931
; 4350813.282406426
; 4197119.008814378
; 4194304.944013573
; 4194304.000000106
; 17592186044416.0

; Size alone is not enough to make the sqrt function loop infinitely. Rather, it
; becomes more likely that `sqrt` won't terminate when x is larger, as we have
; less precision in our `good-enough?` procedure.

; eg. 12345678901234 doesn't terminate, as successive applications of improve lead to
; a fixed point of improve whose square is greater than 0.001 from 12345678901234:

; > (sqrt 12345678901234.0)
; 1.0
; 6172839450617.5
; 3086419725309.75
; 1543209862656.875
; 771604931332.4375
; 385802465674.21875
; 192901232853.10938
; 96450616458.55469
; 48225308293.27734
; 24112654274.63867
; 12056327393.319334
; 6028164208.659653
; 3014083128.3297105
; 1507043612.1639276
; 753525902.074542
; 376771142.9778979
; 188401955.01397642
; 94233741.7076047
; 47182376.47141617
; 23722017.581583798
; 12121224.408177208
; 6569870.942541849
; 4224503.311279173
; 3573450.5222935397
; 3514142.3366335463
; 3513641.86446291
; 3513641.8288200637
; 3513641.8288200637
; ...
; (doesn't halt)
; > (square 3513641.8288200637)
; 12345678901234.002

; \* really 1/1024, but that's a fairly good approximation, as the next digit is
; 2**-16, or 1/65536

; ________________________________________________________________________________

(define (new-sqrt-iter old-guess new-guess x)
  (if (new-good-enough? old-guess new-guess)
      new-guess
      (new-sqrt-iter new-guess
                     (improve new-guess x)
                     x)))

(define (new-sqrt x)
  (new-sqrt-iter 0.0 1.0 x))

(define (new-good-enough? old-guess new-guess)
  (< (abs (- old-guess new-guess)) 0.001))

; This `new-sqrt` function is much better for small numbers:

; > (square (new-sqrt 0.1))
; 0.10000000031668915
; > (square (new-sqrt 0.01))
; 0.01000010579156518
; > (square (new-sqrt 0.001))
; 0.0010000003699243661
; > (square (new-sqrt 0.0001))
; 0.00010001428128408621
; > (square (new-sqrt 0.00001))
; 1.0061765790409001e-05
; > (square (new-sqrt 0.000001))
; 1.6801126450039938e-06
; > (square (new-sqrt 0.0000001))
; 1.0210285036697172e-06
; > (square (new-sqrt 0.00000001))
; 9.603479556038137e-07
; > (square (sqrt 0.1))
; 0.10001125566203942
; > (square (sqrt 0.01))
; 0.01006526315785885
; > (square (sqrt 0.001))
; 0.0017011851721075596
; > (square (sqrt 0.0001))
; 0.0010438358335233748
; > (square (sqrt 0.00001))
; 0.0009832294718753643
; > (square (sqrt 0.000001))
; 0.0009772285838805523
; > (square (sqrt 0.0000001))
; 0.000976629102245155
; > (square (sqrt 0.00000001))
; 0.000976569160163076

; Where `sqrt` stops working as expected for 10**-3 and lower, `new-sqrt` only
; starts producing strange results for 10**-7 and lower.

; For large numbers, `new-sqrt` doesn't have the same issues with halting:

; > (square (new-sqrt (- (expt 2.0 43) 1)))
; 1.0
; 4398046511104.0
; 2199023255553.0
; 1099511627778.5
; 549755813893.25
; 274877906954.625
; 137438953493.3125
; 68719476778.65625
; 34359738453.328125
; 17179869354.664062
; 8589934933.33203
; 4294967978.665995
; 2147485013.3328347
; 1073744554.6651154
; 536876373.322141
; 268446378.5777382
; 134239572.622235
; 67152548.97882563
; 33641767.85605315
; 16951615.65799754
; 8735254.869318409
; 4871109.768821101
; 3338438.7691578055
; 2986615.573400723
; 2965893.194167331
; 2965820.8016412044
; 8796093022206.999
; > (square (new-sqrt (expt 2.0 43)))
; 1.0
; 4398046511104.5
; 2199023255553.25
; 1099511627778.625
; 549755813893.3125
; 274877906954.65625
; 137438953493.32812
; 68719476778.66406
; 34359738453.33203
; 17179869354.666016
; 8589934933.333006
; 4294967978.666483
; 2147485013.333079
; 1073744554.6652374
; 536876373.3222021
; 268446378.57776874
; 134239572.62225026
; 67152548.97883326
; 33641767.856056966
; 16951615.65799945
; 8735254.869319363
; 4871109.768821579
; 3338438.769158059
; 2986615.573400899
; 2965893.1941674994
; 2965820.801641373
; 8796093022207.998
; > (square (new-sqrt (- (expt 2.0 44) 1)))
; 1.0
; 8796093022208.0
; 4398046511105.0
; 2199023255554.5
; 1099511627781.25
; 549755813898.625
; 274877906965.3125
; 137438953514.65625
; 68719476821.32812
; 34359738538.66406
; 17179869525.33203
; 8589935274.666006
; 4294968661.332922
; 2147486378.66581
; 1073747285.3276968
; 536881834.622182
; 268457300.9777658
; 134261415.82247663
; 67196222.58623502
; 33729012.89269655
; 17125293.59271959
; 9076278.459057067
; 5507269.150110688
; 4350813.2824062845
; 4197119.0088142585
; 4194304.944013454
; 4194303.999999987
; 17592186044415.0
; > (square (new-sqrt (expt 2.0 44)))
; 1.0
; 8796093022208.5
; 4398046511105.25
; 2199023255554.625
; 1099511627781.3125
; 549755813898.6562
; 274877906965.3281
; 137438953514.66406
; 68719476821.33203
; 34359738538.666016
; 17179869525.333008
; 8589935274.666494
; 4294968661.333166
; 2147486378.665932
; 1073747285.3277578
; 536881834.6222125
; 268457300.97778106
; 134261415.82248425
; 67196222.58623883
; 33729012.89269846
; 17125293.592720542
; 9076278.459057543
; 5507269.150110931
; 4350813.282406426
; 4197119.008814378
; 4194304.944013573
; 4194304.000000106
; 17592186044416.0
; > (new-sqrt 12345678901234.0)
; 1.0
; 6172839450617.5
; 3086419725309.75
; 1543209862656.875
; 771604931332.4375
; 385802465674.21875
; 192901232853.10938
; 96450616458.55469
; 48225308293.27734
; 24112654274.63867
; 12056327393.319334
; 6028164208.659653
; 3014083128.3297105
; 1507043612.1639276
; 753525902.074542
; 376771142.9778979
; 188401955.01397642
; 94233741.7076047
; 47182376.47141617
; 23722017.581583798
; 12121224.408177208
; 6569870.942541849
; 4224503.311279173
; 3573450.5222935397
; 3514142.3366335463
; 3513641.86446291
; 3513641.8288200637

; The calculations for 2**43 and 12345678901234.0 now halt. Note that this
; doesn't mean that `new-sqrt` always halts, just that it halts in some of the
; cases where `sqrt` doesn't.
