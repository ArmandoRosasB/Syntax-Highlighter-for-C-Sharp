#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><pre>")
(define foot "</pre></body></html>")
(define styles "body {background:#2C2B34;color:white;} .cadena{color: yellow;} .cadena span{color: yellow;} .use_namespc{color: red;} .condicionales {color: blue;} .comentarios {color: gray;} .comentarios span {color: gray;}  .operadores{color: red;} .tipos{color: blue;} .ciclos{color: green;} .parentesis{color: lime} .jump{color: rebeccapurple} .flag{color: magenta;}")

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
           [(not (list? lst)) txt]
           [(string-replace txt (car lst) (string-append "<span class='" className "'>" (car lst) "</span>"))])))

(define parseContent-recursive
  (lambda (lst className txt)
         (cond
           [(empty? lst) txt]
           [(string-replace (parseContent-recursive (cdr lst) className txt) (car lst) (string-append "<span class='" className "'>" (car lst) "</span>"))])))

;; Regex 

;; Comillas dobles y simples
(define strings (regexp-match* #rx"((\")([^(\")])*(\"))|((\')([^(\")]){1}(\'))" text1))
(define text2 (parseContent-recursive strings "cadena" text1))

;; Using - namespace
;; (define use-namespc (regexp-match* #rx"using|namespace" text2))  
;; (define text3 (parseContent-recursive use-namespc "use_namespc" text2))
(define use_namespc '(#rx"using" #rx"namespace"))
(define use_namespc-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "use_namespc" (use_namespc-match (cdr lst) txt))])))
(define text3 (use_namespc-match use_namespc text2))

;; Condicionales
;; (define condicionales (regexp-match* #rx"if|else|switch|case|default" text3)) 
;; (define text4 (parseContent-recursive condicionales "condicionales" text3))
(define condicionales '(#rx"do" #rx"while" #rx"for" #rx"foreach"))
(define condicionales-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "condicionales" (condicionales-match (cdr lst) txt))])))
(define text4 (condicionales-match condicionales text3))

;; Comentarios multilínea y unilínea
(define comentarios (regexp-match* #rx"([/][*].*[*][/])|([/][/][^(<b)]*)" text4)) 
(define text5 (parseContent-recursive comentarios "comentarios" text4))

;; Ciclos
(define ciclos '(#rx"do" #rx"while" #rx"for" #rx"foreach"))
(define ciclos-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "ciclos" (ciclos-match (cdr lst) txt))])))
(define text6 (ciclos-match ciclos text5))
  
;; Operadores
(define operadores '(#rx"[+]+" #rx"[-]+" #rx"[%]"))
(define operadores-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "operadores" (operadores-match (cdr lst) txt))])))
      ;;[(regexp-match (car lst) (operadores-match (cdr lst) txt))])))
(define text7 (operadores-match operadores text6))

;; Tipos
(define tipos '(#rx"int" #rx"uint" #rx"float" #rx"double" #rx"long" #rx"ulong" #rx"decimal" #rx"string" #rx"char" #rx"bool" #rx"short"  #rx"ushort"  #rx"byte"  #rx"sbyte" #rx"params" #rx"ref" #rx"internal"  #rx"stackalloc"  #rx"fixed")) 
(define tipos-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "tipos" (tipos-match (cdr lst) txt))])))
(define text8 (tipos-match tipos text7))

;; Parentesis
(define parentesis '(#rx"[(]" #rx"[)]" #rx"[[]" #rx"[]]" #rx"[{]" #rx"[}]")) 
(define parentesis-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "parentesis" (parentesis-match (cdr lst) txt))])))
(define text9 (parentesis-match parentesis text8))

;; jump
(define jump '(#rx"return" #rx"continue" #rx"break" #rx"goto")) 
(define jump-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "jump" (jump-match (cdr lst) txt))])))
(define text10 (jump-match jump text9))

;; flag
(define flag '(#rx"true" #rx"false")) 
(define flag-match
      (lambda (lst txt)
      (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) "flag" (flag-match (cdr lst) txt))])))
(define text11 (flag-match flag text10))

;; Output CSS creation
(with-output-to-file "styles.css"
      (lambda () (printf styles)))

;; Output HTML creation
(with-output-to-file "index.html"
      (lambda () (printf head)))

(with-output-to-file "index.html"  #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
(lambda () (printf text11)))
      
(with-output-to-file "index.html" #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf foot)))
