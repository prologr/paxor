:- module(r_eval,
          [ eval/2
          ]).
:- use_module(library(strings)).
:- use_module(library(r/r_serve)).

eval(A, E) :-
    split_string(A, "\n", "\r", C),
    string_lines(D, C),
    r_eval_ex($, D, E).
