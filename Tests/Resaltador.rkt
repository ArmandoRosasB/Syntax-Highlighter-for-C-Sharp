#lang racket

;; HTML components
(define head "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><pre>")
(define foot "</pre></body></html>")

;; CSS component
(define styles "body{background:#333333;color:#FDFFFC; margin-left: 20px;} .cadena{color:rgb(247, 243, 61);} .cadena span{color:rgb(247, 243, 61);} .use_namespc{color:#E82164;} .condicionales{color:#E82164;} .comentarios{color:rgb(190, 190, 190);} .comentarios span{color:rgb(190, 190, 190);}  .operador{color:#F15156;} .tipos{color:#3edff5;font-style:italic;} .tipos span{color:#00BCD4;font-style:italic;} .ciclos{color:#E82164;} .parentheses{color:#CDDC39;} .jump{color:magenta;} .flag{color:#4A8FE7;} .nulo {color:rgb(140, 84, 192);;font-style:italic;} .definition{color:#FF9F1C;} .oop{color:#E82164;} .bloques{color:#9C27B0;} .type_tam{color:#CDDC39;} .isas{color:#F71735;} .in_out{color:#F71735;}")

;; Read C# file
;; https://docs.racket-lang.org/teachpack/2htdpbatch-io.html
(require 2htdp/batch-io)
(define text (read-file "read.cs"))

;; Regex for basic HTML format
(define text1 (regexp-replace* #rx"\n" text " <br> "))

(define parseContent
  (lambda (lst regex className txt)
         (cond
           [(not (list? lst)) txt]
           [(regexp-replace* regex txt (string-append "<span class='" className "'>" (car lst) "</span>"))])))

(define parseContent-recursive
  (lambda (lst className txt)
         (cond
           [(empty? lst) txt]
           [(string-replace (parseContent-recursive (cdr lst) className txt) (car lst) (string-append "<span class='" className "'>" (car lst) "</span>"))])))

(define match
  (lambda (lst txt className)
    (cond
      [(empty? lst) txt]
      [(parseContent (regexp-match (car lst) txt) (car lst) className (match (cdr lst) txt className))])))

;; Regex 


;; Comillas dobles y simples
(define strings (regexp-match* #rx"((\")([^(\")])*(\"))|((\')([^\"])?(\'))" text1))
(define text2 (parseContent-recursive strings "cadena" text1))

;; Using - namespace
(define use_namespc '(#px"\\busing\\b" "using" #px"\\bnamespace\\b"))
(define text3 (match use_namespc text2 "use_namespc"))

;; Condicionales
(define ciclos '(#px"\\bdo\\b" #px"\\bwhile\\b" #px"\\bfor\\b" #px"\\bforeach\\b"))
(define text4 (match ciclos text3 "ciclos"))

;; Comentarios multilínea y unilínea
(define comentarios (regexp-match* #rx"([/][*].*[*][/])|([/][/][^(<b)]*)" text4)) 
(define text5 (parseContent-recursive comentarios "comentarios" text4))

;; Ciclos
(define condicionales '(#px"\\bif\\b" #px"\\belse\\b" #px"\\bswitch\\b" #px"\\bcase\\b" #px"\\bdefault\\b"))
(define text7 (match condicionales text5 "condicionales"))
  
;; Operadores
(define operadores '(#px"\\*{1}" #px"/{1}(?!span)" #px"\\+" #px"\\-" #px"\\%" #px"&{1}" #px"\\|{1}" #px"\\^{1}" #px"<{1}(?!(span|/span|br))" #px"(?<!span)(?<!')(?<!br)>{1}" #px"(?<!class)={1}" #px"!" #px"\\b\\~\\b"))
(define text8 (match operadores text7 "operador")) 


;; Tipos de datos
(define tipos '(#px"\\bint\\b" #px"\\buint\\b" #px"\\bfloat\\b" #px"\\bdouble\\b" #px"\\blong\\b" #px"\\bulong\\b" #px"\\bdecimal\\b" #px"\\bstring\\b" #px"\\bchar\\b" #px"\\bbool\\b" #px"\\bshort\\b" #px"\\bushort\\b" #px"\\bbyte\\b" #px"\\bsbyte\\b" #px"\\bparams\\b" #px"\\bref\\b" #px"\\binternal\\b" #px"\\bstackalloc\\b" #px"\\bfixed\\b" #px"\\bvar\\b")) 
(define text9 (match tipos text7 "tipos"))

;; Paréntesis
(define parentesis '(#rx"[(]" #rx"[)]" #rx"[[]" #rx"[]]" #rx"[{]" #rx"[}]")) 
(define text10 (match parentesis text9 "parentheses"))

;; Jump
(define jump '(#px"\\breturn(;)?\\b" #px"\\bcontinue(;)?\\b" #px"\\bbreak(;)?\\b" #px"\\bgoto\\b")) 
(define text11 (match jump text10 "jump"))

;; Flag
(define flag '(#px"\\btrue\\b" #px"\\bfalse\\b")) 
(define text12 (match flag text11 "flag"))

;; Nulo
(define nulo '(#px"\\bnull\\b")) 
(define text13 (match nulo text12 "nulo"))

;; Clases, métodos y más
(define classes '(#px"\\bpublic\\b" #px"\\bstatic\\b" #px"\\bprivate\\b" #px"\\bvirtual\\b" #px"\\babstract\\b" #px"\\bprotected\\b" #px"\\bclass\\b[^=]" #px"\\bthis\\b" #px"\\bevent\\b" #px"\\bbase\\b" #px"\\bexplicit\\b" #px"\\bimplicit\\b" #px"\\boperator\\b" #px"\\bextern\\b" #px"\\bobject\\b" #px"\\boverride\\b" #px"\\breadonly\\b" #px"\\bunsafe\\b" #px"\\bdelegate\\b" #px"\\bsealed\\b" #px"\\bvoid\\b"))
(define text14 (match classes text13 "oop"))

;; Estructuras
(define estructuras '(#px"\\bconst\\b" #px"\\bstruct\\b" #px"\\benum" #px"\\bnew\\b" #px"\\binterface\\b"))
(define text15 (match estructuras text14 "definition"))

;; Bloques
(define bloques '(#px"\\btry\\b" #px"\\bcatch\\b" #px"\\bthrow\\b" #px"\\bfinally\\b" #px"\\bchecked\\b" #px"\\bunchecked\\b" #px"\\block\\b"))
(define text16 (match bloques text15 "bloques"))

;; Tipo y tamaño
(define type_tam '(#px"\\bsizeof\\b" #px"\\btypeof\\b"))
(define text17 (match type_tam text16 "type_tam"))

;; Entrada y salida
(define in_out '(#px"\\bout\\b" #px"\\bin\\b"))
(define text18 (match in_out text17 "in_out"))

;; is as
(define is_as '(#px"\\bis\\b" #px"\\bas\\b"))
(define text19 (match is_as text18 "isas"))

;; Methods
(define methods '(#px"(?<=\\.)([^\\(|;]*)(\\()"))
(define text20 (match methods text19 "parentheses"))

;; Output CSS creation
(with-output-to-file "styles.css"
      (lambda () (printf styles)))

;; Output HTML creation
(with-output-to-file "index.html"
      (lambda () (printf head)))

(with-output-to-file "index.html"  #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
(lambda () (printf text19)))
      
(with-output-to-file "index.html" #:mode 'binary  #:exists 'append #:permissions #o666 #:replace-permissions? #f
      (lambda () (printf foot)))
