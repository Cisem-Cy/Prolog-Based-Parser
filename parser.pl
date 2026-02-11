
% This Prolog code defines a grammar for parsing and semantically interpreting English sentences. It uses Definite Clause Grammars (DCGs) to define the syntax and builds logical representations of the sentence meanings.
% from Bratko chapter 17 page 455. This comes from Pereira and Warren paper, AI journal, 1980.

:- module(parser,[]). % exports nothing, because nothing is called outside.  
% 1. Directives & Operators
:- discontiguous intrans_verb/5.


:- op(100, xfy, and).
:- op(150, xfx, '=>').   % These make logical formulas more readable.
:- op(160, xfx, is_a).  

% This DCG rule defines the structure of a sentence. A sentence consists of a noun phrase followed by a verb phrase.
% Meaning is a variable that is used to unify the logical meaning of the sentence.
sentence(Meaning) --> 
	noun_phrase(X, SubjState, Assn, Meaning),
    verb_phrase(X, SubjState, Assn).

% sentence(Meaning1 and Meaning2) -->
%     sentence(Meaning1), conjunction, sentence(Meaning2).

% conjunction --> [and] | [but].
conjunction --> [and].
conjunction --> [but].
    

% Example state.
% State = state(person(3rd), number(singular))

noun_phrase(X, SubjState, Assn, Meaning) --> 
	determiner(X, SubjState, Prop12, Assn, Meaning),
    noun(X, SubjState, Prop1),
    rel_clause(X, SubjState, Prop1, Prop12).
noun_phrase(X, plural, Assn, exists(X, Prop and plural(X) and Assn)) -->
    noun(X, plural, Prop).
noun_phrase(X, _, Assn, Assn) --> proper_noun(X).
noun_phrase(X, SubjState, Assn, Meaning) -->
    indefinite_pronoun(X, SubjState, Assn, Prop1),
    rel_clause(X, SubjState, Prop1, Meaning).
noun_phrase(X, _, Assn, Meaning) --> pronoun(X, Assn, Meaning).

verb_phrase(X, SubjState, Assn) --> trans_verb(X, SubjState, Y, Assn1), noun_phrase(Y, _SubjState2, Assn1, Assn).
verb_phrase(X, SubjState, Assn) --> intrans_verb(X, SubjState, Assn).

connective --> [that] | [who] | [which].
rel_clause(X, SubjState, Prop1, Prop1 and Prop2) --> connective, verb_phrase(X, SubjState, Prop2).
rel_clause(_, _SubjState, Prop1, Prop1) --> [].

% DETERMINERS
determiner(X, SubjState, Prop, Assn, forall(X, (Prop => Assn))) --> [every],
    { state_has_number(SubjState, singular) }.
determiner(X, SubjState, Prop, Assn, forall(X, (Prop => Assn))) --> [all],
    { state_has_number(SubjState, plural) }.

determiner(X, SubjState, Prop, Assn, exists(X, Prop and Assn)) --> [a],
    { state_has_number(SubjState, singular) }.
determiner(X, SubjState, Prop, Assn, exists(X, Prop and Assn)) --> [some],
    { state_has_number(SubjState, plural) }.

determiner(X, _SubjState, Prop, Assn, locally_unique(X, Prop) and Assn) --> [the].

% INDEFINITE PRONOUNS
indefinite_pronoun(X, SubjState, Assn, exists(X, X is_a person and Assn)) --> { s_verb_state(SubjState) }, ([somebody] | [someone]).
indefinite_pronoun(X, SubjState, Assn, forall(X, ((X is_a person) => Assn))) --> { s_verb_state(SubjState) }, ([everybody] | [everyone]).

% NOUNS
noun_singular(person).
noun_singular(thing).
noun_singular(woman).
noun_singular(dog).
noun_singular(man).
noun_singular(book).
noun_singular(cat).
noun_singular(bird).
noun_singular(car).
noun_singular(house).
noun_singular(tree).
noun_singular(computer).
noun_singular(phone).
noun_singular(city).
noun_singular(country).
noun_singular(river).
noun_singular(mountain).  

pluralization(person, people).
pluralization(woman, women).
pluralization(man, men).
pluralization(Class, Noun) :- noun_singular(Class), atom_concat(Class, s, Noun).

state_has_number(state(_, number(Number)), Number).
state_has_person(state(person(Person), _), Person).

noun(X, State, X is_a Noun) --> [Noun],
    { state_has_number(State, singular), noun_singular(Noun) }.
noun(X, State, X is_a Class) --> [Plural],
    { state_has_number(State, plural), pluralization(Singular, Plural), Class = Singular }.

% PRONOUNS
pronoun(X, Prop, (Prop, speaker(X))) --> [i] | [me].
pronoun(X, Prop, (Prop, speakee(X))) --> [you].
pronoun(X, Prop, (Prop, locally_unique(X, gender(X, nonbinary), singular(X)))) --> [them] | [they].
pronoun(X, Prop, locally_unique(X, multiple(X)) and Prop) --> [them] | [they].
pronoun(X, Prop, locally_unique(X, gender(X, feminine)) and Prop) --> [she] | [her].
pronoun(X, Prop, locally_unique(X, gender(X, masculine)) and Prop) --> [he] | [him].
pronoun(X, Prop, locally_unique(X, X is_a object) and Prop) --> [it].

