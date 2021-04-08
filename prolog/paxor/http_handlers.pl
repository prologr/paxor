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
    findall(Key=Data,
            (   property(Property),
                Property =.. [Key, Data]
            ), Terms),
    reply_json(json(Terms)).

property(Property) :- paxos_property(Property).
property(nth1(Nth1)) :-
    paxos_property(node(Node)),
    paxos_property(quorum(Quorum)),
    pop_lsbs(Quorum, Nodes),
    once(nth1(Nth1, Nodes, Node)).

pop_lsbs(0, []) :- !.
pop_lsbs(A, [H|T]) :-
    H is lsb(A),
    B is A /\ \(1 << H),
    pop_lsbs(B, T).

key(get, Key, _Request) :-
    (   paxos_get(Key, Data)
    ->  Terms = [data=Data]
    ;   Terms = []
    ),
    reply_json(json(Terms), [serialize_unknown(true)]).
key(post, Key, Request) :-
    http_read_data(Request, Data, []),
    paxos_set(Key, Data).
