(prinl "Day 1: Picolisp")
(in "input.txt"
  (let (elves NIL
        elf 0)
    (until (eof)
      (let (l (line T))
        (if (= l "")
            (prog (push 'elves elf) (setq elf 0))
            (setq elf (+ elf (format l))))))
    (setq elves (sort elves))
    (prinl "Part 1: " (align 20 (last elves)))
    (prinl "Part 2: " (align 20 (apply + (tail 3 elves))))))

(bye)
