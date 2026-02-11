% parser_testsuite.pl

:- begin_tests(grammar_tests).

% Test 1: Simple sentence with proper nouns
test(simple_sentence) :-
    parser:sentence(S, [john, likes, annie], []),
    S = likes(john, annie).

% Test 2: Relative clause with existential quantifier
test(relative_clause) :-
    parser:sentence(S, [annie, likes, a, man, that, admires, monet], []),
    S = exists(A, and(is_a(A, man), and(admires(A, monet), likes(annie, A)))).

% Test 3: Universal quantifier with relative clause
test(universal_relative_clause) :-
    parser:sentence(S, [every, man, that, paints, likes, monet], []),
    S = forall(A, (and(is_a(A, man), paints(A)) => likes(A, monet))).

% Test 4: Existential quantifier with relative clause
test(existential_quantifier) :-
    parser:sentence(S, [a, woman, that, admires, john, paints], []),
    S = exists(A, and(is_a(A, woman), and(admires(A, john), paints(A)))).

% Test 5: Nested relative clauses
test(nested_relative_clauses) :-
    parser:sentence(S, [every, woman, that, likes, a, man, that, admires, monet, paints], []),
    S = forall(A, (and(is_a(A, woman), exists(B, and(is_a(B, man), and(admires(B, monet), likes(A, B))))) => paints(A))).

% Test 6: Conjunction
test(conjunction) :-
    parser:sentence(S, [annie, likes, a, book, and, john, likes, a, dog], []),
    S = and(exists(A, and(is_a(A, book), likes(annie, A))), exists(B, and(is_a(B, dog), likes(john, B)))).

% Test 7: Negation
test(negation) :-
    parser:sentence(S, [the, dog, does, not, like, the, cat], []),
    S = and(unique(A, is_a(A, dog)), and(unique(B, is_a(B, cat)), not(likes(A, B)))).

% Test 8: Intransitive verb
test(intransitive_verb) :-
    parser:sentence(S, [a, bird, sings], []),
    S = exists(A, and(is_a(A, bird), sings(A))).

% Test 9: Proper noun as subject
test(proper_noun_subject) :-
    parser:sentence(S, [monet, paints], []),
    S = paints(monet).

% Test 10: Proper noun as object
test(proper_noun_object) :-
    parser:sentence(S, [annie, likes, monet], []),
    S = likes(annie, monet).

% Test 11: Complex relative clause
test(complex_relative_clause) :-
    parser:sentence(S, [the, man, that, likes, a, woman, that, admires, monet, sleeps], []),
    S = and(unique(A, and(is_a(A, man), exists(B, and(is_a(B, woman), and(admires(B, monet), likes(A, B)))))), sleeps(A)).

% Test 12: Indefinite pronoun with relative clause
test(indefinite_pronoun_relative_clause) :-
    parser:sentence(S, [everybody, that, likes, monet, admires, annie], []),
    S = forall(A, (and(is_a(A, person), likes(A, monet)) => admires(A, annie))).

% Test 13: Proper noun with relative clause
test(proper_noun_relative_clause) :-
    parser:sentence(S, [annie, likes, the, man, that, admires, monet], []),
    S = and(unique(A, and(is_a(A, man), admires(A, monet))), likes(annie, A)).

% Test 14: Complex sentence with multiple clauses
test(complex_sentence_multiple_clauses) :-
    parser:sentence(S, [the, woman, that, likes, the, man, that, admires, monet, sleeps], []),
    S = and(unique(A, and(is_a(A, woman), unique(B, and(is_a(B, man), and(admires(B, monet), likes(A, B)))))), sleeps(A)).

% Test 15: Universal quantifier with nested relative clauses
test(universal_quantifier_nested_relative_clauses) :-
    parser:sentence(S, [every, woman, that, likes, a, man, that, admires, monet, paints], []),
    S = forall(A, (and(is_a(A, woman), exists(B, and(is_a(B, man), and(admires(B, monet), likes(A, B))))) => paints(A))).

% Test 16: Existential quantifier with nested relative clauses
test(existential_quantifier_nested_relative_clauses) :-
    parser:sentence(S, [a, woman, that, likes, a, man, that, admires, monet, paints], []),
    S = exists(A, and(is_a(A, woman), and(exists(B, and(is_a(B, man), and(admires(B, monet), likes(A, B)))), paints(A)))).

:- end_tests(grammar_tests).
