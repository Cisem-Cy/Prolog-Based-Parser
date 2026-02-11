:- module(simplified_helpers, [memberList/2, compose/3]).
% List membership
memberList(X, [X|_]).
memberList(X, [_|Tail]) :- memberList(X, Tail).

% Compose predicate argument structure
compose(Term, Symbol, ArgList) :-
    Term =.. [Symbol|ArgList].
