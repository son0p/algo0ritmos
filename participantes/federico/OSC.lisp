(ql:quickload :osc)
(ql:quickload :usocket)
; (ql:quickload "usocket")
;(ql:quickload "inferior-shell")

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

;; tested with simpleOSCpattern.ck --------------------

(defun osc-send-test1 (host port list)
  "a basic test function which sends osc test message to a given port/hostname.
  note ip#s need to be in the format #(127 0 0 1) for now.. ."
  (let ((s (USOCKET:socket-connect host port
                           :protocol :datagram
                           :element-type '(unsigned-byte 8)))
        (b (osc:encode-message "/audio/2/bass"  110.0 0.0 0.0 0.0 680.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0 100.0 0.0 0.0 0.0  )))
    (format t "sending to ~a on port ~A~%~%" host port)
    (unwind-protect
 (USOCKET:socket-send s b (length b))
      (when s (USOCKET:socket-close s)))))

(osc-send-test1 #(127 0 0 1) 6450 (list 1 2 3 4))

;; ===========================================================================
;; pool trying to conform osc:encode-message
(setq *osc-message* '(list '("/foo/bar" "baz" 1 2 3 (coerce PI 'single-float))))
(let test '((string "/foo/bar") "baz" 1 2 3 (COERCE PI 'SINGLE-FLOAT)))
(type-of(car test)) ;; firt element
(type-of(intern (string (car test))))

(let ((str "/foo/bar")
      (str2 "baz"))
  (str str2))

(let ((str "Hello, world!"))
  (string-upcase str))

(let ((str1 "Hello, world!")
      (str2 "me too"))
  (string-downcase (append '(str1 str2))))

