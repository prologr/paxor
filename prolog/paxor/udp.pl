:- module(paxor_udp, []).
:- autoload(library(udp_broadcast), [udp_broadcast_initialize/2]).
:- autoload(library(paxos), [paxos_initialize/1]).

:- initialization(udp_broadcast_initialize(ip(0, 0, 0, 0), [scope(paxos)]), program).
:- initialization(paxos_initialize([]), program).

:- multifile paxos:paxos_message_hook/3.

paxos:paxos_message_hook(A, -, udp(paxos, A)) :- !.
paxos:paxos_message_hook(A, B, udp(paxos, A, B)).
