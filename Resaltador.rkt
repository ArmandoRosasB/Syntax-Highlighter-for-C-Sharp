;; Referencia
;; Pg. 55 http://memoriascimted.com/wp-content/uploads/2021/04/Programación-de-datos-con-Racket.pdf

;; Open-input-file - Abre un archivo para lectura
;; (open-input-file <ruta> [#:mode {‘binary | ‘text}])

;; Open-output-file - Abre un archivo para escritura
;; (open-output-file <ruta> [{#:mode {‘binary | ‘text}}]? [{#:exists {‘error|’append|’update|’canupdate|’replace|’truncate|’musttruncate}}]?)

;;(define out (open-output-file "some-file")
;;(display "hello world" out)
;;(close-output-port out)

 (require html-writing)

 (write-html
 '((html (head (title "My Title"))
         (body (@ (bgcolor "white"))
               (h1 "My Heading")
               (p "This is a paragraph.")
               (p "This is another paragraph."))))
 (current-output-port))