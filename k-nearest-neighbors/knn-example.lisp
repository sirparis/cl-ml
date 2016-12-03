;;;; Martin Kersner, m.kersner@gmail.com
;;;; 2016/08/16
;;;;
;;;; k-nearest neighbors example.

(in-package :lispml)

;;; Load data
(defparameter *dataset-path* "datasets/logistic-regression/dataset_small.csv")
(defparameter *dataset*
  (matrix-from-data (read-csv *dataset-path*)))

;;; Training data preparation
(defparameter *label-col* 2)

(defparameter *train-data* (remove-col *label-col* *dataset*))
(defparameter *train-labels* (matrix-from-data (nth-col *label-col* *dataset*)))

;(defparameter *x-test* '((2 5))) ; 1 class
;(defparameter *x-test* '((-1 8))) ; 0 class
(defparameter *x-test* '((0 8.5))) ; 0 class

(defparameter *row-data* (matrix-from-data *x-test*))

;;; INITIALIZATION
(defparameter *knn* (make-instance 'k-nearest-neighbors))

;;; Train model.
(fit *knn* *train-data* *train-labels*)

(defparameter *params*
  (generate-params '((k 3))))

(defparameter *y-test*
  (predict *knn* *row-data* *params*))

(print *y-test*)

(defparameter *classified-record* (list (list
                                        (caar *x-test*)
                                        (cadar *x-test*)
                                        *y-test*)))

(in-package :lispplot)

(defparameter *fig* (make-instance 'figure
                                   :nokey t))
(xlabel *fig* "feature 1")
(ylabel *fig* "feature 2")
(scatter *fig* (lispml::matrix-data lispml::*dataset*)
         :palette t
         :pt 7
         :ps 2)
(scatter *fig* lispml::*classified-record*
         :plot-type 'replot
         :palette t
         :with 'circles
         :fill t
         :solid-border t
         :lt 2)
(show *fig*)
