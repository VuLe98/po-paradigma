male(romeo).
male(jeff).
male(dante).

female(daphne).
female(juliet).

relationship(romeo, daphne).
loves(romeo, juliet).

loves(juliet, romeo) :- loves(romeo, juliet).

going_to_marry(romeo, daphne) :- relationship(romeo, daphne),
    write('Romeo is going to marry Daphne if they are in a relationship').

parent(romeo, dante).
parent(romeo, jeff).

parent(juliet, dante).
parent(juliet, jeff).

parent(dante, rob).
parent(dante, john).

get_grandchild :-
    parent(romeo, X),
    parent(X,Y),
    write('Romeos grandchild is '),
    write(Y), nl.

get_grandparent :-
    parent(Y, rob),
    parent(X, Y),
    format('~w ~s grandparent', [X, 'is the']).

plays(john, tennis, racket).
play_match(rob, X) :- plays(X, tennis, racket).

grand_parent(X,Y) :-
    parent(Z,X),
    parent(Y,Z).



