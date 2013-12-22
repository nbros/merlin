(* {{{ COPYING *(

  This file is part of Merlin, an helper for ocaml editors

  Copyright (C) 2013  Frédéric Bour  <frederic.bour(_)lakaban.net>
                      Thomas Refis  <refis.thomas(_)gmail.com>
                      Simon Castellan  <simon.castellan(_)iuwt.fr>

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.

)* }}} *)

type step = {
  outlines : Outline.t;
  chunks   : Chunk.t;
  types    : Typer.t;
}

type t = {steps: step History.t; parser_validity: bool ref}

val initial_sig : string -> t
val initial_str : string -> t
val step : step -> Outline.t -> step
val browse : step -> Browse.t list

val verbosity : [`Query|`Incr|`Clear] -> int
val verbose_type : Env.t -> Types.type_expr -> Types.type_expr
val verbose_type_decl : Env.t -> Types.type_declaration -> Types.type_declaration
val verbose_sig : Env.t -> Types.modtype_declaration -> Types.modtype_declaration

val validate_parser : t -> t

module Verbose_print : sig
  open Format
  open Types

  val type_scheme: formatter -> type_expr -> unit
  val type_declaration: Ident.t -> formatter -> type_declaration -> unit
  val modtype_declaration: Ident.t -> formatter -> modtype_declaration -> unit
end

val retype : t -> t
val quick_refresh_modules : t -> t * bool

val node_at : t -> Lexing.position -> Browse.t
val node_complete : Browse.t -> string -> Protocol.completion list
val find_method : Env.t -> string -> Types.type_expr -> Types.type_expr option

val local_modules_at : t -> Lexing.position -> string Location.loc list

val str_items_before : t -> Lexing.position -> Typedtree.structure Asttypes.loc list

val exns : t -> exn list

val close_module : t -> [`Unneeded | `Successful of t | `Failed of t]