proper_noun(john) --> [john].
proper_noun(annie) --> [annie].
proper_noun(monet) --> [monet].
proper_noun(new_york) --> [new, york].
proper_noun(paris) --> [paris].
proper_noun(london) --> [london].
proper_noun(alice) --> [alice].
proper_noun(bob) --> [bob].
proper_noun(eve) --> [eve].
  

trans_verb(Subj, SubjState, Obj, likes(Subj, Obj)) --> [likes],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, likes(Obj, Subj)) --> [is, liked, by],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, likes(Subj, Obj)) --> [like],
    { \+ s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, likes(Obj, Subj)) --> [are, liked, by],
    { \+ s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, not(likes(Subj, Obj))) --> [does, not, like],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, not(likes(Subj, Obj))) --> [do, not, like],
    { \+ s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, admires(Subj, Obj)) --> [admires],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, admires(Subj, Obj)) --> [admire],
    { \+ s_verb_state(SubjState) }.

trans_verb(Subj, SubjState, Obj, reads(Subj, Obj)) --> [reads],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, reads(Subj, Obj)) --> [read],
    { \+ s_verb_state(SubjState) }.

trans_verb(Subj, SubjState, Obj, drives(Subj, Obj)) --> [drives],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, drives(Subj, Obj)) --> [drive],
    { \+ s_verb_state(SubjState) }.

trans_verb(Subj, SubjState, Obj, builds(Subj, Obj)) --> [builds],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, builds(Subj, Obj)) --> [build],
    { \+ s_verb_state(SubjState) }.

trans_verb(Subj, SubjState, Obj, climbs(Subj, Obj)) --> [climbs],
    { s_verb_state(SubjState) }.
trans_verb(Subj, SubjState, Obj, climbs(Subj, Obj)) --> [climb],
    { \+ s_verb_state(SubjState) }.


intrans_verb(Subj, singular, paints(Subj)) --> [paints].
intrans_verb(Subj, plural, paints(Subj)) --> [paint].
intrans_verb(Subj, singular, sleeps(Subj)) --> [sleeps].
intrans_verb(Subj, plural, sleeps(Subj)) --> [sleep].
intrans_verb(Subj, singular, runs(Subj)) --> [runs].
intrans_verb(Subj, plural, runs(Subj)) --> [run].
intrans_verb(Subj, singular, jumps(Subj)) --> [jumps].
intrans_verb(Subj, plural, jumps(Subj)) --> [jump].
intrans_verb(Subj, singular, sings(Subj)) --> [sings].
intrans_verb(Subj, plural, sings(Subj)) --> [sing].
intrans_verb(Subj, singular, dances(Subj)) --> [dances].
intrans_verb(Subj, plural, dances(Subj)) --> [dance].  
  

% SPEC(I, you, he/she/it/the dog, we, yall, they/the dogs).
% SPEC('', '', s,                 '', '',   '').
% verb1(3rd-singular, non-3rd-singular).
verb1(paints, paint).
verb1(sleeps, sleep).
verb1(eats, eat).

% The s_verb_state/1 predicate checks the subject-s state (singular or plural) to choose the correct verb form.
s_verb_state(state(person(3), number(singular))).

intrans_verb(Subj, SubjState, Term) --> [Word],
    {
        s_verb_state(SubjState),
        verb1(SVerb, _NonSVerb),
        Word = SVerb,
        Head = SVerb,
        Term =.. [Head, Subj]
    }.

intrans_verb(Subj, SubjState, Term) --> [Word],
    {
        \+ s_verb_state(SubjState),
        verb1(SVerb, NonSVerb),
        Word = NonSVerb,
        Head = SVerb,
        Term =.. [Head, Subj]
    }.
    
  % Example queries
  % parser:sentence(S,[every,man,that,paints,likes,monet],[]).
  % Output: S = forall(_A, (and(is_a(_A, man), paints(_A))=>likes(_A, monet))) .
  % parser:sentence(S,[a,woman,that,admires,john,paints],[]).
  % Output: S = exists(_A, and(and(is_a(_A, woman), admires(_A, john)), paints(_A))) .
  % parser:sentence(S,[every,woman,that,likes,a,man,that,admires,monet,paints],[]).
  % Output: S = forall(_A, (and(is_a(_A, woman), exists(_B, and(and(is_a(_B, man), admires(_B, monet)), likes(_A, _B))))=>paints(_A))) .
  % parser:sentence(S,[john,likes,annie],[]).
  % Output: S = likes(john, annie) .
  % parser:sentence(S,[annie,likes,a,man,that,admires,monet],[]).
  % Output: S = exists(_A, and(and(is_a(_A, man), admires(_A, monet)), likes(annie, _A))) .

