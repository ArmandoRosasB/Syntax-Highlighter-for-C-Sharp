#lang racket

(define incremento
  (lambda (check)
    (cond
      (regexp-match #px"^[+][+][\\s]*([A-z]{1})[\\w]*$" check))))

(define match
  (lambda (fn lst)
    (cond
      [(empty? lst) '()]
      [else (cons (fn (car lst)) (match fn (cdr lst)))])))

(match incremento '("++i"))