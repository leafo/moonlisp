
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

