/*  File:       paxor/udp.pl
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

:- module(paxor_udp, []).
:- autoload(library(udp_broadcast), [udp_broadcast_initialize/2]).
:- autoload(library(paxos), [paxos_initialize/1]).

:- initialization(udp_broadcast_initialize(ip(0, 0, 0, 0),
                                           [ scope(paxos)
                                           ]), program).
:- initialization(paxos_initialize([]), program).

:- multifile paxos:paxos_message_hook/3.

paxos:paxos_message_hook(A, -, udp(paxos, A)) :- !.
paxos:paxos_message_hook(A, B, udp(paxos, A, B)).
