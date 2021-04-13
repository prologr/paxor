:- module(host_name, []).
:- autoload(library(socket), [gethostname/1]).
:- autoload(library(paxos), [paxos_set/2]).

:- initialization(up, program).

up :-
    gethostname(Host),
    tcp_host_to_address(Host, ip(A, B, C, D)),
    paxos_set(Host, [A, B, C, D]).
