;;;; Martin Kersner, m.kersner@gmail.com
;;;; 2017/07/16 
;;;;
;;;; k-Means 

(defclass k-means ()
  ((k :initarg :k ; number of centroids
      :reader get-k)
   ; maximum change in position of single centroid to declare convergence
   (tol :initarg :tol
        :initform 0.0001
        :reader get-tol)
   (max-iter :initarg :max-iter
             :initform 300
             :reader get-max-iter)
   (labels :accessor get-labels)
   (centroids :accessor get-centroids)))

(defmethod random-init ((km k-means) X)
  (let ((k (get-k km))
        (centroids '()))

    (labels ((random-centroid (range)
               (let ((min-val (car range))
                     (range-val (cadr range)))
                 (+ (* range-val (random 1.0)) min-val)))

             (compute-range (lst)
               (multiple-value-setq (min-val min-idx)
                 (minimum lst))
               (multiple-value-setq (max-val max-idx)
                 (maximum lst))

               (list min-val (- max-val min-val))
             ))

      (setf ranges
        (mapcar #'(lambda (features) (compute-range features))
                (matrix-data (transpose X))))

      (loop for centroid-idx from 1 to k do
        (push
          (mapcar #'(lambda (r) (random-centroid r)) ranges)
          centroids))

    
      centroids)))

(defgeneric fit (km X y &optional params)
  (:documentation ""))

(defmethod fit ((km k-means) X y &optional params)
  (let ((centroids (random-init km X))
        (centroids-prev)
        (label))

    (labels ((euclidean-dist (vec1 vec2)
               (sqrt (apply '+
                      (mapcar #'(lambda (v1 v2) (expt (- v1 v2) 2))
                              vec1 vec2))))

             (find-closest (vec centroids)
               (multiple-value-setq (min-val min-idx)
                 (minimum
                   (mapcar #'(lambda (c)
                               (euclidean-dist vec c))
                           centroids)))

               min-idx)

             (compute-mean (X)
               (mapcar #'(lambda (f) (float (mean f))) (transpose-list X)))

             (assign (centroids X)
               (mapcar #'(lambda (vec)
                             (find-closest vec centroids))
                       X))

             (update (label X)
               (let ((new-cluster-centers '()))
                 (setf ht (make-hash-table :test 'equal))

                 (multiple-value-setq (max-val max-idx) (maximum label))

                 ; initialize empty clusters
                 (loop for label-idx from 0 to max-val do
                   (setf (gethash label-idx ht) '()))

                 (mapcar #'(lambda (l vec)
                             (push vec (gethash l ht))) label X)

                 ; update cluster centers
                 (maphash #'(lambda (key value)
                              (push (compute-mean value) new-cluster-centers))
                          ht)

                 new-cluster-centers))

               (centroid-difference (centroid1 centroid2)
                 (mapcar #'(lambda (c1 c2) (euclidean-dist c1 c2))
                         centroid1 centroid2))
             )

      (loop for idx from 1 to (get-max-iter km) do
        (setf label
              (assign centroids (matrix-data X)))

        (setf centroids-prev centroids)

        (setf centroids
              (update label (matrix-data X)))

        (if (< (/
                (apply '+ (centroid-difference centroids-prev centroids))
                (get-k km))
              (get-tol km))

              (return 1)) ; TODO remove number

        (setf centroids-prev centroids))

      (setf (get-centroids km) centroids)
      (setf (get-labels km) label)
      )))

(defgeneric predict (km data &optional params)
  (:documentation ""))

(defmethod predict ((km k-means) data &optional params)
  )
