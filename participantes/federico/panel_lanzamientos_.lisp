;;(osc-receive 6667)



;; ==== live transformations

;; (new-part (make-list 16 :initial-element 50) #'bass-math-function "bass")
;; legacy midi
;;(prob-generate-and-send "midilead" #'lead-math-function #'base-probability)


;; test live transformations
(refresh-parts :hh :metronome)
(refresh-parts :htom :new)
(refresh-parts :lead :new :lead-dist baiao-bass-prob-dist :lead-exp '(sin (/ (* 2 i pi) 1024))) ;; variaciones en id 3d8f3e7a
(refresh-parts :mid  :new)
(refresh-parts :mid  :arpeggio)
(refresh-parts :bass :new)
(refresh-parts :bass :new)
(refresh-parts :gain :fade-in)
(refresh-parts :gain :base)
(refresh-parts :lead :new :lead-exp '(sin (sin i))
               :mid  :new
               :bass :new :bass-exp '(* 1 (tan (/ (* 2 i pi) 1024)))
               :bd :new :sd :new :hh :new) ;; all new
(refresh-parts :lead :selected
               :mid  :selected
               :bass :selected
               :bd :new :sd :new :hh :new) ;; selected
(refresh-parts :bd :new :sd :new :hh :new) ;; new drums
(refresh-parts :fill-sd :new)
(refresh-parts :fill-htom :new)
(refresh-parts :lead :mute :mid :mute :bass :mute :bd :mute :sd :mute :hh :mute :htom :mute) ;; MUTE ALL
;;(call-function-every-some-time 6 #'refresh-parts :lead :new :mid :new :bass :new :bd :new :hh :new)
