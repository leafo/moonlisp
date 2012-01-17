
(p `(hello 2 (print "hello") 4))

(p `(hello 2 ,(print "hello") 4))

(p `(hello 2 ,@(list "hello" "world") 4))

