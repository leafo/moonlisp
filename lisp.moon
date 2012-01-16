#!/usr/bin/env moon

import parse_and_compile from require "lisp.parse"

-- (setf hello '(balls land))
-- (print "hello")
-- (* (+ 1 2) 4 4 2)

-- (setf x "hello")
-- (defun hello (x y)
--   (+ 2 3 4)
--   (print 'hi))
-- (cons 1 (cons 3 (cons nil)))

-- ; (print (car (cdr '(1 4 2))))
-- ; (car hello)
-- ; (eq 3 4 5)
--
-- ; (car '(1 2 3))
-- ; (defun hello (x h) 34)

require "alt_getopt"

opts, ind = alt_getopt.get_opts arg, "r", { }

lisp_code = if arg[ind]
  f = io.open(arg[ind])
  error "failed to open file: " .. arg[ind] if not f
  with f\read"*a"
    f\close!
else
  io.stdin\read "*a"

lua_code = parse_and_compile lisp_code
if opts.r
  loadstring(lua_code)!
else
  print lua_code

