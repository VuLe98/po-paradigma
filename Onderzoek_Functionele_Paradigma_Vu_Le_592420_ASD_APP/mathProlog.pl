/* Math recursion example by factorial calculation */
factoriel(number, outcome) :-
    minusOne is number - 1,
    factoriel(minusOne, Z),
    outcome is Z*number, !.
/* */


kilometers_to_miles(Distance) :-
    Miles is Distance * 0.621371192,
    format('It\'s ~w miles', [Miles]).


isEven(number) :-
    Y is X//2, X =:= 2 * Y.

