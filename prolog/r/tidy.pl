:- module(r_tidy, []).
:- use_module(library(atom)).
:- use_module(library(filesex)).
:- use_module(library(readutil)).
:- use_module(library(thread_pool)).
:- use_module(library(settings)).
:- use_module(eval).
:- use_module(pool).

:- setting(delay, nonneg, 1, 'Seconds in-between tidying').

:- initialization(up, program).

up :- thread_create(tidy, _, [alias(tidy), detached(true)]).

tidy :-
    repeat,
    forall(r(R), tidy(R)),
    setting(delay, Delay),
    sleep(Delay),
    fail.

tidy(R) :-
    restyle_identifier(one_two, R, Alias0),
    atomic_concat(r_, Alias0, Alias),
    tidy(R, Alias).

tidy(_, Alias) :- thread_property(_, alias(Alias)), !.
tidy(R, Alias) :- thread_create_in_pool(r, eval(R), _,
                                        [ alias(Alias),
                                          detached(true)
                                        ]).

eval(R) :-
    read_file_to_string(R, R_, []),
    eval_r(R_, _).

r(R) :- directory_member(., R, [extensions(['R', r]), recursive(true)]).
