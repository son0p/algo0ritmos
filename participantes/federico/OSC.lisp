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

;;; ===========================================================================
;;; pool trying to conform osc:encode-message
(defvar address-pattern '("foo/bar/" 11.0 33.0 20.0 55.0))
(defvar address-pattern '("/audio/2/bass" 110.0 0.0 0.0 0.0 680.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0 ))
(defvar address-pattern '("/audio/2/bass" 500.0 0.0 0.0 0.0 680.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0 ))
(osc-send-test1 #(127 0 0 1) 6450 address-pattern)

(let ((BASS
        (let ((addr "/audio/2/bass")
              (patt (mapcar #'tan '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))))
          (cons addr patt)))
      (MID
       (let ((addr "/audio/2/mid")
              (patt (mapcar #'sin '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))))
         (cons addr patt)))
      (LEAD nil)
      (BD nil)
      (SN nil)
      (HH nil))
  (progn (osc-send-test1 #(127 0 0 1) 6450 BASS)
         (osc-send-test1 #(127 0 0 1) 6450 MID)))

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

