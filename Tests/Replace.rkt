#lang racket

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

;; Tests
(define text "<span class='spam'>o</span>");;"as <span class='holas'>as</span> as has aas <br> as =as= 'as' \"as\" as+ -as as* {i as f} (i as f) [i as f] as?>")

;;(define text1 (parseContent '("as") "as1" text))
;;text1

;;(define text2 (match '(#rx"as") text "as2"))
;;text2

;;(define positions(regexp-match-positions* #px"as\\b" "as <span class='holas'>as</span> as has aas <br> as"))
;;positions

;;(define text3 (regexp-replace* #px"[^<>='*\"+-]\\bas\\b" text " <span class='as3'>as</span> "))
;;text3

(define text4 (regexp-replace* #px"\\.[A-Za-z]+" "a.hola a. s d.To a.4 s." "coloreado"))
text4

(regexp-match* #px"(<[^(/span|span)]){1}" "a <<b  <span class='s'>s</span>")

;;(define text5 (regexp-replace* #px"\\b>\\b" text (string-append "<span class='---'>" (car (regexp-match #px"\\b>\\b" text)) "</span> ")))
;;text5

;;(regexp-split #rx":" "/bin:/usr/bin:/usr/bin/X11:/usr/local/bin")