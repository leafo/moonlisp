
; true
(print
  (equal '(1 2 3) '(1 2 3)))

; true
(print
  (equal '(1 (2 3 4) 3) '(1 (2 3 4) 3)))

; false
(print
  (equal '(1 3) '(1 (2 3 4) 3)))

