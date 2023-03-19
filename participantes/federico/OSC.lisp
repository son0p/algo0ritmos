;;;; test with simpleOSCpattern.ck (ChucK)
;;;; or MIDI Ardour morph--------------------
(uiop:chdir "/home/ff/Builds/algo0ritmos/participantes/federico/")

;;; librerias
(ql:quickload '(osc usocket random-sample cl-patterns alexandria sb-posix))

;; cargarlo después de tener update-drums
(load (merge-pathnames "percent_distributed_patterns.lisp" (uiop:getcwd)))

(defun prob-generate-and-send (osc-name part-math-function prob-distribution)
  " Envía por OSC un patrón que contiene las alturas definidas por la función matemática y la activación de cada paso, definida por la distribución de probabilidades. TODO: imprime dos veces porque se llama send-part antes de la distribución"
  (send-part (funcall prob-distribution  (pattern-generate osc-name part-math-function))
             osc-name))

(defun pattern-generate (osc-name part-math-function)
  " Para cada X de NUM-SEQ llama la función matemática (que se pasa como argumento) y busqua el valor más cercano de *SCALE*"
  ;;(format t "~& ===>> ~s" osc-name) ;; debug
  (let ((local-pattern nil))
    (setf local-pattern
          (mapcar #'(lambda (x)
                      (nearest
                       (funcall part-math-function x) *scale*))
                  num-seq))
    (send-part local-pattern osc-name)
    local-pattern))

(defun lead-math-function (x) (* (sin x) (random-from-range 500 600)))
(defun mid-math-function  (x) (* (sin x) (random-from-range 200 300)))
(defun bass-math-function (x) (* (sin x) (random-from-range 400 500)))
(defun always-one (x) (/ (+ x 1) (+ x 1)))

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
  (defvar *scale-midi* nil)  ; make local let
  (defvar num-seq (loop :for n :below 16 :collect n))) ; TODO: es +constante+?

(defun midi-to-frequency (notes)
  "Convert a list of MIDI note numbers to their corresponding frequencies"
  (mapcar (lambda (note)
            (float (* 440 (expt 2 (/ (- note 69) 12)))))
          notes))

(setf *scale-midi*
      (cl-patterns:multi-channel-funcall #'floor
                                         (cl-patterns:scale-midinotes "Harmonic Minor"
                                                                      :root 38
                                                                      :octave :all)))
(setf *scale* (midi-to-frequency *scale-midi*))

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
                    (cons (concatenate 'string addr osc-name) patt)))
      ;;(write part-patt) (write osc-name)  (format t "~&") ;; debug
  )



(prob-generate-and-send "lead" #'lead-math-function #'all-probability)

(defun play-drums ()
  (progn
    (prob-generate-and-send "bd"   #'always-one         #'baiao-bd-probability)
    (prob-generate-and-send "hh"   #'always-one         #'baiao-hh-probability)
    (prob-generate-and-send "sd"   #'always-one         #'baiao-sn-probability)
    (prob-generate-and-send "htom" #'always-one         #'baiao-htom-probability)))

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
  - TODO ¿para qué se recibe un flotante como tercer argumento?
  - ERROR: al recibir 0 genera un patron con valor mínimo que se traduce en freq 73
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
           (write *oscRx*)
           (if (= (nth 1 *oscrx*) 0)
               (progn
                 (play-drums)
                 (prob-generate-and-send "lead" #'lead-math-function #'all-probability)
                 ))
           (if (= (nth 1 *oscrx*) 1)
               (progn
                 (prob-generate-and-send "mid"  #'mid-math-function #'base-probability)
                ;; (mute-part "lead")
                ;; (mute-part "bass")
                 (mute-drums)
                 ))
           (if (= (nth 1 *oscrx*) 2)
               (progn
                 (play-drums)
                 ;;(mute-part "mid")
                 (prob-generate-and-send "lead" #'lead-math-function #'base-probability)
                 (prob-generate-and-send "bass" #'bass-math-function #'all-probability)))
           (if (= (nth 1 *oscrx*) 3)
               (progn
                 (play-drums)
                 (mute-part "mid")
                 (prob-generate-and-send "lead" #'lead-math-function #'base-probability)
                 ;;(play-drums)
                 ;;(hh-base)
                 ))
               )
      (when s (USOCKET:socket-close s)))))

(osc-receive 6667)

;; ==== live transformations

(play-drums)
(mute-drums)
(progn
  (prob-generate-and-send "lead" #'lead-math-function #'all-probability)
  (prob-generate-and-send "mid"  #'mid-math-function  #'base-probability)
  (prob-generate-and-send "bass" #'bass-math-function #'base-probability))

(progn
  (prob-generate-and-send "midilead" #'lead-math-function #'base-probability)
  (prob-generate-and-send "midimid"  #'mid-math-function  #'base-probability)
  (prob-generate-and-send "midibass" #'bass-math-function #'base-probability))

(prob-generate-and-send "midilead" #'lead-math-function #'base-probability)

(prob-generate-and-send "midimid"  #'mid-math-function  #'base-probability)

(prob-generate-and-send "midibass" #'bass-math-function #'baiao-bass-probability)

(prob-generate-and-send "midilead" #'lead-math-function #'base-verbose-probability)

(prob-generate-and-send "midimid"  #'mid-math-function  #'base-verbose-probability)

(prob-generate-and-send "midibass" #'bass-math-function #'base-verbose-probability)



;; ====== test 
(cl-patterns:multi-channel-funcall #'mute-part '("lead" "midilead" "mid" "midimid" "bass" "midibass"))
(mute-part "midilead")
(mute-part "bass")
(mute-part "lead")
(mute-part "bass")

(ql:quickload 'cl-patterns/alsa-midi)
(use-package 'cl-patterns)
(defparameter *pat* (pbind :foo (pseq '(1 2 3))
                           :bar (prand '(9 8 7) 5)))

(defparameter *pstream* (as-pstream *pat*))
(next-n *pstream* 3)

(pb :automatic-jazz
  :note (pshuf (scale-notes :minor) 4)
  :octave (pr (pwhite 2 7))
  :root (pr (pwhite 0 12))
  :dur (pshuf (list 1/3 1/4)))
