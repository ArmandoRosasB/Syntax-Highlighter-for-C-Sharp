#lang racket
(require 2htdp/batch-io)
(define text (read-file "read.cs"))

(define ans
    (lambda (op) (regexp-match* #rx(string-append "\"[" op "]\"") text)))
(ans "+")
