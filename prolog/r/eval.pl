:- module(r_eval,
          [ eval_r/2
          ]).
:- use_module(library(strings)).
:- use_module(library(r/r_serve)).
:- use_module(library(r/r_call), []).

eval_r(R, Term) :-
    split_string(R, "\n", "\r", Lines),
    string_lines(R_, Lines),
    r_eval_ex($, R_, Term).
