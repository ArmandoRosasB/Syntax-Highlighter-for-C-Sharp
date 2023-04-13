#lang racket
(require 2htdp/batch-io)
(define text (read-file "read.cs"))
(define ans (regexp-match* #rx"[/*].*[*/]" text))
ans