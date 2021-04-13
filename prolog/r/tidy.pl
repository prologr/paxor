:- module(r_tidy, []).
:- use_module(library(atom)).
:- use_module(library(filesex)).
:- use_module(library(thread_pool)).
:- use_module(eval).
:- use_module(pool).

:- setting(delay, nonneg, 1, 'Seconds in-between tidying').

:- initialization(up, program).

up :- thread_create(tidy, _, [alias(tidy), detached(true)]).

tidy :-
    repeat,
    forall(r(A), tidy(A)),
    setting(delay, Delay),
    sleep(Delay),
    fail.

tidy(A) :-
    restyle_identifier(one_two, A, B),
    atomic_concat(r_, B, C),
    tidy(A, C).

tidy(_, B) :- thread_property(_, alias(B)), !.
tidy(A, B) :- thread_create_in_pool(r, eval(A, _), _,
                                    [ alias(B),
                                      detached(true)
                                    ]).

r(A) :- directory_member(., A, [extensions(['R', r]), recursive(true)]).
