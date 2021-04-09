/*  File:       paxor/http_handlers.pl
    Author:     Roy Ratcliffe
    E-mail:     royratcliffe@me.com
    WWW:        https://github.com/royratcliffe

    Copyright (c) 2021 Roy Ratcliffe, United Kingdom
    All rights reserved

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to
    deal in the Software without restriction, including without limitation the
    rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
    sell copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.
*/

:- module(paxor_http_handlers, []).
:- autoload(library(http/http_dispatch), [http_handler/3]).
:- autoload(library(http/http_json),
            [ reply_json/1,
              reply_json/2,
              http_read_json/2
            ]).
:- autoload(library(paxos), [paxos_property/1, paxos_get/2, paxos_set/2]).
:- autoload(library(lists), [nth1/3]).

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
property(Property) :-
    paxos_property(quorum(Quorum)),
    pop_lsbs(Quorum, Nodes),
    property_of_nodes(Nodes, Property).

property_of_nodes(Nodes, nodes(Nodes)).
property_of_nodes(Nodes, nth1(Nth1)) :-
    paxos_property(node(Node)),
    once(nth1(Nth1, Nodes, Node)).

pop_lsbs(0, []) :- !.
pop_lsbs(A, [H|T]) :-
    H is lsb(A),
    B is A /\ \(1 << H),
    pop_lsbs(B, T).

key(get, Key, _Request) :-
    (   paxos_get(Key, Data)
    ->  reply_json(Data, [serialize_unknown(true)])
    ;   throw(http_reply(no_content))
    ).
key(post, Key, Request) :-
    http_read_json(Request, Data),
    paxos_set(Key, Data),
    throw(http_reply(no_content)).
