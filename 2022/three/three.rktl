#lang racket
(require racket/string)

(define (priority c)
  (if (char=? c (char-upcase c))
    (- (char->integer c) 38)
    (- (char->integer c) 96)))

;; A
(apply + (map (lambda (line) 
  (priority (string-ref (second (filter 
    (lambda (x)
      (string-contains? (substring line (/ (string-length line) 2)) x)) 
      (string-split (substring line 0 (/ (string-length line) 2)) ""))) 0)))
  (file->lines "three.txt")))

;; B
(define lines (file->lines "three.txt"))
(define prios 0)
(for ([i (in-range 1 (+ (/ (length lines) 3) 1))])
  (define tr (drop (take lines (* i 3)) (* (- i 1) 3)))
  (define p (filter
    (lambda (y) (member y (filter 
      (lambda (x) (string-contains? (first tr) (string x))) (string->list (second tr))))) 
      (string->list (third tr))))
  (set! prios (+ prios (priority (first p)))))
(displayln prios)
