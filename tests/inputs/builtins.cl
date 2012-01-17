
; true
(print
  (equal '(1 2 3) '(1 2 3)))

; true
(print
  (equal '(1 (2 3 4) 3) '(1 (2 3 4) 3)))

; false
(print
  (equal '(1 3) '(1 (2 3 4) 3)))

(first x)
(second x)
(third x)
(fourth x)
(fifth x)
(sixth x)

(fifth '(1 2 3 4 5 6))

(print (nth 2 '(1 2 3 4 5)))

;; should run these ones day...
(p (reverse nil))

(p (reverse '(1 2 3 4 5)))

(p (append '(hello world) '(1 2 3 4)))

(p (append nil nil))

(p (append nil '(1 2 3)))
(p (append '(1 2 3) nil))

(p 1 2 3)

