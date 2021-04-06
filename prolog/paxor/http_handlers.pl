:- module(paxor_http_handlers, []).
:- autoload(library(http/http_dispatch), [http_handler/3]).
:- autoload(library(http/http_json), [reply_json/1]).
:- autoload(library(paxos), [paxos_property/1]).

:- http_handler(root(paxor/properties), properties, []).

properties(_Request) :-
    findall(A=B, (paxos_property(C), C =.. [A, B]), D),
    reply_json(json(D)).
