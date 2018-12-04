(define (sum-sq-larger-pair x y z)
  (define (sq a) (* a a))
  (define (sum-sq a b) (+ (sq a) (sq b)))
  (cond
    ((= (min x y z) x) (sum-sq y z))
    ((= (min x y z) y) (sum-sq x z))
    ((= (min x y z) z) (sum-sq x y))
    )
  )
