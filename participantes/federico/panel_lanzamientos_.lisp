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
