;;;; test with simpleOSCpattern.ck (ChucK)--------------------

;;; librerias
(ql:quickload :osc)
(ql:quickload :usocket)
(ql:quickload :random-sample)

;;; manejo de errores
(define-condition not-summing-100 (error)
   ((message :initarg :message :reader message)))

;;; variables
(progn
  (defvar *bd*   nil)
  (defvar *sd*   nil)
  (defvar *hh*   nil)
  (defvar *htom* nil)
  (defvar *bd-actives*   nil)
  (defvar *sd-actives*   nil)
  (defvar *hh-actives*   nil)
  (defvar *htom-actives* nil)
  (defvar *oscRx* nil)
  (defvar *scale* nil)  ; make local let
  (defvar num-seq (loop :for n :below 16 :collect n))) ; TODO: es +constante+?

(setf *scale* '(16.35 18.35 20.60 21.83 24.50 27.50 30.87 32.70 36.71 41.20
                43.65 49.00 55.00 61.74 65.41 73.42 82.41 87.31 98.00 110.00
                123.47 130.81 146.83 164.81 174.61 196.00 220.00 246.94 261.63
                293.66 329.63 349.23 392.00  440 493.88 523.25 587.33 659.25 698.46
                783.99 880.00 987.77 1046.50 1174.66 1318.51 1396.91 1567.98 ))

;;; funciones
(defun modify-list (list position value)
  (setf (nth position list) value))

(defun sample-segment-generator (lenght value)
   (loop for i from 0 to lenght collecting value))

(defun flatten (lst)
  "from https://stackoverflow.com/questions/25866292/flatten-a-list-using-common-lisp
   paul graham inspired"
  (labels ((rflatten (lst1 acc)
             (dolist (el lst1)
               (if (listp el)
                   (setf acc (rflatten el acc))
                   (push el acc)))
             acc))
    (reverse (rflatten lst nil))))

