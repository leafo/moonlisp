
module "lisp.macros", package.seeall

import p from require "moon"
import insert, concat from table

import atom, list, fncall_name from require"lisp.types"

class MacroScope
  new: =>
    @macros = {}
  
  has_macro: (name) =>
    @macros[name] != nil

  defmacro: (exp) =>
    parts = list exp
    m = {
      name: atom parts[2]
      arg_names: [atom a for a in *list parts[3]]
      body: [e for e in *parts[4,]]
    }
    print "found macro:", m.name
    @macros[m.name] = m

  expand: (exp) =>
    name = fncall_name exp
    if @has_macro name
      {"atom", "REPLACE ME"}
    else
      exp

  scan: (tree) =>
    return for exp in *tree
      if fncall_name(exp) == "defmacro"
        @defmacro exp
        nil
      else
        exp

export scan_macros = (tree) ->
 scope = MacroScope!
 scope\scan(tree), scope

