#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><p>")
(define foot "</p></body></html>")
(define styles "body {background:#2C2B34;color:white;} .strings{color: yellow;} .use-namespc{color: red;} .condicionales {color: blue;} .comentarios {color: gray;}")

;; Read C# file
;; https://docs.racket-lang.org/teachpack/2htdpbatch-io.html
(require 2htdp/batch-io)
(define text (read-file "read.cs"))

;; Regex for basic HTML format
(define text1 (regexp-replace* #rx"\n" text " <br> "))
(define text2 (regexp-replace* #rx"[\\s]{4}" text1 " &nbsp; ")) ;; ------------ NO FUNCIONA ------------

;; Ciclos regex
(define parseContent
  (lambda (lst className txt)
         (cond
           [(empty? lst) txt]
           [(string-replace (parseContent (cdr lst) className txt) (car lst) (string-append "<span class='" className "'>" (car lst) "</span>"))])))

;; Regex listas
;; Comillas dobles, comillas simples
(define strings (regexp-match* #rx"((\")([^(\")])*(\"))|((\')([^(\")]){1}(\'))" text2))
(define text3 (parseContent strings "strings" text2))

;; using, namespace
(define use-namespc (regexp-match* #rx"using|namespace" text3))  
(define text4 (parseContent use-namespc "use-namespc" text3))

;; if, else, switch, case, default
;; FALTAN: switch, case, default
(define condicionales (regexp-match* #rx"if|else" text4)) 
(define text5 (parseContent condicionales "condicionales" text4))

;; comentarios
(define comentarios (regexp-match* #rx"[/*].*[*/]" text5)) 
(define text6 (parseContent comentarios "comentarios" text5))

;; Output CSS creation
(with-output-to-file "styles.css"
      (lambda () (printf styles)))

;; Output HTML creation
(with-output-to-file "index.html"
      (lambda () (printf head)))

(with-output-to-file "index.html"  #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
(lambda () (printf text6)))
      
(with-output-to-file "index.html" #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf foot)))
