;;(osc-receive 6667)



;; ==== live transformations

;; (new-part (make-list 16 :initial-element 50) #'bass-math-function "bass")
;; legacy midi
;;(prob-generate-and-send "midilead" #'lead-math-function #'base-probability)

;; all scales https://github.com/defaultxr/cl-patterns/blob/master/src/scales.lisp
  ;; ;; 7 note scales
  ;;          ("Major" (0 2 4 5 7 9 11) :et12)
  ;;          ("Ionian" (0 2 4 5 7 9 11) :et12)
  ;;          ("Dorian" (0 2 3 5 7 9 10) :et12)
  ;;          ("Phrygian" (0 1 3 5 7 8 10) :et12)
  ;;          ("Lydian" (0 2 4 6 7 9 11) :et12)
  ;;          ("Mixolydian" (0 2 4 5 7 9 10) :et12)
  ;;          ("Aeolian" (0 2 3 5 7 8 10) :et12)
  ;;          ("Natural Minor" (0 2 3 5 7 8 10) :et12 (:minor))
  ;;          ("Locrian" (0 1 3 5 6 8 10) :et12)

  ;;          ("Harmonic Minor" (0 2 3 5 7 8 11) :et12)
  ;;          ("Harmonic Major" (0 2 4 5 7 8 11) :et12)

  ;;          ("Melodic Minor" (0 2 3 5 7 9 11) :et12)
  ;;          ("Melodic Minor Descending" (0 2 3 5 7 8 10) :et12 (:melodicminordesc))
  ;;          ("Melodic Major" (0 2 4 5 7 8 10) :et12)

  ;;          ("Bartok" (0 2 4 5 7 8 10) :et12)
  ;;          ("Hindu" (0 2 4 5 7 8 10) :et12)

(setf *scale-midi*
      (cl-patterns:multi-channel-funcall #'floor
                                         (cl-patterns:scale-midinotes "Harmonic Minor"
                                                                      :root 38
                                                                      :octave :all)))

;; test live transformations
(refresh-parts :hh :metronome)
(refresh-parts :htom :new)
(refresh-parts :lead :new :lead-dist baiao-bass-prob-dist :lead-exp '(sin (/ (* 2 i pi) 1024))) ;; variaciones en id 3d8f3e7a
(refresh-parts :mid  :new)
(refresh-parts :mid  :arpeggio)
(refresh-parts :bass :new :bass-dist baiao-bass-prob-dist :bass-exp '(sin (/ (* 2 i pi) 1024)))
(refresh-parts :gain :fade-in)
(refresh-parts :gain :base)

(refresh-parts :lead :new :lead-dist base-verbose-prob-dist :lead-exp '(sin i)
               :mid :new :mid-dist base-verbose-prob-dist :mid-exp '(sin (sin i))
               :bass :new :bass-dist base-prob-dist :bass-exp '(cos (cos i))
               :bd :mz :sd :new :hh :new) ;; all new

(defun build ()
    (refresh-parts :lead :new :lead-dist base-verbose-prob-dist :lead-exp '(sin i)
               :mid :new :mid-dist base-verbose-prob-dist :mid-exp '(sin (sin i))
               :bass :mute :bass-dist base-prob-dist :bass-exp '(cos (cos i))
                   :bd :mute :sd :new :hh :new))

(defun drop ()
    (refresh-parts :lead :new :lead-dist base-verbose-prob-dist :lead-exp '(sin i)
               :mid :new :mid-dist base-verbose-prob-dist :mid-exp '(sin (sin i))
               :bass :new :bass-dist base-prob-dist :bass-exp '(cos (cos i))
                   :bd :new :sd :new :hh :new))
(build)
(drop)


(refresh-parts :lead :selected
               :mid  :selected
               :bass :selected
               :bd :new :sd :new :hh :new) ;; selected

(refresh-parts :bd :new :sd :new :hh :new) ;; new drums
(refresh-parts :bd :mz) 
(refresh-parts :fill-sd :new)
(refresh-parts :fill-htom :new)
(refresh-parts :lead :mute :mid :mute :bass :mute :bd :mute :sd :mute :hh :mute :htom :mute) ;; MUTE ALL
;;(call-function-every-some-time 6 #'refresh-parts :lead :new :mid :new :bass :new :bd :new :hh :new)

;; === Roca Vultra
(setf *scale-midi*
      (cl-patterns:multi-channel-funcall #'floor
                                         (cl-patterns:scale-midinotes "Harmonic Minor"
                                                                      :root 38
                                                                      :octave :all)))
;; intro
(send-part-from-selected '(0 0 0 1396.913 0 0 0 0 0 0 1046.5022  0 0 0 0 0) "lead")
(send-part-from-selected '(0 0 0 0 440.0 0 0 0 0 0 523.2511 0 0  523.2511 0 0) "mid")
(send-part-from-selected '(220.0 0 110.0 73.41619 0 0 0 0 0 0  329.62756 73.41619 0 0 329.62756 0) "bass")
(send-part-from-selected '(1174.659 1864.6552 0 0 0 220.0  1318.5103 0 2349.318 1567.9817 0 0 1567.9817 1760.0 2349.318 1864.6552) "bd")
(send-part-from-selected '(0 0 2093.0044 0 0 0 1318.5103 0 0 0 1046.5022 0 0 0 2349.318 0) "sd")
(send-part-from-selected '(0 0 0 1396.913 0 2093.0044 0 1864.6552  2349.318 1318.5103 1046.5022 174.61412 659.2551 0 2349.318 0) "hh")

;; cl-patterns try
;; usa la forma (next-n (pseq (lista) bucles) tamaño)
(send-part (mapcar
            (lambda (x) (nearest x *scale*))
            (cl-patterns::next-n (cl-patterns::pseq '(1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 1300 1400) 1) 16)) "lead")

(send-part (mapcar
            (lambda (x) (nearest x *scale*))
            (cl-patterns::next-upto-n (cl-patterns::protate (cl-patterns::pseq '(1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 1300 1400) 1) 3))) "lead")

(send-part (mapcar
            (lambda (x) (nearest x *scale*))
            (cl-patterns::next-n (cl-patterns::prand '(1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 1300 1400) 16) 16)) "lead")


