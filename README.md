# MOONLISP

<http://leafo.net/moonlisp>

MoonLisp is a [Lisp][0] variant that compiles directly to [Lua][1] code.

It is written in [MoonScript][2] and depends on the MoonScript runtime to
generate Lua code.

In addition to Lisp syntax, and some Lisp concepts, MoonLisp provides a way to
write macros for Lua using S-Expressions.

  [0]: http://en.wikipedia.org/wiki/Lisp_(programming_language)
  [1]: http://www.lua.org
  [2]: http://moonscript.org

## Usage

Compiling:

	$ bin/lisp.moon lisp_code.cl > lua_code.lua

Compile and execute with the `-r` flag:

	$ bin/lisp.moon -r hello.cl

## Example

Here is an example of run length compression as described in __Ansi Common Lisp__ p.37

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
	(p (compress input))

And here is the (ugly) code generated:

	require("lisp.lib");
	(function()
	  compress = function(x)
		return (function()
		  if consp(x) then
			return compr(x[1], 1, x[2])
		  else
			return x
		  end
		end)()
	  end
	  return compress
	end)();
	(function()
	  n_elts = function(el, n)
		return (function()
		  if (n > 1) then
			return {
			  n,
			  {
				el,
				nil
			  }
			}
		  else
			return el
		  end
		end)()
	  end
	  return n_elts
	end)();
	(function()
	  compr = function(el, n, lst)
		return (function()
		  if null(lst) then
			return {
			  n_elts(el, n),
			  nil
			}
		  else
			return (function()
			  local next = lst[1]
			  return (function()
				if next == el then
				  return compr(el, (n + 1), lst[2])
				else
				  return {
					n_elts(el, n),
					compr(next, 1, lst[2])
				  }
				end
			  end)()
			end)()
		  end
		end)()
	  end
	  return compr
	end)();
	(function()
	  input = {
		1,
		{
		  1,
		  {
			1,
			{
			  0,
			  {
				1,
				{
				  0,
				  {
					0,
					{
					  0,
					  {
						0,
						{
						  1,
						  nil
						}
					  }
					}
				  }
				}
			  }
			}
		  }
		}
	  }
	  return input
	end)()
	p(compress(input))


## About

by [leafo](http://leafo.net) 2012

