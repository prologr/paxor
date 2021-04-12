:- attach_packs(..).

:- load_files([library(paxor/udp), library(paxor/http_handlers)]).

:- autoload(library(http/http_server), [http_server/1, http_stop_server/2]).

up(Port) :- http_server([port(Port)]).

down(Port) :- http_stop_server(Port, []).
