# Prolog-Based-Parser

This project was developed as a final project for the Computational Semantics course at the University of Konstanz. It parses English sentences into formal logical representations and evaluating them against a model. This project was aimed to explore Turkish (an agglutinative, free-word-order language). However, due to the extreme complexity of suffixal morphology and vowel harmony for a baseline DCG, the focus was shifted to English to demonstrate the core logical-semantic mapping. 

Key Features;

- DCG Grammar: A Definite Clause Grammar (DCG) that handles quantifiers, relative clauses, and complex syntactic structures.

- First-Order Logic (FOL): Translates natural language into FOL representations (e.g., `forall`, `exists`, `unique`).

- Model Checker: A functional model checker that evaluates the truth value of generated logical forms against a predefined world model.

- Test Suite:  Includes a comprehensive test suite to ensure the accuracy of semantic interpretations.

Concepts: Formal Semantics, Model Theory, Definite Clause Grammars.