(defun distributed-sample-generator (lst-lenghts lst-values)
  "Toma los tamaños y los valores de dos listas, genera una lista aplanada"
  (if (/= (reduce #'+ lst-lenghts)  100)
      (error 'not-summing-100 :message "lenghts must sum 100"))
  (flatten (mapcar #'sample-segment-generator lst-lenghts lst-values)))

(defun sample (lst-lenghts lst-values)
  (random-sample:random-sample (distributed-sample-generator lst-lenghts lst-values) 1))

(defun always-one (x) (/ (+ x 1) (+ x 1)))
(defun lead-math-function (x) (+ (* 3 (* (random 200) 1)) (* (sin x) (sin x))))
(defun mid-math-function  (x) (+ (* 3 (random 200)) (sin x)))
(defun bass-math-function (x) (+ (* 2 (random 100)) (tan x)))

(defun base-probability(lst)
  (flatten
   (list
    (sample '(34 66) (list (nth 1  lst) 0)) ;00
    (sample '(02 98) (list (nth 2  lst) 0)) ;01
    (sample '(18 82) (list (nth 3  lst) 0)) ;02
    (sample '(13 87) (list (nth 4  lst) 0)) ;03
    (sample '(14 86) (list (nth 5  lst) 0)) ;04
    (sample '(09 91) (list (nth 6  lst) 0)) ;05
    (sample '(19 81) (list (nth 7  lst) 0)) ;06
    (sample '(11 89) (list (nth 8  lst) 0)) ;07
    (sample '(13 87) (list (nth 9  lst) 0)) ;08
    (sample '(12 88) (list (nth 10 lst) 0)) ;09
    (sample '(15 85) (list (nth 11 lst) 0)) ;10
    (sample '(11 89) (list (nth 12 lst) 0)) ;11
    (sample '(15 85) (list (nth 13 lst) 0)) ;12
    (sample '(12 88) (list (nth 14 lst) 0)) ;13
    (sample '(13 87) (list (nth 15 lst) 0)) ;14
    (sample '(03 97) (list (nth 16 lst) 0)))));15

(defun baiao-bd-probability(lst)
  (flatten
   (list
    (sample '(99 01) (list (nth 1  lst) 0)) ;00
    (sample '(01 99) (list (nth 2  lst) 0)) ;01
    (sample '(01 99) (list (nth 3  lst) 0)) ;02
    (sample '(99 01) (list (nth 4  lst) 0)) ;03
    (sample '(01 99) (list (nth 5  lst) 0)) ;04
    (sample '(01 99) (list (nth 6  lst) 0)) ;05
    (sample '(99 01) (list (nth 7  lst) 0)) ;06
    (sample '(01 99) (list (nth 8  lst) 0)) ;07
    (sample '(99 01) (list (nth 9  lst) 0)) ;08
    (sample '(01 99) (list (nth 10 lst) 0)) ;09
    (sample '(01 99) (list (nth 11 lst) 0)) ;10
    (sample '(99 01) (list (nth 12 lst) 0)) ;11
    (sample '(01 99) (list (nth 13 lst) 0)) ;12
    (sample '(01 99) (list (nth 14 lst) 0)) ;13
    (sample '(99 01) (list (nth 15 lst) 0)) ;14
    (sample '(01 99) (list (nth 16 lst) 0)))));15

(defun baiao-hh-probability(lst)
  (flatten
   (list
    (sample '(99 01) (list (nth 1  lst) 0)) ;00
    (sample '(01 99) (list (nth 2  lst) 0)) ;01
    (sample '(01 99) (list (nth 3  lst) 0)) ;02
    (sample '(99 01) (list (nth 4  lst) 0)) ;03
    (sample '(01 99) (list (nth 5  lst) 0)) ;04
    (sample '(99 01) (list (nth 6  lst) 0)) ;05
    (sample '(01 99) (list (nth 7  lst) 0)) ;06
    (sample '(01 99) (list (nth 8  lst) 0)) ;07
    (sample '(99 01) (list (nth 9  lst) 0)) ;08
    (sample '(01 99) (list (nth 10 lst) 0)) ;09
    (sample '(99 01) (list (nth 11 lst) 0)) ;10
    (sample '(01 99) (list (nth 12 lst) 0)) ;11
    (sample '(01 99) (list (nth 13 lst) 0)) ;12
    (sample '(99 01) (list (nth 14 lst) 0)) ;13
    (sample '(01 99) (list (nth 15 lst) 0)) ;14
    (sample '(01 99) (list (nth 16 lst) 0)))));15

(defun baiao-sn-probability(lst)
  (flatten
   (list
    (sample '(01 99) (list (nth 1  lst) 0)) ;00
    (sample '(01 99) (list (nth 2  lst) 0)) ;01
    (sample '(99 01) (list (nth 3  lst) 0)) ;02
    (sample '(01 99) (list (nth 4  lst) 0)) ;03
    (sample '(01 99) (list (nth 5  lst) 0)) ;04
    (sample '(01 99) (list (nth 6  lst) 0)) ;05
    (sample '(99 01) (list (nth 7  lst) 0)) ;06
    (sample '(01 99) (list (nth 8  lst) 0)) ;07
    (sample '(01 99) (list (nth 9  lst) 0)) ;08
    (sample '(01 99) (list (nth 10 lst) 0)) ;09
    (sample '(99 01) (list (nth 11 lst) 0)) ;10
    (sample '(01 99) (list (nth 12 lst) 0)) ;11
    (sample '(01 99) (list (nth 13 lst) 0)) ;12
    (sample '(01 99) (list (nth 14 lst) 0)) ;13
    (sample '(99 01) (list (nth 15 lst) 0)) ;14
    (sample '(01 99) (list (nth 16 lst) 0)))));15

(defun baiao-htom-probability(lst)
  (flatten
   (list
    (sample '(01 99) (list (nth 1  lst) 0)) ;00
    (sample '(01 99) (list (nth 2  lst) 0)) ;01
    (sample '(01 99) (list (nth 3  lst) 0)) ;02
    (sample '(01 99) (list (nth 4  lst) 0)) ;03
    (sample '(01 99) (list (nth 5  lst) 0)) ;04
    (sample '(01 99) (list (nth 6  lst) 0)) ;05
    (sample '(99 01) (list (nth 7  lst) 0)) ;06
    (sample '(01 99) (list (nth 8  lst) 0)) ;07
    (sample '(01 99) (list (nth 9  lst) 0)) ;08
    (sample '(01 99) (list (nth 10 lst) 0)) ;09
    (sample '(01 99) (list (nth 11 lst) 0)) ;10
    (sample '(01 99) (list (nth 12 lst) 0)) ;11
    (sample '(01 99) (list (nth 13 lst) 0)) ;12
    (sample '(01 99) (list (nth 14 lst) 0)) ;13
    (sample '(99 01) (list (nth 15 lst) 0)) ;14
    (sample '(01 99) (list (nth 16 lst) 0)))));15


(defun insert-probability(lst)
  (flatten
   (list
    (sample '(01 99) (list (nth 1  lst) 0)) ;00
    (sample '(10 90) (list (nth 2  lst) 0)) ;01
    (sample '(90 10) (list (nth 3  lst) 0)) ;02
    (sample '(01 99) (list (nth 4  lst) 0)) ;03
    (sample '(90 10) (list (nth 5  lst) 0)) ;04
    (sample '(01 99) (list (nth 6  lst) 0)) ;05
    (sample '(01 99) (list (nth 7  lst) 0)) ;06
    (sample '(70 30) (list (nth 8  lst) 0)) ;07
    (sample '(01 99) (list (nth 9  lst) 0)) ;08
    (sample '(01 99) (list (nth 10 lst) 0)) ;09
    (sample '(20 80) (list (nth 11 lst) 0)) ;10
    (sample '(10 90) (list (nth 12 lst) 0)) ;11
    (sample '(90 10) (list (nth 13 lst) 0)) ;12
    (sample '(01 99) (list (nth 14 lst) 0)) ;13
    (sample '(90 10) (list (nth 15 lst) 0)) ;14
    (sample '(20 80) (list (nth 16 lst) 0)))));15

(defun bass-probability(lst)
  (flatten
   (list
    (sample '(90 10) (list (nth 1  lst) 0)) ;00
    (sample '(10 90) (list (nth 2  lst) 0)) ;01
    (sample '(50 50) (list (nth 3  lst) 0)) ;02
    (sample '(80 20) (list (nth 4  lst) 0)) ;03
    (sample '(90 10) (list (nth 5  lst) 0)) ;04
    (sample '(01 99) (list (nth 6  lst) 0)) ;05
    (sample '(50 50) (list (nth 7  lst) 0)) ;06
    (sample '(70 30) (list (nth 8  lst) 0)) ;07
    (sample '(90 10) (list (nth 9  lst) 0)) ;08
    (sample '(01 99) (list (nth 10 lst) 0)) ;09
    (sample '(20 80) (list (nth 11 lst) 0)) ;10
    (sample '(90 10) (list (nth 12 lst) 0)) ;11
    (sample '(05 95) (list (nth 13 lst) 0)) ;12
    (sample '(01 99) (list (nth 14 lst) 0)) ;13
    (sample '(50 50) (list (nth 15 lst) 0)) ;14
    (sample '(50 50) (list (nth 16 lst) 0)))));15


;;; drums test pag 65
(defun refresh-bd()
  (flatten
   (list
    (sample '(90 10) '(1 0)) ;00
    (sample '(10 90) '(1 0)) ;01
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
    (sample '(40 60) '(1 0)))));15

(defun four-on-floor ()
  (setf *bd* '(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))
  (update-drums))

(defun refresh-sd()
  (flatten
   (list
    (sample '(01 99) '(1 0)) ;00
    (sample '(10 90) '(1 0)) ;01
    (sample '(90 10) '(1 0)) ;02
    (sample '(01 99) '(1 0)) ;03
    (sample '(90 10) '(1 0)) ;04
    (sample '(01 99) '(1 0)) ;05
    (sample '(01 99) '(1 0)) ;06
    (sample '(01 99) '(1 0)) ;07
    (sample '(01 99) '(1 0)) ;08
    (sample '(01 99) '(1 0)) ;09
    (sample '(20 80) '(1 0)) ;10
    (sample '(10 90) '(1 0)) ;11
    (sample '(90 10) '(1 0)) ;12
    (sample '(01 99) '(1 0)) ;13
    (sample '(01 99) '(1 0)) ;14
    (sample '(20 80) '(1 0)))));15

(defun hh-base()
 (setf *hh* '(1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1))
  (update-drums))

(defun quantize-frequency (unquantized-value)
  "Quantize to frequencies in musical scale

- Select the NTH element of the quantized-list.
- Gets the position of the lowest difference element.
- find the differences between value and each element of the quantized list.

"
  (nth
   (position
    (reduce #'min (mapcar #'(lambda (x) (abs (- x unquantized-value)))
                          *scale*))
    (mapcar #'(lambda (x) (abs (- x unquantized-value)))
            *scale*))
   *scale*))

(defun osc-send (host port address-pattern)
  "a basic test function which sends osc test message to a given port/hostname.
 note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (USOCKET:socket-connect host port
                                   :protocol :datagram
                                   :element-type '(unsigned-byte 8)))
        (b (apply #'osc:encode-message address-pattern)))
    (unwind-protect
         (USOCKET:socket-send s b (length b))
      (when s (USOCKET:socket-close s)))))

;;; change to individual parts
(defun send-part (part-patt osc-name)
  (osc-send #(127 0 0 1) 6450
                  (let ((addr "/audio/2/")
                        (osc-name osc-name)
                        (patt part-patt))
                    (cons (concatenate 'string addr osc-name) patt))))

(defun update-drums ()
  (progn
    (osc-send #(127 0 0 1) 6450
                    (let ((addr "/audio/2/bd")
                          (patt  *bd*))
                      (cons addr patt)))
    (osc-send #(127 0 0 1) 6450
                    (let ((addr "/audio/2/sd")
                          (patt *sd*))
                      (cons addr patt)))
    (osc-send #(127 0 0 1) 6450
                    (let ((addr "/audio/2/htom")
                          (patt *htom*))
                      (cons addr patt)))
    (osc-send #(127 0 0 1) 6450
                    (let ((addr "/audio/2/hh")
                          (patt *hh*))
                      (cons addr patt)))))

(defun pattern-generate (osc-name part-math-function)
   (let ((local-pattern nil))
  (setf local-pattern
        (mapcar #'(lambda (x)
                    (quantize-frequency
                     (funcall part-math-function x)))
                num-seq))
  (send-part local-pattern osc-name)
  local-pattern))

(defun generate-and-send (osc-name part-math-function)
  (send-part (pattern-generate osc-name part-math-function)
             osc-name))

(defun prob-generate-and-send (osc-name part-math-function prob-distribution)
  (send-part (funcall prob-distribution  (pattern-generate osc-name part-math-function))
             osc-name))

(defun bass-generate-and-send (osc-name part-math-function)
  (send-part (base-probability  (pattern-generate osc-name part-math-function))
             osc-name))

(defun mute-part (osc-name)
  (let ((local-pattern nil))
    (setf local-pattern '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
    (send-part local-pattern osc-name)))

(defun mute-drums ()
  (mute-part "bd")
  (mute-part "sd")
  (mute-part "htom")
  (mute-part "hh"))

(defun play-drums ()
  (progn
    (setf *bd* (refresh-bd))
    (setf *sd* (refresh-sd))
    (update-drums)))

(defun osc-receive (port)
  "a basic test function which attempts to decode an osc message on given port.
  note ip#s need to be in the format #(127 0 0 1) for now.. .
  - TODO funciones para sileciar par y poder ejecutar una estructura
"
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
           (if (= (nth 1 *oscrx*) 0)
               (progn
                 (generate-and-send "mid"  #' mid-math-function)
                 (mute-part "lead")
                 (mute-part "bass")
                 (play-drums)
                 (hh-base)))
           (if (= (nth 1 *oscrx*) 1)
               (progn
                (prob-generate-and-send "mid"  #' mid-math-function)
                 (mute-part "lead")
                 (mute-part "bass")
                 (mute-drums)))
           (if (= (nth 1 *oscrx*) 2)
               (progn
                 (mute-part "mid")
                 (prob-generate-and-send "lead" #'lead-math-function)
                 (bass-generate-and-send "bass" #'bass-math-function)
                 (four-on-floor)
                 (hh-base)))
           (if (= (nth 1 *oscrx*) 3)
               (progn
                 (mute-part "mid")
                 (prob-generate-and-send "lead" #'lead-math-function)
                 (play-drums)
                 (hh-base))))
      (when s (USOCKET:socket-close s)))))

(osc-receive 6667)

;; ==== live transformations
(play-drums)
(mute-drums)
(prob-generate-and-send "lead" #'lead-math-function #'base-probability)
(prob-generate-and-send "bd"   #'always-one         #'baiao-bd-probability)
(prob-generate-and-send "hh"   #'always-one         #'baiao-hh-probability)
(prob-generate-and-send "sd"   #'always-one         #'baiao-sn-probability)
(prob-generate-and-send "htom" #'always-one         #'baiao-htom-probability)

(generate-and-send "lead" #'lead-math-function)
(generate-and-send "mid"  #'mid-math-function)
(mute-part "mid")
(mute-part "lead")
(mute-part "bass")
(bass-generate-and-send "bass" #'bass-math-function)
