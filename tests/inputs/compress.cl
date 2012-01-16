
; Ansi Common Lisp p.37
; run length compression

(defun compress (x)
  (if (consp x)
	(compr (car x) 1 (cdr x))
	x))

(defun n_elts (el n)
  (if (> n 1)
	(list n el)
	el))

(defun compr (el n lst)
  (if (null lst)
	(list (n_elts el n))
	(let ((next (car lst)))
	  (if (eql next el)
		(compr el (+ n 1) (cdr lst))
		(cons (n_elts el n)
			  (compr next 1 (cdr lst)))))))

(setf input '(1 1 1 0 1 0 0 0 0 1))

(print "input")
(p input)

(print "compress")
(p (compress input))

(defun uncompress (lst)
  (if (null lst)
	nil
	(let ((next (car lst)))
	  (if (consp next)
		(flatten (car next) (car (cdr next)) (cdr lst))
		(cons next (uncompress (cdr lst)))))))

(defun flatten (n val remaining)
  (if (zerop n)
	(uncompress remaining)
	(cons val (flatten (- n 1) val remaining))))

(print "uncompress")
(p (uncompress (compress input)))
