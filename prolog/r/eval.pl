:- module(r_eval,
          [ eval_r/2
          ]).
:- use_module(library(strings)).
:- use_module(library(r/r_serve)).
:- use_module(library(r/r_call), []).

eval_r(A, E) :-
    split_string(A, "\n", "\r", C),
    string_lines(D, C),
    r_eval_ex($, D, E).
