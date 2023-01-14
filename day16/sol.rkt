#lang racket

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
       [working-valves (vector-sort (for/vector ([i (in-naturals)]
                                                 [r (in-vector flow-rates)]
                                                 #:when (> r 0))
                                      i)
                                    >
                                    #:key (lambda (i) (vector-ref flow-rates i)))])
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

  (define (upper-bound open-valves pressure time-left)
    (+ pressure
       (for/sum ([m (in-inclusive-range (- time-left 2) 0 -2)]
                 [flow (in-list (for/list ([i (in-naturals)]
                                           [j (in-vector working-valves)]
                                           #:when (= 0 (bitwise-and open-valves (arithmetic-shift 1 i))))
                                  (vector-ref flow-rates j)))])
         (* m flow))))

  (define (dfs res i open-valves pressure time-left)
    (let ([upper-bd (upper-bound open-valves pressure time-left)]
          [idx (modulo open-valves (vector-length res))])
      (unless (<= upper-bd (vector-ref res idx))
        (vector-set! res idx (max (vector-ref res idx) pressure))
        (for ([bit (in-naturals)]
              [j (in-vector working-valves)])
          (let ([bit (arithmetic-shift 1 bit)])
            (when (and (= 0 (bitwise-and open-valves bit))
                       (< (vector-ref dist (+ (* size i) j)) (sub1 time-left)))
              (let ([time-left (- time-left (vector-ref dist (+ (* size i) j)) 1)])
                (dfs res j (bitwise-ior open-valves bit) (+ pressure (* time-left (vector-ref flow-rates j))) time-left))))))))

  (define (sim time-left bins)
    (let ([res (make-vector bins 0)])
      (dfs res (hash-ref ui "AA") 0 0 time-left)
      res))

  (define p1
    (let ([res (sim 30 1)])
      (vector-ref res 0)))
  (printf "Part 1: ~a\n" (~r p1 #:min-width 20))
  (define p2
    (let ([best-pressures (sort (for/list ([i (in-naturals)]
                                           [best (in-vector (sim 26 #xffff))]
                                           #:when (> best 0))
                                  (cons i best))
                                >
                                #:key cdr)])
      (for/fold ([best 0])
                ([i (in-naturals)]
                 [humn (in-list best-pressures)])
        (or (for/first ([cand (map (lambda (elep) (cons (car elep) (+ (cdr humn) (cdr elep))))
                                   (drop best-pressures (add1 i)))]
                        #:break (<= (cdr cand) best)
                        #:when (= 0 (bitwise-and (car humn) (car cand))))
              (cdr cand))
            best))))
  (printf "Part 2: ~a\n" (~r p2 #:min-width 20)))
