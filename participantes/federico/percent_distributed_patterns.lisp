(defconstant all-prob            (make-list 16 :initial-element 100))

(defconstant gain-base-curve
  '(100 0 0  70  100 20  50  70   100  20 50  70   100 20 50  70)) 

(defconstant metronome-prob-dist
  '(100 0  0    0  100  0   0   0   100  0  0   0   100 0   0    0))

(defconstant base-prob-dist
  '(34  02  18  13  14  09  19  11  13  12  15  11  15  12  13  03))

(defconstant base-verbose-prob-dist
  '(44  12  28  23  24  09  29  21  23  22  25  21  25  22  33  13))

(defconstant baiao-bass-prob-dist
  '(99  01  18  99  01  01  19  01  13  01  15  11  01  01  99  01))

(defconstant baiao-bd-prob-dist
  '(99  01  01  99  01  01  99  01  99  01  01  99  01  01  99  01))

(defconstant baiao-hh-prob-dist
  '(99  01  01  99  01  99  01  01  99  01  99  01  01  99  01  01))

(defconstant baiao-sn-prob-dist
  '(01  01  99  01  01  01  99  01  01  01  99  01  01  01  99  01))

(defconstant fill-001-sn
  '(01  01  99  01  01  01  99  01  01  01  99  01  01  01  99  01))

(defconstant baiao-htom-prob-dist
  '(01  01  01  01  01  01  99  01  01  01  01  01  01  01  99  01))

(defconstant insert-prob
  '(01  10  90  01  90  01  01  70  01  01  20  10  90  01  90  20))

(defconstant bass-probability
  '(90  10  50  80  90  01  50  70  90  01  20  90  05  01  50  50))

(defconstant toms-prob-dist
  '(70 70  00  70 70 70  0  70 70 70  0  90 70 70  0  50))

;;; drums test pag 65
(defconstant refresh-bd
  '(70  10  40  90  05  10  30  20  70  05  20 70  05  10  40  40))

(defvar *prob-list* nil)
(setf *prob-list* (list
                   all-prob
                   base-prob-dist
                   base-verbose-prob-dist
                   baiao-bass-prob-dist))
