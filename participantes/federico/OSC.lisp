;;;; test with simpleOSCpattern.ck (ChucK)
;;;; or MIDI Ardour morph--------------------
;;;; favs in Scripts/music_patterns.ldg
(uiop:chdir "/home/ff/Builds/algo0ritmos/participantes/federico/")

;;; librerias
(ql:quickload '(osc usocket random-sample cl-patterns alexandria sb-posix local-time))

(defun prob-generate-and-send (osc-name part-math-function prob-distribution)
  " Envía por OSC un patrón que contiene las alturas definidas por la función matemática y la activación de cada paso, definida por la distribución de probabilidades. TODO: imprime dos veces porque se llama send-part antes de la distribución"
  (format t "~& ") ;; debug
  (let ((part (funcall prob-distribution
                       (pattern-generate osc-name part-math-function))))
    (send-part part osc-name)
    (write (append (list (local-time:now)) (list osc-name) part))))

(defun pattern-generate (osc-name part-math-function)
  " Para cada X de NUM-SEQ llama la función matemática (que se pasa como argumento) luego busca el valor más cercano de *SCALE*"
  (let ((local-pattern nil))
    (setf local-pattern
          (mapcar #'(lambda (x)
                      (nearest
                       (funcall part-math-function x) *scale*))
                  num-seq))
    (send-part local-pattern osc-name)
    local-pattern))

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
                                         (cl-patterns:scale-midinotes "Natural Minor"
                                                                      :root 38
                                                                      :octave :all)))
(setf *scale* (midi-to-frequency *scale-midi*))

;;; funciones
(defun random-function (function-list)
  (let ((random-index (random (length function-list))))
    (nth random-index function-list)))

(defun random-from-range (start end)
  (+ start (random (+ 1 (- end start)))))

(defun change-range (value old-min old-max new-min new-max)
  ;; new_value = ((old_value - min_value) * factor) + new_min_value
  (let* ((factor (/ (- new-max new-min) (- old-max old-min))))
    (+ (* factor (- value old-min)) new-min)))

;; (write
;;  (let ((x (list 1 2 3 4 5 6 7 8 9 10)))
;;    (mapcar (lambda(x) (change-range (sin x) -1 1 100 200))
;;            x)))  ;; test

(defun modify-list (list position value)
  (setf (nth position list) value))

(defun subtract-lists (list1 list2)
  (mapcar #'- list1 list2))
;;(subtract-lists (make-list 16 :initial-element 100) '(90 10 11))

(defun subtract-from-list (list value)
  "warning: negative, or non numeric values"
  (mapcar (lambda (x) (if (not (zerop x)) (- value x) x)) list))

(defun random-element (lst)
  (nth (random (length lst)) lst))

(defun pattern-from-distribution (distribution frequencies)
  (let ((dist distribution) (freqs frequencies))
    (mapcar #'(lambda (x y)
                (random-element (append
                                 (make-list (- 100 x) :initial-element 0)
                                 (make-list x :initial-element y)))) dist freqs)))
;; example call
;; (pattern-from-distribution (make-list 16 :initial-element 50) (pattern-generate "lead" #'lead-math-function))

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
  "hace una lista de 1 elemento tomando valores de una lista llena según sample-segment-generator con un valor"
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
                    (cons (concatenate 'string addr osc-name) patt))))

(defun new-part (distribution-list math-function osc-name)
  (send-part (pattern-from-distribution distribution-list
                                        (pattern-generate osc-name math-function)) osc-name))

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

(mute-part "bass")

(defun new-lead ()
  (new-part metronome-prob-dist
            (lambda (x) (change-range (- (expt (sin x) (random-from-range 1 3)) 0.4) -1 1 600 2698)) "lead"))
(defun new-mid ()
  (new-part base-prob-dist
          (lambda (x) (change-range (expt (cos x) 4) -1 1 200 600)) "mid"))
(defun new-bass ()
  (new-part base-prob-dist
            (lambda (x) (change-range (sin x) -1 1 70 300))   "bass"))

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
           (format t "~%~%")
           (format t "received -=> ~S~%~%" (osc:decode-bundle buffer))
           (setf *oscRx* (osc:decode-bundle buffer))
           (if (= (nth 1 *oscrx*) 0)
               (progn
                 (play-drums)
                 (new-lead)))
           (if (= (nth 1 *oscrx*) 1)
               (progn
                 (new-mid)
                ;; (mute-part "lead")
                 (mute-part "bass")
                 (mute-drums)))
           (if (= (nth 1 *oscrx*) 2)
               (progn
                 (play-drums)
                 ;;(mute-part "mid")
                 (new-lead)
                 (new-bass)))
           (if (= (nth 1 *oscrx*) 3)
               (progn
                 (play-drums)
                 (mute-part "mid")
                 (new-lead))))
      (when s (USOCKET:socket-close s)))))

(osc-receive 6667)

;; cargarlo después de tener update-drums
(load (merge-pathnames "percent_distributed_patterns.lisp" (uiop:getcwd)))
;; ==== live transformations
(new-lead)
(new-mid)
(new-bass)
;; (new-part (make-list 16 :initial-element 50) #'bass-math-function "bass")

(play-drums)
(mute-drums)
;;(prob-generate-and-send "lead" #'lead-math-function (random-function *prob-list*))

(mute-part "lead")
(mute-part "mid")
(mute-part "bass")

;; legacy midi
;;(prob-generate-and-send "midilead" #'lead-math-function #'base-probability)

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
