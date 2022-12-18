(ns sol
  (:require [clojure.string :refer [trim]])
  (:gen-class))

(println "Day 17: Clojure")

(def rocks '((2r0011110)
             (2r0001000 2r0011100 2r0001000)
             (2r0000100 2r0000100 2r0011100)
             (2r0010000 2r0010000 2r0010000 2r0010000)
             (2r0011000 2r0011000)))

(defn insert-rock [rock grid]
  (letfn [(rec [[r & rs] [g & gs]]
            (if (nil? r) (cons g gs)
                (cons (bit-or r g) (rec rs gs))))]
    (drop-while #(= 0 %) (rec rock grid))))

(def input (trim (slurp *in*)))
(defn solve [lim]
  (loop [seen (hash-map)
         addtnl-hgt 0
         i 0
         k 0
         bef-grid '(2r1111111)]
    (if (>= i lim) (+ addtnl-hgt (count bef-grid) -1)
        (let [grid (concat (repeat (+ 3 (count (nth rocks (mod i 5)))) 0) bef-grid)]
          (letfn [(move-left [rock]
                    (cond
                      (some #(bit-test % 6) rock) rock
                      (some #(not= 0 %) (map bit-and grid (map #(bit-shift-left % 1) rock))) rock
                      :else (map #(bit-shift-left % 1) rock)))
                  (move-right [rock]
                    (cond
                      (some #(bit-test % 0) rock) rock
                      (some #(not= 0 %) (map bit-and grid (map #(bit-shift-right % 1) rock))) rock
                      :else (map #(bit-shift-right % 1) rock)))
                  (place-rock [inp-idx rock]
                    (cond
                      (every? #(= 0 %) (map bit-and rock grid)) (let [c (.charAt input
                                                                                 (mod inp-idx (.length input)))
                                                                      rock2 (if (= c \<) (move-left rock)
                                                                                (move-right rock))]
                                                                  (place-rock (inc inp-idx) (cons 0 rock2)))
                      :else (list inp-idx (insert-rock (rest rock) grid))))]
            (let [[k2 new-grid] (place-rock k (nth rocks (mod i 5)))
                  state (list (mod k2 (.length input)) (mod i 5) (take 50 grid))
                  seen2 (assoc seen state (list i (dec (count grid))))
                  [rock-n height] (get seen state)]
              (if (nil? rock-n) (recur seen2 addtnl-hgt (inc i) k2 new-grid)
                  (let [hgt-diff (- (count grid) 1 height)
                        i-diff (- i rock-n)
                        cycles (quot (- lim i) i-diff)]
                    (recur seen2 (+ addtnl-hgt (* cycles hgt-diff)) (+ i 1 (* cycles i-diff)) k2 new-grid)))))))))

(printf "Part 1: %20d\n" (solve 2022))
(printf "Part 2: %20d\n" (solve 1000000000000))
