;;;; Martin Kersner, m.kersner@gmail.com
;;;; 2016/06/04

(in-package :lispml)

(deftest test-range ()
  (check
    ;; create ascending series of numbers
    (equal (range 0 0) '())
    (equal (range 0 4) '(0 1 2 3))
    (equal (range 0 4 2) '(0 2))
    (equal (range 0 4 3) '(0 3))
  ))

(deftest test-nth-pos-neg ()
  (defparameter *list* '(1 2 3 4 5 6))

  (check
    ;; nth-pos-neg
    (equal (setf (nth-pos-neg 0 *list*) 99) 99)
    (equal *list* '(99 2 3 4 5 6))
    (equal (setf (nth-pos-neg 2 *list*) 88) 88)
    (equal *list* '(99 2 88 4 5 6))
    (equal (setf (nth-pos-neg -1 *list*) 77) 77)
    (equal *list* '(99 2 88 4 5 77))
    (equal (setf (nth-pos-neg -5 *list*) 66) 66)
    (equal *list* '(99 66 88 4 5 77))
  ))

(deftest test-maximum ()
  (check
    ;; base maximum function, return both maximum value and index
    (equal (multiple-value-list (maximum '()))         '(NIL 0))
    (equal (multiple-value-list (maximum '(1)))        '(1 0))
    (equal (multiple-value-list (maximum '(9 8 7)))    '(9 0))
    (equal (multiple-value-list (maximum '(9 10 8)))   '(10 1))
    (equal (multiple-value-list (maximum '(9 10 11)))  '(11 2))
    (equal (multiple-value-list (maximum '(9 10 10)))  '(10 1))
    (equal (multiple-value-list (maximum '(10 10 10))) '(10 0))
  ))

(deftest test-minimum ()
  (check
    ;; base minimum function, return both minimum value and index
    (equal (multiple-value-list (minimum '()))         '(NIL 0))
    (equal (multiple-value-list (minimum '(1)))        '(1 0))
    (equal (multiple-value-list (minimum '(9 10 11)))  '(9 0))
    (equal (multiple-value-list (minimum '(11 10 12))) '(10 1))
    (equal (multiple-value-list (minimum '(13 12 11))) '(11 2))
    (equal (multiple-value-list (minimum '(11 10 10))) '(10 1))
    (equal (multiple-value-list (minimum '(10 10 10))) '(10 0))
  ))

(deftest test-random ()
  (check
    (defparameter *lst0* (iota 6))
    (defparameter *lst1* '(9 3 2))
    (defparameter *lst2* (mapcar #'(lambda (x) (random x)) (iota 100 1)))

    (equal (reduce #'+ (randomize-list *lst0*)) (reduce #'+ *lst0*))
    (equal (reduce #'+ (randomize-list *lst1*)) (reduce #'+ *lst1*))
    (equal (reduce #'+ (randomize-list *lst2*)) (reduce #'+ *lst2*))
  ))

(deftest test-math-list ()
  (check
    ;; sum
    (equal (sum-list-of-lists '((1 1) (2 2))) '(3 3))
    (equal (sum-list-of-lists '((1 1) (2 2) (2 1))) '(5 4))
    (equal (sum-list-of-lists '((1 1 4) (2 2 1) (2 1 2))) '(5 4 7))
  ))

(deftest test-list ()
  (combine-results
    (test-range)
    (test-nth-pos-neg)
    (test-maximum)
    (test-minimum)
    (test-random)
    (test-math-list)
  ))
