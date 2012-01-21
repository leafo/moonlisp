
module "lisp.macros", package.seeall

import p from require "moon"
import insert, concat from table

import atom, list, fncall_name, flatten_list from require"lisp.types"

make_list = (items) -> {"list", items}
make_atom = (name) -> {"atom", name}
make_number = (num) -> {"number", num}
make_quote = (e) -> {"quote", e}

-- macros are broken
-- need to be able to differentiate symbols and strings
-- when reconstructing ast nodes

compile = nil

to_ast = (val) ->
  switch type val
    when "table"
      lst = flatten_list val
      make_list [to_ast v for v in *lst]
    when "number"
      make_number val
    else
      make_atom tostring val

class MacroScope
  new: =>
    compile = require "lisp.compile" if not compile
    @macros = {}
    @compiled_macros = {}
  
  has_macro: (name) =>
    @macros[name] != nil

  compiled_macro: (name) =>
    fn = @compiled_macros[name]

    if not fn
      code = compile.compile_all { @macros[name] }
      fn = loadstring(code)!
      @compiled_macros[name] = fn

    fn

  defmacro: (exp) =>
    parts = list exp
    name = atom parts[2]

    -- convert the macro to a returned lambda
    fn = make_list{
      make_atom"lambda"
      unpack [e for e in *parts[3,]]
    }

    fn = make_list{make_atom"return", fn}

    @macros[name] = fn

  expand: (exp) =>
    name = fncall_name exp
    if @has_macro name
      fn = @compiled_macro name

      args = make_list{
        make_atom"return"
        unpack [make_quote e for e in *list(exp)[2,]]
      }

      arg_code = compile.compile_all{args}
      expanded = fn loadstring(arg_code)!
      to_ast expanded
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

