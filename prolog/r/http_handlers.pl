:- module(r_http_handlers, []).
:- autoload(library(http/http_client), [http_read_data/3]).
:- autoload(library(http/http_dispatch), [http_handler/3]).
:- autoload(library(http/http_json), [reply_json/1]).
:- use_module(eval).

:- http_handler(root(r/eval), eval, [method(post), spawn]).

eval(Request) :-
    http_read_data(Request, R, [to(string)]),
    eval_r(R, Term),
    format('Content-Type: text/plain~n~n~q .', [Term]).
