#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>C# code editor</title></head><body style='background:#2C2B34; color:white;'><p>")
(define style
      (lambda (elem)
      (string-append "<span style='color:#5AFF15'>" elem "</span>")))
(define foot "</p></body></html>")

;; Read C# file
;; https://docs.racket-lang.org/teachpack/2htdpbatch-io.html
(require 2htdp/batch-io)
(define text (read-file "read.cs"))

;; Regex 
(define text1 (regexp-replace* #rx"\n" text "<br>"))
(define text2 (regexp-replace* #rx"\\s{4}" text1 "&nbsp;"))

;; Ciclos regex
(define parseContent
  (lambda (lst txt)
         (cond
           [(empty? lst) txt]
           [(string-replace (parseContent (cdr lst) txt) (car lst) (string-append "<span style='color:yellow;'>" (car lst) "</span>"))])))

;; Regex listas
(define strings (regexp-match* #rx"(\")([^(\")])*(\")" text2))
(define text3 (parseContent strings text2))

;; Output file creation
(with-output-to-file "index.html"
      (lambda () (printf head)))

(with-output-to-file "index.html"  #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
(lambda () (printf text3)))
      
(with-output-to-file "index.html" #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf foot)))
