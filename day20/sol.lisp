(format t "Day 20: Common Lisp~%")

(define-setf-expander nthcdr2 (idx list &environment env)
   (multiple-value-bind (dummies vals newval setter getter)
                        (get-setf-expansion list env)
     (let ((store (gensym))
           (idx-temp (gensym)))
       (values dummies
               vals
               `(,store)
               `(let ((,idx-temp ,idx))
                  (progn
                    (if (zerop ,idx-temp)
                      (progn (setf ,getter ,store))
                      (progn (rplacd (nthcdr (1- ,idx-temp) ,getter) ,store)))
                    ,store))
               `(nthcdr ,idx ,getter)))))

(defun read-ns ()
  (loop for line = (read-line *standard-input* nil nil)
        while line
        collect (parse-integer line)))

(defun mix (ns times)
  (let ((locs (loop for i from 0 below (length ns) collect i)))
    (dotimes (wat times)
      (loop for n in ns
            for i from 0
            do (let ((loc (position i locs)))
                 (pop (nthcdr2 loc locs))
                 (push i (nthcdr2 (mod (+ n loc) (length locs)) locs)))))
    (let ((z (position (position 0 ns) locs)))
      (+ (nth (nth (mod (+ z 1000) (length locs)) locs) ns)
         (nth (nth (mod (+ z 2000) (length locs)) locs) ns)
         (nth (nth (mod (+ z 3000) (length locs)) locs) ns)))))

(let* ((ns (read-ns)))
  (format t "Part 1: ~20d~%" (mix ns 1))
  (format t "Part 2: ~20d~%" (mix (mapcar (lambda (n) (* n 811589153)) ns) 10)))
