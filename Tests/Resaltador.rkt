#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><pre>")
(define foot "</pre></body></html>")

;; CSS component
(define styles "body{background:#2C2B34;color:white;} .cadena{color:#F7D08A;} .cadena span{color:#F7D08A;} .use_namespc{color:red;} .condicionales{color:#A5FFD6;} .comentarios{color:gray;} .comentarios span{color:gray;}  .operador{color:red;} .tipos{color:#03CEA4;font-style:italic;} .tipos span{color:#03CEA4;font-style:italic;} .ciclos{color:green;} .parentheses{color:lime} .jump{color:rebeccapurple} .flag{color:magenta;} .nulo {color:rebeccapurple;font-style:italic;} .definition{color:#EE2E31;} .oop{color:red;} .bloques{color:orange;} .type_tam{color:#f4c095;} .int_out{color:red;} .isas{color:red;}")

;; Read C# file
;; https://docs.racket-lang.org/teachpack/2htdpbatch-io.html
(require 2htdp/batch-io)
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

(define match
  (lambda (lst txt className)
    (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) className (match (cdr lst) txt className))])))

;; Regex 

;; Comillas dobles y simples
(define strings (regexp-match* #rx"((\")([^(\")])*(\"))|((\')([^\"])?(\'))" text1))
(define text2 (parseContent-recursive strings "cadena" text1))

;; Using - namespace
(define use_namespc '(#rx"using" #rx"namespace"))
(define text3 (match use_namespc text2 "use_namespc"))

;; Condicionales
(define ciclos '(#rx"do" #rx"while" #rx"for" #rx"foreach"))
(define text4 (match ciclos text3 "ciclos"))

;; Comentarios multilínea y unilínea
(define comentarios (regexp-match* #rx"([/][*][^*/]*[*][/])|([/][/][^(<b)]*)" text4)) 
(define text5 (parseContent-recursive comentarios "comentarios" text4))

;; Ciclos
(define condicionales '(#rx"if" #rx"else" #rx"switch" #rx"default"))
(define text6 (match condicionales text5 "condicionales"))
  
;; Operadores
(define operadores '(#rx"[+]+" #rx"[-]+" #rx"[%]+" #rx"[&]+" #rx"[|]+" #rx"[\\^]"))
(define text7 (match operadores text6 "operador"))

;; Tipos de datos
(define tipos '(#rx"int" #rx"uint" #rx"float" #rx"double" #rx"long" #rx"ulong" #rx"decimal" #rx"string" #rx"char" #rx"bool" #rx"short"  #rx"ushort"  #rx"byte"  #rx"sbyte" #rx"params" #rx"ref" #rx"internal"  #rx"stackalloc"  #rx"fixed" #rx"var")) 
(define text8 (match tipos text7 "tipos"))

;; Paréntesis
(define parentesis '(#rx"[(]" #rx"[)]" #rx"[[]" #rx"[]]" #rx"[{]" #rx"[}]")) 
(define text9 (match parentesis text8 "parentheses"))

;; Jump
(define jump '(#rx"return" #rx"continue" #rx"break" #rx"goto")) 
(define text10 (match jump text9 "jump"))

;; Flag
(define flag '(#rx"true" #rx"false")) 
(define text11 (match flag text10 "flag"))

;; Nulo
(define nulo '(#rx"null")) 
(define text12 (match nulo text11 "nulo"))

;; Clases, métodos y más
(define classes '(#rx"public" #rx"static" #rx"private" #rx"virtual" #rx"abstract" #rx"protected" #rx"this" #rx"event" #rx"base" #rx"explicit" #rx"implicit" #rx"operator" #rx"extern" #rx"object" #rx"override" #rx"readonly" #rx"unsafe" #rx"delegate" #rx"sealed" #rx"void"))
(define text13 (match classes text12 "oop"))
;; Estructuras
(define estructuras '(#rx" const" #rx"struct" #rx"enum" #rx"new" #rx"interface"))
(define text14 (match estructuras text13 "definition"))

;; Bloques
(define bloques '(#rx"try" #rx"catch" #rx"throw" #rx"finally" #rx"checked" #rx"unchecked" #rx"lock"))
(define text15 (match bloques text14 "bloques"))

;; Tipo y tamaño
(define type_tam '(#rx"sizeof" #rx"typeof"))
(define text16 (match type_tam text15 "type_tam"))

;; Entrada y salida
;;(define in_out '(#rx"out"))
;;(define text17 (match in_out text16 "in_out"))

;; is as
;;(define is_as '(#rx"is"))
;;(define text17 (match is_as text16 "isas"))

;; Output CSS creation
(with-output-to-file "styles.css"
      (lambda () (printf styles)))

;; Output HTML creation
(with-output-to-file "index.html"
      (lambda () (printf head)))

(with-output-to-file "index.html"  #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
(lambda () (printf text16)))
      
(with-output-to-file "index.html" #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf foot)))
