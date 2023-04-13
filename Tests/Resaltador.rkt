;; Referencia
;; Pg. 55 http://memoriascimted.com/wp-content/uploads/2021/04/Programación-de-datos-con-Racket.pdf

;; Open-input-file - Abre un archivo para lectura
;; (open-input-file <ruta> [#:mode {‘binary | ‘text}])

;; Open-output-file - Abre un archivo para escritura
;; (open-output-file <ruta> [{#:mode {‘binary | ‘text}}]? [{#:exists {‘error|’append|’update|’canupdate|’replace|’truncate|’musttruncate}}]?)

#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>C# code editor</title></head><body style='background:#2C2B34; color:white;'> <p>Test</p>")
(define style
      (lambda (elem)
      (string-append "<p style='color:#5AFF15'>" elem "</p>")))
(define foot "</body></html>")

;; Read C# file
;; https://docs.racket-lang.org/teachpack/2htdpbatch-io.html
(require 2htdp/batch-io)
(read-words/line "read.cs")

(with-input-from-file "read.cs"
      (lambda ()
      (read-string 1000)))

;; Regex
(define namespace
      lambda(check)
      (cond
      []))


;; Output file creation
(with-output-to-file "index.html"
      (lambda () (printf (string-append head))))

(with-output-to-file "index.html"  #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf (string-append (style "System.Console.WriteLine('Hello World');")))))

(with-output-to-file "index.html" #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf (string-append foot))))
