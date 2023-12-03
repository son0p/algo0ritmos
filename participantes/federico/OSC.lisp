;;;; test with simpleOSCpattern.ck (ChucK) y panel_lanzamientos.lisp
;;;; or MIDI Ardour morph--------------------
;;;; favs in Scripts/music_patterns.ldg
(uiop:chdir "/home/ff/Builds/algo0ritmos/participantes/federico/")

;;; librerias
(ql:quickload '(osc usocket random-sample cl-patterns alexandria sb-posix local-time))

(load (merge-pathnames "percent_distributed_patterns.lisp" (uiop:getcwd)))

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

(define-condition not-in-range (error)
  ((message :initarg :message :reader message)))

;;; variables
(progn
  (defvar *fill-time* 2 ) ; FIX: debe ser en beats, si sobrepasa el tiempo del beat se refresca chuck y no se aplica
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

(defun random-list ()
  "Generate a list of 16 random numbers between 0 and 100"
  (loop repeat 16 collect (random 101)))

(defun random-from-range (start end)
  (+ start (random (+ 1 (- end start)))))

(defun change-range (value old-min old-max new-min new-max)
  "ALERTA: la función que llama debe sanear _value_ verificando que esté dentro del rango"
  ;; new_value = ((old_value - min_value) * factor) + new_min_value
   (if (and (<= old-min value)
            (<= value old-max))
       (error 'not-in-range :message "value not inside original range"))
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

(defun call-function-every-some-time (time my-function)
  "Call my-function every x seconds"
  (loop repeat 5
        do (funcall my-function)
        do (sleep time)))

(defun append-result-to-file (file function &rest args)
  "Append the result of FUNCTION with ARGS to FILE."
  (with-open-file (stream file
                          :direction :output
                          :if-exists :append
                          :if-does-not-exist :create)
    (write (apply function args) :stream stream)))

(defun append-string-to-file (file string)
  (with-open-file (stream file
                          :direction :output
                          :if-exists :append
                          :if-does-not-exist :create)
    (format stream "~%~A~%" string)))

(defun pattern-from-distribution (distribution frequencies)
  "recibe dos listas?, hace una lista de 100 para seleccionar si suena o no?"
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

(defun equidistant-samples (list-of-elements num-samples)
  (let* ((total-elements (length list-of-elements))
         (step-size (/ total-elements num-samples)))
    (loop for i from 0 below num-samples
          collect (nth (round (* i step-size)) list-of-elements))))

;; Example usage:
;;(let ((my-list '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)))
;;  (equidistant-samples my-list 16))

(defun number-to-binary-16bit (number)
  (format nil "~16,'0b" number))

(defun numbers-to-binary-16bit (numbers)
  (format t "~{~a~&~}" (mapcar #'number-to-binary-16bit numbers)))

(defun binary-to-list (binary)
  (map 'list (lambda (char) (if (char= char #\1) 1 0)) binary))

(defun binary-pattern-from-number (number)
    (binary-to-list (reverse (format nil "~&~16,'0B" number))))

(defun binary-patterns-from-numbers (numbers)
  (mapcar #'binary-pattern-from-number numbers))

(dotimes (i 10) (print (binary-pattern-from-number i)))

;; Example usage
;; (numbers-to-binary-16bit '(34952 2056 8738))

(defun cross-expression-verify (x)
  "Verifica si dos expresiones matemáticas son iguales (¿se cruzan?), en este caso dos funciones, una recta y una seno, uso: (loop for x from 1 to 100 collecting (cross-expression-verify x))"
  (let ((offset-recta 0)
        (pendiente-recta 45)
        (y 5)
        (offset-seno 0)
        (multiplicador-seno 1)
        (multiplicador-frecuencia 1))
    (=
     (+ offset-recta (* pendiente-recta y))
     (+ offset-seno (* multiplicador-seno (sin (* multiplicador-frecuencia x)))))))

(defun find-crossing-points (func1 func2 start end step)
  (loop for x from start to end by step
        for y1 = (funcall func1 x)
        for y2 = (funcall func2 x)
        when (< (abs (- y1 y2)) 0.01) ; Adjust the threshold as needed for precision
        collect (list x y1)))

;; Example usage
(let ((offset-recta 0)
      (pendiente-recta 0.0005)
      (offset-seno 0)
      (multiplicador-seno 1)
      (multiplicador-frecuencia 0.012))
  (defun f1 (x)
    (+ offset-recta (* pendiente-recta x)))
  (defun f2 (x)
    (+ offset-seno (* multiplicador-seno (sin (* multiplicador-frecuencia x))))))

(let ((crossing-points (find-crossing-points #'f1 #'f2 0 1 0.01)))
  (dolist (point crossing-points)
    (format t "Crossing point: ~a, ~a~%" (first point) (second point))))

(defun points-from-functions (func1 func2 start end step)
  (loop for x from start to end by step
        for y1 = (funcall func1 x)
        for y2 = (funcall func2 x)
        collect (list y1 y2)))

(defun plot-x-y ()
  (let ((crossing-points (find-crossing-points #'f1 #'f2 0 1 0.01)))
    (dolist (point crossing-points)
      (return (format t "~a, ~a~%" (first point) (second point) )))))

(defun plot-two-functions ()
  (let ((result-string "") (points (points-from-functions #'f1 #'f2 0 1024 1)))
    (dolist (point points)
      (setq result-string (concatenate 'string result-string (format nil "~a, ~a~%" (first point) (second point)))))
    (with-open-file (output-file "/tmp/output.txt"
                                 :direction :output
                                 :if-exists :supersede)
      (format output-file "~a" result-string))))

;; Example usage
(plot-two-functions)

;; (let ((values (flatten (points-from-functions #'f1 #'f2 0 1024 1))))
 ;; (format t "~{~a~}" (add-newline-every-two-values-recursion values)))

;;(add-newline-every-two-values-recursion (flatten (points-from-functions #'f1 #'f2 0 1024 1)))

;;(append-result-to-file "/tmp/output.txt" #'add-newline-every-two-values-recursion (flatten (points-from-functions #'f1 #'f2 0 1024 1)))


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

(defun send-part-from-selected (part-patt osc-name)
  (format t "~& ")
   (let ((addr "/audio/2/")
         (osc-name osc-name)
         (patt part-patt))
     (osc-send #(127 0 0 1) 6450
               (cons (concatenate 'string addr osc-name) patt))
               (write (append (list patt osc-name)))))
 
(defun new-part (distribution-list math-function osc-name)
  ;;(format t "~& ")
  (let ((patt (pattern-from-distribution
              distribution-list
              (pattern-generate osc-name math-function))))
    (send-part patt osc-name)
    (append-result-to-file "/tmp/output.txt" #'append (list patt osc-name))))

(defun inject-part-from-list (lst osc-name)
  (send-part lst osc-name))

(defun mute-part (osc-name)
  (let ((local-pattern nil))
    (setf local-pattern '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
    (send-part local-pattern osc-name)))

(defun export_math_matrix_to_file (filename size math-expression)
  "To draw with gnuplot"
  (with-open-file (output-stream filename
                                 :direction :output
                                 :if-exists :supersede)
    (loop for i from 0 below size
          for value = (eval `(let ((i ,i)) ,math-expression))
          do (format output-stream "~d ~f~%" i value))))
;; test: (export_math_matrix_to_file "/tmp/output.txt" 1024 '(tan (/ (* 2 i pi) 1024)))

(defun math_expression_to_list (size math-expression)
      (loop for i from 0 below size
          for value = (coerce (eval `(let ((i ,i)) ,math-expression)) 'single-float)
            collect value))
;; test:  (equidistant-samples (math_expression_to_list 1024 '(sin (/ (* 2 i pi) 1024))) 16)

(defun math-expression-selected-values (number-of-values math-expression min-range max-range)
  "TODO: pasar el rango como argumento, ¿qué pasa si sale un número negativo?"
  (let ((values (math_expression_to_list 1024 math-expression)))
    (mapcar (lambda (x) (change-range x (apply #'min values) (apply #'max values) min-range max-range))
            (equidistant-samples values number-of-values))))

(defun refresh-parts (&key lead lead-exp lead-dist mid mid-exp mid-dist bass bass-exp bass-dist bd sd hh htom fill-sd fill-htom (gain :base))
  "Aunque define los casos, el llamado podría ser más legible, el segundo parámentro sin los dos puntos, tipo :lead new"
  (case lead
    (:new (send-part-from-selected (pattern-from-distribution
                                     lead-dist
                                     (mapcar
                                      (lambda (x) (nearest x *scale*))
                                      (math-expression-selected-values 16 lead-exp 600 2000)))
                                    "lead" ))
    (:mute (mute-part "lead"))
    (:selected (send-part-from-selected (write (random-element *selected-bass*)) "lead"))
    (:2f934e3a (send-part-from-selected (write (nth 0 *selected-2f934e3a*)) "lead")))
  (case mid
    (:new (send-part-from-selected (pattern-from-distribution
                                     mid-dist
                                     (mapcar
                                      (lambda (x) (nearest x *scale*))
                                      (math-expression-selected-values 16 mid-exp 200 800)))
                                    "mid" ))
    (:mute (mute-part "mid"))
    (:arpeggio  (new-part arpeggio-prob-dist
                     (lambda (x) (change-range
                                  (sin x) 
                                  -1 1 200 600)) "mid")))
  (case bass
    (:new  (send-part-from-selected (pattern-from-distribution
                                     bass-dist
                                     (mapcar
                                      (lambda (x) (nearest x *scale*))
                                      (math-expression-selected-values 16 bass-exp 60 200)))
                                    "bass")) 
    (:mute (mute-part "bass"))
    (:selected (send-part-from-selected (random-element *selected-bass*) "bass")))
  (case bd
    (:new (new-part (random-list)
            (lambda (x) (change-range
                         (- (expt (sin x) (random-from-range 1 3)) 0.4)
                         -1 1 600 2698)) "bd"))
    (:mz  (inject-part-from-list bd-mz-drop "bd"))
    (:mute (mute-part "bd")))
  (case sd
    (:new (new-part baiao-sn-prob-dist
            (lambda (x) (change-range
                         (- (expt (sin x) (random-from-range 1 3)) 0.4)
                         -1 1 600 2698)) "sd"))
    (:mute (mute-part "sd")))
  (case hh
    (:new (new-part (random-list)
            (lambda (x) (change-range
                         (- (expt (sin x) (random-from-range 1 3)) 0.4)
                         -1 1 600 2698)) "hh"))
    (:mute (mute-part "hh"))
    (:metronome (send-part-from-selected metronome-prob-dist "hh")))
  (case htom
    (:new  (new-part toms-prob-dist
            (lambda (x) (change-range
                         (sin x)
                         -1 1 100 300)) "htom"))
    (:mute (mute-part "htom")))
  (case fill-sd
    (:new  (progn
             (new-part (random-list)
                       (lambda (x) (change-range
                                    (- (expt (sin x) (random-from-range 1 3)) 0.4)
                                    -1 1 600 2698)) "sd")
             (sleep *fill-time*)
             (refresh-parts :sd :new)))
    (:mute (mute-part "sd")))
   (case fill-htom
     (:new  (progn
              (new-part (random-list)
                        (lambda (x) (change-range
                                     (- (expt (sin x) (random-from-range 1 3)) 0.4)
                                     -1 1 100 250)) "htom")
              (sleep *fill-time*)
              (refresh-parts :htom :mute)))
     (:mute (mute-part "htom")))
  (case gain
    (:base (send-part gain-base-curve "gain"))
    (:fade-in (send-part gain-fade-in-curve "gain")))
  (append-string-to-file "/tmp/output.txt" "===================="))
 

(defun osc-cases ()
  (if (= (nth 1 *oscrx*) 0)
      (refresh-parts :lead :new :bass :new :bd :new :sd :new :hh :new))
  (if (= (nth 1 *oscrx*) 1)
      (refresh-parts :mid :new :bass :mute :bd :mute :sd :mute))
  (if (= (nth 1 *oscrx*) 2)
      (refresh-parts :lead :new :bass :new :bd :new :sd :new :hh :new))
  (if (= (nth 1 *oscrx*) 3)
      (refresh-parts :lead :new :mid :mute :bass :new :bd :new :sd :new :hh :new))
  (if (= (mod (nth 1 *oscrx*) 64) 50)
      (refresh-parts :fill-htom :new)))

(defun osc-compare ()
   (if (= (mod (nth 1 *oscrx*) 16) 15)
      (refresh-parts :lead :2f934e3a) )
    (if (= (mod (nth 1 *oscrx*) 32) 31)
      (refresh-parts :lead :new)))

(defun osc-receive (port)
  "a basic test function which attempts to decode an osc message on given port.
  note ip#s need to be in the format #(127 0 0 1) for now.. . "
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
           ;;(format t "~%~%")
           ;;(format t "received -=> ~S~%~%" (osc:decode-bundle buffer))
           (setf *oscRx* (osc:decode-bundle buffer))
           (osc-compare))
      (when s (USOCKET:socket-close s)))))


