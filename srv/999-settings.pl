:- use_module(library(settings), [load_settings/2]).

:-
    expand_file_name('*.settings', A),
    forall(member(B, A),
           load_settings(B, [undefined(load)])).
