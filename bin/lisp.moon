#!/usr/bin/env moon

import parse_and_compile from require "lisp.parse"

--
--
--
--

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

