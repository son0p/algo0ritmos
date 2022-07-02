(ql:quickload :osc)
(ql:quickload :usocket)
(ql:quickload :random-sample)

;;; from https://stackoverflow.com/questions/25866292/flatten-a-list-using-common-lisp
;;; paul graham inspired
(defun flatten (lst)
  (labels ((rflatten (lst1 acc)
             (dolist (el lst1)
               (if (listp el)
                   (setf acc (rflatten el acc))
                   (push el acc)))
             acc))
    (reverse (rflatten lst nil))))


(defun osc-send-test (host port)
  "a basic test function which sends osc test message to a given port/hostname.
  note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (USOCKET:socket-connect host port
                           :protocol :datagram
                           :element-type '(unsigned-byte 8)))
        (b (osc:encode-message "/foo/bar" "baz" 1 2 3 (coerce PI 'single-float))))
    (format t "sending to ~a on port ~A~%~%" host port)
    (unwind-protect
 (USOCKET:socket-send s b (length b))
      (when s (USOCKET:socket-close s)))))

(osc-send-test #(127 0 0 1) 6668) ;; test
(defvar *oscRx* nil)
;;(fmakunbound 'osc-receive-test)
(defun osc-receive-test (port)
  "a basic test function which attempts to decode an osc message on given port.
  note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (USOCKET:socket-connect nil nil
                           :local-port port
                           :local-host #(127 0 0 1)
                           :protocol :datagram
                           :element-type '(unsigned-byte 8)))
        (buffer (make-sequence '(vector (unsigned-byte 8)) 1024)))
    (format t "listening on localhost port ~A~%~%" port)
    (unwind-protect
         (loop do
           (USOCKET:socket-receive s buffer (length buffer))
           (format t "received -=> ~S~%" (osc:decode-bundle buffer))
           (setf *oscRx* (osc:decode-bundle buffer))
           (if (= (nth 1 *oscrx*) 1)
               (update-lead))
           (if (= (nth 1 *oscrx*) 2)
               (update-mid))
           (if (= (nth 1 *oscrx*) 3)
               (update-bass))
               )
      (when s (USOCKET:socket-close s)))))

(osc-receive-test 6667);; test

(socket-connect #(127 0 0 1) 6668 ;; test
                           :protocol :datagram
                           :element-type '(unsigned-byte 8))

;;; tested with simpleOSCpattern.ck --------------------
(defun osc-send-test1 (host port address-pattern)
  "a basic test function which sends osc test message to a given port/hostname.
  note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (USOCKET:socket-connect host port
                           :protocol :datagram
                           :element-type '(unsigned-byte 8)))
        ;(b (osc:encode-message "/foo/bar"  110.0 0.0 0.0 0.0 680.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0  ))) ;; working
        (b (apply #'osc:encode-message address-pattern)))
    ;(format t "sending to ~a on port ~A~%~%" host port)
    (unwind-protect
 (USOCKET:socket-send s b (length b))
      (when s (USOCKET:socket-close s)))))

;; (defun calculate-frequencies (n)
;;   "starting at n calculate frequencies for 9 octaves with 12 steps"
;;   (defvar scale-frequencies nil) ;; FIX ¿global?
;;   (dotimes (i (* 12 9))
;;     (setf n (* n 1.0594630943))
;;     (push n scale-frequencies)))
;; (calculate-frequencies 16.35) ;; initialize scale-frequencies

;;(defvar *major-scale-jumps* '(2 2 1 2 2 2 1))
(defvar *scale* nil)  ; make local let

;; (defun scale-generator (notes scale-jumps)
;;   "iterate below maximum posible scale-jumps shift"
;;   ; scale size
;;   ; asigna la primera nota posible a la escala  scale[1] <- notes[1]
;;   ; for o dotimes i desde 2 hasta el tamaño de notes
;;   ; va llenando scale
;;   ; cuando termina retorna scale
;;   ; TODO bad step sum
;;   (dotimes (i 7)
;;     (push
;;      (nth
;;       (+ i (nth i scale-jumps)) notes)
;;      *scale*))
;;   (print *scale*)
;;    ;(write (length notes))
;;   )

(setf *scale* '(16.35 18.35 20.60 21.83 24.50 27.50 30.87 32.70 36.71 41.20
                43.65 49.00 55.00 61.74 65.41 73.42 82.41 87.31 98.00 110.00
                123.47 130.81 146.83 164.81 174.61 196.00 220.00 246.94 261.63
                293.66 329.63 349.23 392.00  440 493.88 523.25 587.33 659.25 698.46
                783.99 880.00 987.77 1046.50 1174.66 1318.51 1396.91 1567.98 ))

;;(scale-generator scale-frequencies major-scale-jumps )

(defun quantize-frequency (unquantized-value)
  "quantize to frequencies in musical scale"
  (nth
   ;; select the nth element of the quantized-list
   (position
    ;; gets the position of the lowest difference element
    (reduce #'min (mapcar #'(lambda (x) (abs (- x unquantized-value)))
                          ;;scale-frequencies))
                          *scale*))
    (mapcar #'(lambda (x) (abs (- x unquantized-value)))
            ;; find the differences between value and each element of the quantized list
                *scale*))
            ;;scale-frequencies))
   ;;scale-frequencies))
   *scale*))

;;; pool  to conform osc:encode-message ====================
(defun modify-list (list position value)
  (setf (nth position list) value))

(defun sample-segment-generator (lenght value)
   (loop for i from 0 to lenght collecting value))

(define-condition not-summing-100 (error)
   ((message :initarg :message :reader message)))

(defun sample (lst-lenghts lst-values)
  (random-sample:random-sample (distributed-sample-generator lst-lenghts lst-values) 1))

(defun distributed-sample-generator (lst-lenghts lst-values)
  "Toma los tamaños y los valores de dos listas, genera una lista aplanada"
  (if (/= (reduce #'+ lst-lenghts)  100)
      (error 'not-summing-100 :message "lenghts must sum 100"))
  (flatten (mapcar #'sample-segment-generator lst-lenghts lst-values)))

;;; drums test pag 65
(defun refresh-bd()
  (setf *bd2*
        (flatten
         (list
          (sample '(90 10) '(1 0)) ;00
          (sample '(05 95) '(1 0)) ;01
          (sample '(40 60) '(1 0)) ;02
          (sample '(90 10) '(1 0)) ;03
          (sample '(05 95) '(1 0)) ;04
          (sample '(10 90) '(1 0)) ;05
          (sample '(30 70) '(1 0)) ;06
          (sample '(20 80) '(1 0)) ;07
          (sample '(90 10) '(1 0)) ;08
          (sample '(05 95) '(1 0)) ;09
          (sample '(20 80) '(1 0)) ;10
          (sample '(90 10) '(1 0)) ;11
          (sample '(05 95) '(1 0)) ;12
          (sample '(10 90) '(1 0)) ;13
          (sample '(40 60) '(1 0)) ;14
          (sample '(40 60) '(1 0))))));15



(progn
  (defvar *bd* nil)
  (defvar *sd* nil)
  (defvar *hh* nil)
  (defvar *htom* nil)
  (defvar *bd-actives* nil)
  (defvar *sd-actives* nil)
  (defvar *hh-actives* nil)
  (defvar *htom-actives* nil))

(defun clear-patt ()
  (progn
    (setf *bd*   (loop for i from 1 to 16 collecting 0))
    (setf *sd*   (loop for i from 1 to 16 collecting 0))
    (setf *hh*   (loop for i from 1 to 16 collecting 0))
    (setf *htom* (loop for i from 1 to 16 collecting 0))))

(defun patt-changer (bd-list sn-list htom-list hh-list)
  (progn
    (clear-patt)
    (setf *bd-actives*   bd-list)
    (setf *sd-actives*   sn-list)
    (setf *htom-actives* htom-list)
    (setf *hh-actives*   hh-list)
    (mapcar #'(lambda (x) (modify-list *bd*   x 1)) *bd-actives*)
    (mapcar #'(lambda (x) (modify-list *sd*   x 1)) *sd-actives*)
    (mapcar #'(lambda (x) (modify-list *hh*   x 1)) *hh-actives*)
    (mapcar #'(lambda (x) (modify-list *htom* x 1)) *htom-actives*)))


(defvar num-seq (loop :for n :below 16 :collect n))
;(setf num-seq (nreverse num-seq))
(defun pattern-changer ()
  (let ((LEAD (let ((addr "/audio/2/lead")
                    (patt (mapcar #'(lambda (x) (quantize-frequency (* (tan (+ (* 1 (random 200)) x)) 1000))) num-seq)))
                (cons addr patt)))
        (MID (let ((addr "/audio/2/mid")
                   (patt (mapcar #'(lambda (x) (quantize-frequency (* (tan (* (+ 1 (random 50)) x)) 200))) num-seq)))
               (cons addr patt)))
        (BASS (let ((addr "/audio/2/bass")
                    (patt (mapcar #'(lambda (x) (quantize-frequency (* (tan (* (* 2  (Random 80)) x)) 70 ))) num-seq)))
                (cons addr patt)))
        (BD (let ((addr "/audio/2/bd")
                  (patt  *bd*))
              (cons addr patt)))
        (SD (let ((addr "/audio/2/sd")
                  (patt  *sd*))
              (cons addr patt)))
        (HTOM (let ((addr "/audio/2/htom")
                    (patt  *htom*))
                (cons addr patt)))
        (HH (let ((addr "/audio/2/hh")
                  (patt  *hh*))
              (cons addr patt))))
  (progn
    (osc-send-test1 #(127 0 0 1) 6450 LEAD)
    (osc-send-test1 #(127 0 0 1) 6450 MID)
    (osc-send-test1 #(127 0 0 1) 6450 BASS)
    (osc-send-test1 #(127 0 0 1) 6450 BD)
    (osc-send-test1 #(127 0 0 1) 6450 SD)
    (osc-send-test1 #(127 0 0 1) 6450 HTOM)
    (osc-send-test1 #(127 0 0 1) 6450 HH))))

;; (progn
;;   "reveived message from OSC select drum pattern between patt-a or patt-b"
;;   (if  (= (nth 1 *oscrx*) 1) (patt-a) (patt-b) )
;;   (pattern-changer))

;;; change to individual parts
(defun update-lead ()
  (osc-send-test1 #(127 0 0 1) 6450
                  (let ((addr "/audio/2/lead")
                        (patt (mapcar #'(lambda (x) (quantize-frequency (* (sin (+ (* 1 (random 200)) x)) 1000))) num-seq)))
                    (cons addr patt))))
(defun update-mid ()
  (osc-send-test1 #(127 0 0 1) 6450
                  (let ((addr "/audio/2/mid")
                        (patt (mapcar #'(lambda (x) (quantize-frequency (* (sin (* (+ 1 (random 50)) x)) 200))) num-seq)))
                    (cons addr patt))))
(defun update-bass ()
  (osc-send-test1 #(127 0 0 1) 6450
                  (let ((addr "/audio/2/bass")
                        (patt (mapcar #'(lambda (x) (quantize-frequency (* (tan (* (* 2  (Random 80)) x)) 70 ))) num-seq)))
                    (cons addr patt))))
(defun update-drums ()
  (progn
    (osc-send-test1 #(127 0 0 1) 6450
                    (let ((addr "/audio/2/bd")
                          (patt  *bd2*))
                      (cons addr patt)))
    (osc-send-test1 #(127 0 0 1) 6450
                    (let ((addr "/audio/2/sd")
                          (patt *sd*))
                      (cons addr patt)))
    (osc-send-test1 #(127 0 0 1) 6450
                    (let ((addr "/audio/2/htom")
                          (patt *htom*))
                      (cons addr patt)))
    (osc-send-test1 #(127 0 0 1) 6450
                    (let ((addr "/audio/2/hh")
                          (patt *hh*))
                      (cons addr patt)))))

;; ----------------------     BD                    SN              HTOM            HH
(progn (patt-changer   '(1 2 10 12 13 14 15)   '(6 7 8 9 10)   '(12 13 14)       '(1 2 3 4 5 8 9 10 14 15 ))         (update-drums))
(progn (patt-changer   '(0 7 8 15)             '(3 4 11 12)    '(4 12)           '(2 4 8 11 14))                     (update-drums))
(progn (patt-changer   '(6 14)                 '(2 3 10 11)    '(6 7 14 15)      '(0 2 3 4 6 7 8 10 11 12 14 15  ))  (update-drums))
(progn (patt-changer   '(4 12)                 '(3 11)        '(2 4 7 8 11 14 15)   '(4 12  ))              (update-drums))

(update-lead)
(update-mid)
(progn
 (refresh-bd)
 (update-drums))

(defun write-stream-t1 (stream osc-message)
  "writes a given message to a stream. keep in mind that when using a buffered
   stream any funtion writing to the stream should  call (finish-output stream)
   after it sends the mesages,. ."
  (write-sequence
   (osc:encode-message "/bzzp" "got" "it" )
   stream)
  (finish-output stream))

(defmacro osc-write-to-stream (stream &body args)
  `(progn (write-sequence (osc:encode-message ,@args) ,stream)
          (finish-output ,stream)))

