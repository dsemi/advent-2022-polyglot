#lang racket

(require racket/generator)

(displayln "Day 16: Racket")

(let* ([reg #px"Valve (\\w+) has flow rate=(\\d+); tunnels? leads? to valves? (.+)$"]
       [valves (for/list ([line (in-lines (current-input-port))])
                 (cdr (regexp-match reg line)))]
       [size (length valves)]
       [ui (for/hash ([i (in-naturals)]
                      [name (map car valves)])
             (values name i))]
       [dist (make-vector (* size size) 1000000)]
       [flow-rates (for/vector ([r (map second valves)])
                     (string->number r))]
       [working-valves (for/vector ([i (in-naturals)]
                                    [r (in-vector flow-rates)]
                                    #:when (> r 0))
                         i)])
  (for ([valve valves])
    (let ([i (hash-ref ui (first valve))])
      (vector-set! dist (+ (* size i) i) 0)
      (for ([tunnel (string-split (third valve) ", ")])
        (let ([j (hash-ref ui tunnel)])
          (vector-set! dist (+ (* size i) j) 1)))))
  (for* ([k (in-range size)]
         [i (in-range size)]
         [j (in-range size)])
    (vector-set! dist (+ (* size i) j) (min (vector-ref dist (+ (* size i) j))
                                            (+ (vector-ref dist (+ (* size i) k))
                                               (vector-ref dist (+ (* size k) j))))))
  (define (make-gen sz)
    (let* ([stack (list (list (hash-ref ui "AA") 0 0 sz))])
      (generator ()
        (let loop ()
          (unless (null? stack)
            (match-let ([(list i open-valves pressure time-left) (car stack)])
              (set! stack (cdr stack))
              (yield (list open-valves pressure))
              (for ([j (in-vector working-valves)])
                (let ([bit (arithmetic-shift 1 j)])
                  (when (and (= 0 (bitwise-and open-valves bit))
                             (< (vector-ref dist (+ (* size i) j)) (sub1 time-left)))
                    (let ([time-left (- time-left (vector-ref dist (+ (* size i) j)) 1)])
                      (set! stack (cons (list j (bitwise-ior open-valves bit) (+ pressure (* time-left (vector-ref flow-rates j))) time-left) stack)))))))
            (loop))))))
  (define p1
    (for/fold ([mx 0])
              ([ret (in-producer (make-gen 30) (void))])
      (max mx (second ret))))
  (printf "Part 1: ~a\n" (~r p1 #:min-width 20))
  (define p2
    (let ([open-to-press (make-hash)])
      (for ([ret (in-producer (make-gen 26) (void))])
        (hash-set! open-to-press (first ret) (max (hash-ref open-to-press (first ret) 0) (second ret))))
      (let ([best-pressures (for/vector ([(k v) (in-hash open-to-press)])
                              (list k v))])
        (for*/fold ([mx 0])
                   ([hi (in-range (vector-length best-pressures))]
                    [ei (in-range (add1 hi) (vector-length best-pressures))])
          (match-let ([(list h-opens h-pressure) (vector-ref best-pressures hi)]
                      [(list e-opens e-pressure) (vector-ref best-pressures ei)])
            (if (= 0 (bitwise-and h-opens e-opens)) (max mx (+ h-pressure e-pressure)) mx))))))
  (printf "Part 2: ~a\n" (~r p2 #:min-width 20)))
