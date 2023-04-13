#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><pre>")
(define foot "</pre></body></html>")
(define styles "body {background:#2C2B34;color:white;} .strings{color: yellow;} .use-namespc{color: red;} .condicionales {color: blue;} .comentarios {color: gray;} .operadores-simples {color: red;} .logico-booleano{color: purple;}")

;; Read C# file
;; https://docs.racket-lang.org/teachpack/2htdpbatch-io.html
(require 2htdp/batch-io)
(require racket/set)
(define text (read-file "read.cs"))

;; Regex for basic HTML format
(define text1 (regexp-replace* #rx"\n" text " <br> "))

;; Ciclos regex
(define parseContent
  (lambda (lst className txt)
         (cond
           [(empty? lst) txt]
           [(string-replace (parseContent (cdr lst) className txt) (car lst) (string-append "<span class='" className "'>" (car lst) "</span>"))])))

;; Regex 

;; Comillas dobles y simples
(define strings (regexp-match* #rx"((\")([^(\")])*(\"))|((\')([^(\")]){1}(\'))" text1))
(define text2 (parseContent strings "strings" text1))

;; Using - namespace
(define use-namespc (regexp-match* #rx"using|namespace" text2))  
(define text3 (parseContent use-namespc "use-namespc" text2))

;; Condicionales
(define condicionales (regexp-match* #rx"if|else|switch|case|default" text3)) 
(define text4 (parseContent condicionales "condicionales" text3))

;; Comentarios multilínea y unilínea
(define comentarios (regexp-match* #rx"[/][*].*[*][/]|[/][/][^<br>]*" text4)) 
(define text5 (parseContent comentarios "comentarios" text4))

;; Operadores aritméticos, de comparación e igualdad
(define aritmeticos-comparacion-igualdad (regexp-match* #rx"[+]|[-]|[*]|[/]|[<]|[>]|[%]|[=]" text5))
(define text6 (parseContent aritmeticos-comparacion-igualdad "operadores-simples" text5))

;; Lógicos booleanos
;;(define logico-booleano (regexp-match* #rx"[!]|[&]|[^]|[|]|[~]" text6)) ;;
;;(define text7 (parseContent logico-booleano "logico-booleano" text6))

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
