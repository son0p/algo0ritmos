(ql:quickload :osc)
(ql:quickload :usocket)
(defun osc-send-test (host port)
  "a basic test function which sends osc test message to a given port/hostname.
  note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (USOCKET:socket-connect host port
                           :protocol :datagram
                           :element-type '(unsigned-byte 8)))
        (b (osc:encode-message "/foo/bar" "baz" 1 2 3 (coerce PI 'single-float))))
    (format t "sending to ~a on port ~A~%~%" host port)
    (unwind-protect
 (USOCKET:socket-send s b (length b))
      (when s (USOCKET:socket-close s)))))

(osc-send-test #(127 0 0 1) 6668)

(ql:quickload :osc)
(ql:quickload :usocket)
(defun osc-receive-test (port)
  "a basic test function which attempts to decode an osc message on given port.
  note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (socket-connect nil nil
                           :local-port port
                           :local-host #(127 0 0 1)
                           :protocol :datagram
                           :element-type '(unsigned-byte 8)))
        (buffer (make-sequence '(vector (unsigned-byte 8)) 1024)))
    (format t "listening on localhost port ~A~%~%" port)
    (unwind-protect
         (loop do
           (socket-receive s buffer (length buffer))
           (format t "received -=> ~S~%" (osc:decode-bundle buffer)))
      (when s (socket-close s)))))

(osc-receive-test 6667)

(socket-connect #(127 0 0 1) 6668
                           :protocol :datagram
                           :element-type '(unsigned-byte 8))

;;; tested with simpleOSCpattern.ck --------------------
(defun osc-send-test1 (host port address-pattern)
  "a basic test function which sends osc test message to a given port/hostname.
  note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (USOCKET:socket-connect host port
                           :protocol :datagram
                           :element-type '(unsigned-byte 8)))
        ;(b (osc:encode-message "/foo/bar"  110.0 0.0 0.0 0.0 680.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0  ))) ;; working
        (b (apply #'osc:encode-message address-pattern)))
    (format t "sending to ~a on port ~A~%~%" host port)
    (unwind-protect
 (USOCKET:socket-send s b (length b))
      (when s (USOCKET:socket-close s)))))

;;; pool  to conform osc:encode-message ====================

(defvar num-seq (loop :for n :below 16 :collect n))
;(setf num-seq (nreverse num-seq))

(let ((LEAD (let ((addr "/audio/2/lead")
                  (patt (mapcar #'(lambda (x) (* (sin (+ 400 x)) 1000)) num-seq)))
              (cons addr patt)))
      (MID (let ((addr "/audio/2/mid")
                 (patt (mapcar #'(lambda (x) (* (sin (* 2 x)) 100)) num-seq)))
             (cons addr patt)))
      (BASS (let ((addr "/audio/2/bass")
                  (patt (mapcar #'(lambda (x) (* (tan (* 0.045 x)) 100)) num-seq)))
              (cons addr patt)))
      (BD (let ((addr "/audio/2/bd")
                (patt  '(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0)))
            (cons addr patt)))
      (SD (let ((addr "/audio/2/sd")
                (patt  '(0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0)))
            (cons addr patt)))
      (HH (let ((addr "/audio/2/hh")
                (patt  '(1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1)))
            (cons addr patt))))
  (progn
    (osc-send-test1 #(127 0 0 1) 6450 LEAD)
    (osc-send-test1 #(127 0 0 1) 6450 MID)
    (osc-send-test1 #(127 0 0 1) 6450 BASS)
    (osc-send-test1 #(127 0 0 1) 6450 BD)
    (osc-send-test1 #(127 0 0 1) 6450 SD)
    (osc-send-test1 #(127 0 0 1) 6450 HH)))

(defun write-stream-t1 (stream osc-message)
  "writes a given message to a stream. keep in mind that when using a buffered
   stream any funtion writing to the stream should  call (finish-output stream)
   after it sends the mesages,. ."
  (write-sequence
   (osc:encode-message "/bzzp" "got" "it" )
   stream)
  (finish-output stream))

(defmacro osc-write-to-stream (stream &body args)
  `(progn (write-sequence (osc:encode-message ,@args) ,stream)
          (finish-output ,stream)))

