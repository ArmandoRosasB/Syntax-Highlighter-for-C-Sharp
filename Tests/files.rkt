#lang racket

;; Crear un archivo y escribir en el él
(with-output-to-file "test.txt"
(lambda () (printf "hello world")))

(define in (open-input-file "test.txt"))
(read-string 11 in)

(close-input-port in)