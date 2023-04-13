#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>C# code editor</title></head><body style='background:#2C2B34; color:white;'><p>")
(define foot "</p></body></html>")

;; Read C# file
;; https://docs.racket-lang.org/teachpack/2htdpbatch-io.html
(require 2htdp/batch-io)
(define text (read-file "read.cs"))

;; Regex for basic HTML format
(define text1 (regexp-replace* #rx"\n" text " <br> "))
(define text2 (regexp-replace* #rx"\\s{4}" text1 " &nbsp; ")) ;; ------------ NO FUNCIONA ------------

;; Ciclos regex
(define parseContent
  (lambda (lst color txt)
         (cond
           [(empty? lst) txt]
           [(string-replace (parseContent (cdr lst) color txt) (car lst) (string-append "<span style='color:" color "'>" (car lst) "</span>"))])))

;; Regex listas
;; Comillas dobles, comillas simples
(define strings (regexp-match* #rx"((\")([^(\")])*(\"))|((\')([^(\")])*(\'))" text2))
(define text3 (parseContent strings "yellow" text2))

;; using, namespace
(define use-namespc (regexp-match* #rx"([\\s]*using[\\s]*)|([\\s]*namespace[\\s]*)" text3)) 
(define text4 (parseContent use-namespc "red" text3))

;; if, else, switch, case, default
;; FALTAN: switch, case, default
(define condicionales (regexp-match* #rx"([\\s]*if[\\s]*)|([\\s]*else[\\s]*)" text4)) 
(define text5 (parseContent condicionales "blue" text4))

;; Output file creation
(with-output-to-file "index.html"
      (lambda () (printf head)))

(with-output-to-file "index.html"  #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
(lambda () (printf text4)))
      
(with-output-to-file "index.html" #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf foot)))
