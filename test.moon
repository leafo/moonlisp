#!/usr/bin/env moon

require "lfs"
require "alt_getopt"

INPUT_DIR = "tests/inputs"
OUTPUT_DIR = "tests/outputs"

Set = (lst) -> {key, true for key in *lst}

available_actions = Set{"build", "run"}

opts, ind = alt_getopt.get_opts arg, "d:", { }
action = arg[ind] or "run"

error "Unknown action" .. action if not available_actions[action]

join = (left, right) ->
  left = left\match"^(.*)/$" or left
  right = right\match"^/(.*)$" or right
  table.concat { left, right }, "/"

log = (...) -> print " ** ", ...

compile = (code) ->
  import parse_and_compile from require "lisp.compile"
  parse_and_compile code

diff = (a, b, diff_tool) ->
  diff_tool = diff_tool or opts.d or "diff"

  get_fname = (x) ->
    if x.fname
      x.fname
    else
      name = os.tmpname!
      with io.open name, "w"
        \write x
        \close!
      name

  a = get_fname a
  b = get_fname b

  proc = io.popen table.concat({ diff_tool, a, b }, " "), "r"
  with proc\read"*a"
    proc\close!

for fname in lfs.dir INPUT_DIR
  if not fname\match"^%."
    in_path = join INPUT_DIR, fname
    out_path = join OUTPUT_DIR, fname

    source = io.open(in_path)\read"*a"
    lua_code = compile source

    if action == "build"
      with io.open(out_path, "w")
        \write lua_code
        \close!
      log "wrote " .. out_path
    elseif action == "run"
      out_f = io.open out_path
      if out_f
        target = out_f\read"*a"
        if lua_code != target
          print "FAIL\t".. in_path
          print diff { fname: out_path }, lua_code
        else
          print "PASS\t".. in_path
      else
        log "skipping unbuilt test ["..in_path.."]"

