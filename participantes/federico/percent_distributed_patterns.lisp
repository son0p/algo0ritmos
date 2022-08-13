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
