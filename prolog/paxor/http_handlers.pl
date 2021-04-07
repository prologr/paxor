:- module(paxor_http_handlers, []).
:- autoload(library(http/http_dispatch), [http_handler/3]).
:- autoload(library(http/http_client), [http_read_data/3]).
:- autoload(library(http/http_json), [reply_json/1]).
:- autoload(library(paxos), [paxos_property/1, paxos_get/2, paxos_set/2]).

:- http_handler(root(paxor), properties, []).
:- http_handler(root(paxor/Key), key(Method, Key),
                [ method(Method),
                  methods([get, post])
                ]).

properties(_Request) :-
    findall(A=B, (paxos_property(C), C =.. [A, B]), D),
    reply_json(json(D)).

key(get, Key, _Request) :-
    (   paxos_get(Key, Data)
    ->  JSON = [data=Data]
    ;   JSON = []
    ),
    reply_json(json(JSON)).
key(post, Key, Request) :-
    http_read_data(Request, Data, []),
    paxos_set(Key, Data).
