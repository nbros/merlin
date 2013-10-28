open Std

type position = Lexing.position

type completion = {
  name: string;
  kind: [`Value|`Constructor|`Label|
         `Module|`Modtype|`Type|`MethodCall];
  desc: string;
  info: string;
}

type teller = unit -> [`Source of string | `More of string |`End]

type ('s,_) request =
  | Tell
    :  [`Definitions of int | `Source of string]
    -> ('s, (teller -> 's -> 's * position)) request
  (*| Tell_module
    : ('s, [`Done | `From of position * (unit -> teller)]) request*)
  | Type_expr
    :  string * position option
    -> ('s, string) request
  | Type_enclosing
    :  (string * int) * position
    -> ('s, (Location.t * string) list) request
  | Complete_prefix
    :  string * position option
    -> ('s, completion list) request
  | Locate
    :  string * position option
    -> ('s, (string option * position) option) request
  | Drop
    :  ('s, position) request
  | Seek
    :  [`Position|`End|`Maximize_scope|`Before of position|`Exact of position]
    -> ('s, position) request
  | Boundary
    :  [`Prev|`Next|`Current] * position option
    -> ('s, Location.t option) request
  | Reset
    :  string option
    -> ('s, unit) request
  | Refresh
    :  [`Full|`Quick]
    -> ('s, bool) request
  | Errors
    :  ('s, exn list) request
  | Dump
    :  [`Env of [`Normal|`Full] * position option|`Sig|`Chunks|`Tree|`Outline|`Exn|`History]
    -> ('s, Json.json) request
  | Which_path
    :  string
    -> ('s, string) request
  | Which_with_ext
    :  string
    -> ('s, string list) request
  | Findlib_use
    :  string list
    -> ('s, [`Ok | `Failures of (string * exn) list]) request
  | Findlib_list
    :  ('s, string list) request
  | Extension_list
    :  [`All|`Enabled|`Disabled]
    -> ('s, string list) request
  | Extension_set
    :  [`Enabled|`Disabled] * string list
    -> ('s, unit) request
  | Path
    :  [`Build|`Source]
     * [`Add|`Rem]
     * string list
    -> ('s, bool) request
  | Path_list
    :  [`Build|`Source]
    -> ('s, string list) request
  | Path_reset
    :  ('s, unit) request
  | Project_load
    :  [`File|`Find] * string
    -> ('s, string list * [`Ok | `Failures of (string * exn) list]) request

type 's a_request = Request : ('s,'a) request -> 's a_request

type 's response =
  | Return    : ('s,'a) request * 'a -> 's response
  | Failure   : string               -> 's response
  | Error     : Json.json            -> 's response
  | Exception : exn                  -> 's response
