
(defun has_list (lst)
  (and (not (null lst))
	   (or (listp (car lst))
		   (has_list (cdr lst)))))

(print (has_list '(1 2 3 4)))
(print (has_list '(1 () 3 4)))

