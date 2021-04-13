:- module(r_pool, []).
:- autoload(library(thread_pool), [thread_pool_create/3]).
:- use_module(library(settings), [setting/4, setting/2]).

:- setting(size, nonneg, 0, 'Maximum concurrent R sessions').

:- multifile thread_pool:create_pool/1.

thread_pool:create_pool(r) :- size(Size), thread_pool_create(r, Size, []).

size(Size) :- setting(size, Size), Size \== 0, !.
size(Size) :- current_prolog_flag(cpu_count, Size).
