
;
(defmacro add_one (x)
  `(+ 1 ,x))

(print (add_one 3))

;
(defmacro print_var (var)
  `(print ,var))

(print_var hello)

(defmacro print_string (str)
  `(print ,str))

(print_string "hello world")

