:- module(model_checker, [parse_and_evaluate/2]).

:- use_module(simplified_helpers, [memberList/2, compose/3]).
:- use_module(parser).

% Example Models
example(model1, model([john, annie, bob], [f(2, likes, [(john, annie), (bob, john)]), f(1, man, [john, bob]), f(1, woman, [annie])])).
example(model2, model([cat1, cat2, dog1, dog2], [f(2, likes, [(cat1, dog1), (cat2, dog2)]), f(1, cat, [cat1, cat2]), f(1, dog, [dog1, dog2])])).

% Top-level Predicate
parse_and_evaluate(Sentence, Result) :-
    phrase(parser:sentence(LogicalForm), Sentence),
    example(model1, Model), % Choose a model here
    evaluate(LogicalForm, Model, Result).

% Evaluate a formula in a model
evaluate(Formula, Model, Result) :-
    satisfy(Formula, Model, [], Result).

% Existential Quantification
satisfy(exists(X, Formula), model(D, F), G, pos) :-
    memberList(V, D),
    satisfy(Formula, model(D, F), [g(X, V) | G], pos).

satisfy(exists(X, Formula), model(D, F), G, neg) :-
    \+ (memberList(V, D), satisfy(Formula, model(D, F), [g(X, V) | G], pos)).

% Universal Quantification
satisfy(forall(X, Formula), model(D, F), G, pos) :-
    \+ (memberList(V, D), \+ satisfy(Formula, model(D, F), [g(X, V) | G], pos)).

satisfy(forall(X, Formula), model(D, F), G, neg) :-
    memberList(V, D),
    satisfy(Formula, model(D, F), [g(X, V) | G], neg).

% Conjunction
satisfy(and(Formula1, Formula2), Model, G, pos) :-
    satisfy(Formula1, Model, G, pos),
    satisfy(Formula2, Model, G, pos).

satisfy(and(Formula1, Formula2), Model, G, neg) :-
    satisfy(Formula1, Model, G, neg);
    satisfy(Formula2, Model, G, neg).

% Disjunction
satisfy(or(Formula1,Formula2),Model,G,pos):-
    satisfy(Formula1,Model,G,pos);
    satisfy(Formula2,Model,G,pos).

satisfy(or(Formula1,Formula2),Model,G,neg):-
    satisfy(Formula1,Model,G,neg),
    satisfy(Formula2,Model,G,neg).

% implication
satisfy(imp(Formula1, Formula2), Model, G, pos) :-
    satisfy(Formula1, Model, G, neg);
    satisfy(Formula2, Model, G, pos).

satisfy(imp(Formula1, Formula2), Model, G, neg) :-
    satisfy(Formula1, Model, G, pos),
    satisfy(Formula2, Model, G, neg).

% Negation
satisfy(not(Formula), Model, G, pos) :-
    satisfy(Formula, Model, G, neg).

satisfy(not(Formula), Model, G, neg) :-
    satisfy(Formula, Model, G, pos).

% Equality
satisfy(eq(X,Y),Model,G,pos):-
    i(X,Model,G,Value1),
    i(Y,Model,G,Value2),
    Value1=Value2.

satisfy(eq(X,Y),Model,G,neg):-
    i(X,Model,G,Value1),
    i(Y,Model,G,Value2),
    \+ Value1=Value2.

% Predicates
satisfy(Formula, model(D, F), G, pos) :-
    compose(Formula, Symbol, [Argument]),
    i(Argument, model(D, F), G, Value),
    memberList(f(1, Symbol, Values), F),
    memberList(Value, Values).

satisfy(Formula, model(D, F), G, neg) :-
    compose(Formula, Symbol, [Argument]),
    i(Argument, model(D, F), G, Value),
    memberList(f(1, Symbol, Values), F),
    \+ memberList(Value, Values).

satisfy(Formula, model(D, F), G, pos) :-
    compose(Formula, Symbol, [Arg1, Arg2]),
    i(Arg1, model(D, F), G, Value1),
    i(Arg2, model(D, F), G, Value2),
    memberList(f(2, Symbol, Values), F),
    memberList((Value1, Value2), Values).

satisfy(Formula, model(D, F), G, neg) :-
    compose(Formula, Symbol, [Arg1, Arg2]),
    i(Arg1, model(D, F), G, Value1),
    i(Arg2, model(D, F), G, Value2),
    memberList(f(2, Symbol, Values), F),
    \+ memberList((Value1, Value2), Values).

% Interpretation of Constants and Variables
i(X, model(D, _), _, X) :- memberList(X, D).
i(X, model(_, F), G, Value) :-
    (   var(X),
        memberList(g(Y, Value), G),
        Y == X, !
    ;   atom(X),
        memberList(f(0, X, Value), F)
    ).

% Example Queries:
% parse_and_evaluate([every, man, likes, a, woman], Result). % will return false because john likes annie, bob likes john.
% parse_and_evaluate([john, likes, annie],Result). % will return pos.
% parse_and_evaluate([a, cat, likes, a, dog], Result). % will return neg.
