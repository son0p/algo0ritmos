(defvar all-prob            (make-list 16 :initial-element 100))

(defvar gain-base-curve
  '(100 70 90  80  100 70  90  80   100  70 90  80   100 70 90  80))

(defparameter gain-fade-in-curve
  '(10 20 30  40  50 60  70  80   90  93 94  95  96 97 98  99)) 

(defvar metronome-prob-dist
  '(440 0   0   0  330  0   0  0    330  0  0   0      330 0  0   0))

(defvar arpeggio-prob-dist
  '(100 05 100  05  100 05  90  05   100  05 90  05   100 05 90  0)) 

(defvar base-prob-dist
  '(34  02  18  13  14  09  19  11  13  12  15  11  15  12  13  03))

(defvar base-verbose-prob-dist
  '(44  12  28  23  24  09  29  21  23  22  25  21  25  22  33  13))

(defvar baiao-bass-prob-dist
  '(99  01  18  99  01  01  19  01  13  01  15  11  01  01  99  01))

(defvar baiao-bd-prob-dist
  '(99  01  01  99  01  01  99  01  99  01  01  99  01  01  99  01))

(defvar baiao-hh-prob-dist
  '(99  01  01  99  01  99  01  01  99  01  99  01  01  99  01  01))

(defvar baiao-sn-prob-dist
  '(01  01  99  01  01  01  99  01  01  01  99  01  01  01  99  01))

(defvar fill-001-sn
  '(01  01  99  01  01  01  99  01  01  01  99  01  01  01  99  01))

(defvar baiao-htom-prob-dist
  '(01  01  01  01  01  01  99  01  01  01  01  01  01  01  99  01))

(defvar insert-prob
  '(01  10  90  01  90  01  01  70  01  01  20  10  90  01  90  20))

(defvar bass-probability
  '(90  10  50  80  90  01  50  70  90  01  20  90  05  01  50  50))

(defvar toms-prob-dist
  '(70 70  00  70 70 70  0  70 70 70  0  90 70 70  0  50))

;;; drums test pag 65
(defvar refresh-bd
  '(70  10  40  90  05  10  30  20  70  05  20 70  05  10  40  40))

(defvar bd-mz-drop
  '(99  00  00  00  00  00  00  00  00  90  00  00  00  00  00  00))


(defvar *prob-list* nil)
(setf *prob-list* (list
                   all-prob
                   base-prob-dist
                   base-verbose-prob-dist
                   baiao-bass-prob-dist))

(defvar *selected-bass* nil)
(setf *selected-bass* (list
                      '(220.0 0 174.61412 261.62555 0 0 0 0  0 0 0 0 0 0 130.81277 0)
                      '(220.0 0 0 0 0 0 0 0 0 0 329.62756 220.0 0 116.54095 261.62555 0)
                      '(164.81378 0 0 174.61412 0 0  130.81277 220.0 0 0 110.0 0 0 0 261.62555 0)
                      '(164.81378 0 0 174.61412 0 0 0 0 261.62555 0 0 0 0 0 261.62555 0)))

(defvar *selected-lead* nil)
(setf *selected-lead* (list
                       '(1174.659 0 0 0 0 0 0 0 0 0 0 0  1046.5022 0 0 0)
                       '(1174.659 0 0 1174.659 0 0 0 0 0 0 0 0 0 0 2349.318 0)))

      

(defvar *selected-mid* nil)
(setf *selected-mid* (list
                       '( 0 0 0 0 0 0 0 0 0 523.2511 0 391.99542 0 0 391.99542 0)
                       '(1174.659 0 0 1174.659 0 0 0 0 0 0 0 0 0 0 2349.318 0)))
(defvar *selected-2f934e3a* nil)
(setf *selected-2f934e3a* (list
                           '(1174.659 0 0 0 0 0 0 0 0 0 0 0  1046.5022 0 0 0)))

(defvar patt-test nil)
(setf patt-test (list
             '(f0a9880b 782b0316 90)
             '(f0a9880b 882e2b57 10)
             '(782b0316 f0a9880b 99)
             '(882e2b57 f0a9880b 99)))


      

