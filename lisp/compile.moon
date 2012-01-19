
module "lisp.compile", package.seeall

require "moonscript.transform"
require "moonscript.compile"

import insert, concat from table

import LocalName from moonscript.transform
import RootBlock from moonscript.compile

Set = (items) -> { name, true for name in *items}

import atom from require"lisp.types"

CALLABLE = Set{"parens", "chain"}
BUILTIN = { splice: "__splice" }

bigrams = (list) ->
  return {list} if #list == 1
  return for i = 1, #list - 1
    {list[i], list[i+1]}

to_func = (inner) ->
  {"chain", {"parens", {
    "fndef", {}, {}, "slim"
    inner
  }}, {"call", {}}}

assign = (name, value)->
  to_func {
    {"assign", {name}, {value}}
    name
  }

make_list = (exps) ->
  list = "nil"
  for i = #exps, 1, -1
    list = if exps[i][1] == "splice"
      {"chain", BUILTIN.splice, {"call", {exps[i][2], list}}}
    else
      {"table", {{exps[i]}, {list}}}
  list

macros = nil -- TODO fixme
compile = nil
quote = (exp) ->
  switch exp[1]
    when "atom"
      str = ("%q")\format(atom exp)\sub 2, -2
      compile {"string", '"', str}
    when "list"
      make_list [quote(val) for val in *exp[2]]
    when "quote"
      error "don't know how to quote a quote"
    when "unquote"
      compile exp[2]
    when "unquote_splice"
      {"splice", compile exp[2]}
    else
      exp

limit_args = (n, fn) ->
  (exp) ->
    if #exp > n + 1
      error "expecting ".. n .." arg(s) for `".. atom(exp[1]) .. "'"

    fn exp

chainable = (val) ->
  t = type val
  if t == "table" and not CALLABLE[val[1]] or t != "string"
    {"parens", val}
  else
    val

operator_form = (exp) ->
  op = atom(exp[1])
  out = {"exp"}
  for i = 2, #exp
    insert out, compile exp[i]
    insert out, op if i != #exp
  {"parens", out}

index_on = (n) ->
  (exp) ->
    val = chainable compile exp[2]
    {"chain", val, {"index", {"number", n}}}

get_n = (n) ->
  (exp) ->
    val = chainable compile exp[2]
    chain = {"chain", val}
    for i = 0, n - 1
      insert chain, {"index", {"number", 2}}
    insert chain, {"index", {"number", 1}}
    chain

-- system level macros
forms = {
  quote: (exp) ->
    error "too many parameters to quote" if #exp > 2
    quote exp[2]

  cons: (exp) ->
    {"table", [{compile(val)} for val in *exp[2,]]}

  car: index_on 1
  cdr: index_on 2

  list: (exp) ->
    make_list [compile val for val in *exp[2,]]

  setf: (exp) ->
    _, name, value = unpack exp
    assign atom(name), compile value


  let: (exp) ->
    assigns = exp[2][2]

    scope = for asn in *assigns
      name, value = unpack asn[2]
      {"assign", {LocalName atom name}, {compile value}}

    for e in *exp[3,]
      insert scope, compile e

    to_func scope

  defun: (exp) ->
    _, name, args, body = unpack exp
    body = [compile(e) for e in *exp[4,]]

    assign atom(name), {
      "fndef", [{atom name} for name in *args[2]]
      {}, "slim", body
    }

  -- make this generic for all other binary operators with more than two args
  eq: (exp) ->
    eqs = bigrams [compile e for e in *exp[2,]]

    out = {"exp"}
    if #eqs > 1
      for i = 1, #eqs
        p = eqs[i]
        insert out, {"exp", p[1], "==", p[2]}
        insert out, "and" if i != #eqs
      out
    else
      exp = eqs[1] -- compiled
      {"exp", exp[1], "==", exp[2]}

  not: (exp) ->
    {"not", compile exp[2]}

  ["+"]: operator_form
  ["-"]: operator_form
  ["*"]: operator_form
  ["/"]: operator_form

  ["<"]: limit_args 2, operator_form
  ["<="]: limit_args 2, operator_form
  [">"]: limit_args 2, operator_form
  [">="]: limit_args 2, operator_form

  first: get_n 0
  second: get_n 1
  third: get_n 2
  fourth: get_n 3
  fifth: get_n 4
  sixth: get_n 5

  and: operator_form
  or: operator_form

  if: (exp) ->
    _, cond, pass, fail = unpack exp

    to_func {
      {
        "if"
        compile cond
        { compile pass }
        {"else", { compile fail }}
      }
    }
}

forms.eql = forms.eq
forms.rest = forms.cdr

compile = (exp) ->
  exp = macros\expand exp
  switch exp[1]
    when "quote" -- the ' operator
      quote exp[2]
    when "atom"
      exp[2]
    when "unquote"
      error "comma must be inside quote"
    when "unquote_splice"
      error "comma must be inside quote"
    when "list"
      lst = exp[2]
      return "nil" if #lst == 0
      operator = atom lst[1]

      if forms[operator]
        forms[operator] lst
      else
        {
          "chain"
          operator
          {"call", [compile(val) for val in *lst[2,]]}
        }
    else
      exp

export compile_all = (tree) ->
  stms = for exp in *tree
    compile exp

  root = RootBlock!
  root.has_name = -> true

  code, err = moonscript.compile.tree stms, root
  error err if not code
  code

boot = [[
require("moonscript")
require("lisp.lib");
]]

import parse from require"lisp.parse"
import scan_macros from require"lisp.macros"

export parse_and_compile = (lisp_code) ->
  tree = parse lisp_code
  assert tree, "Parse failed"

  tree, macros = scan_macros tree

  code = compile_all tree
  concat { boot, code }

