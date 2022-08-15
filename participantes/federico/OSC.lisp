;;;; test with simpleOSCpattern.ck (ChucK)--------------------

(uiop:chdir "/home/ff/builds/algo0ritmos/participantes/federico/")

;;; librerias
;;(ql:quickload '(osc usocket random-sample cl-patterns))
;;(use-package 'cl-patterns)
(load "/home/ff/builds/algo0ritmos/participantes/federico/percent_distributed_patterns.lisp")

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

(setf *scale*
      (cl-patterns:multi-channel-funcall #'floor
                                         (cl-patterns:scale-midinotes "lydian"
                                                                      :root 36
                                                                      :octave :all)))

;;; funciones
(defun random-from-range (start end)
  (+ start (random (+ 1 (- end start)))))

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
(defun lead-math-function (x) (+ 100 (* (random-from-range 5 10) (sin x))))
(defun mid-math-function  (x) (+  50 (* (random-from-range 5 10) (cos x))))
(defun bass-math-function (x) (+  30 (* (random-from-range 2  5) (tan x))))

(defun nearest (input list)
  "Get the element in LIST nearest to INPUT.

See also: `near-p'"
  (reduce (lambda (a b)
            (if (> (abs (- input a))
                   (abs (- input b)))
                b
                a))
          list))

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

(defun pattern-generate (osc-name part-math-function)
   (let ((local-pattern nil))
  (setf local-pattern
        (mapcar #'(lambda (x)
                    (nearest
                     (funcall part-math-function x) *scale*))
                num-seq))
  (send-part local-pattern osc-name)
     local-pattern
     (print local-pattern)))

(defun prob-generate-and-send (osc-name part-math-function prob-distribution)
  (send-part (funcall prob-distribution  (pattern-generate osc-name part-math-function))
             osc-name)
  (print osc-name))

(defun mute-part (osc-name)
  (let ((local-pattern nil))
    (setf local-pattern '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
    (send-part local-pattern osc-name)))

(defun mute-drums ()
  (mute-part "bd")
  (mute-part "sd")
  (mute-part "htom")
  (mute-part "hh"))

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
                 (prob-generate-and-send "bass" #'bass-math-function)
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
(progn
  (prob-generate-and-send "lead" #'lead-math-function #'base-probability)
  (prob-generate-and-send "mid"  #'mid-math-function  #'base-probability)
  (prob-generate-and-send "bass" #'bass-math-function #'base-probability))

(progn
  (prob-generate-and-send "midilead" #'lead-math-function #'all-probability)
  (prob-generate-and-send "midimid"  #'mid-math-function  #'base-probability)
  (prob-generate-and-send "midibass" #'bass-math-function #'base-probability))

(prob-generate-and-send "midilead" #'lead-math-function #'all-probability)

(prob-generate-and-send "bd"   #'always-one         #'baiao-bd-probability)
(prob-generate-and-send "hh"   #'always-one         #'baiao-hh-probability)
(prob-generate-and-send "sd"   #'always-one         #'baiao-sn-probability)
(prob-generate-and-send "htom" #'always-one         #'baiao-htom-probability)

(mute-part "mid")
(mute-part "lead")
(mute-part "bass")
