(load "~/quicklisp/setup.lisp")
(ql:quickload "iolib")
(ql:quickload "inferior-shell")

(require 'inferior-shell)

(inferior-shell:run "oscchief send 127.0.0.1 6448 /audio/1/foo  ffffffffffffffff 0.222 0.111 0.333 0.444 1 1 1 1 1 1 1 1 1 1 1 1"
                             :on-error nil
                             :error-output :string
                             :output :string)

(inferior-shell:run "oscchief send 127.0.0.1 6448 /audio/1/foo  ffffffffffffffff 30.0 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45"
                             :on-error nil
                             :error-output :string
                             :output :string)
