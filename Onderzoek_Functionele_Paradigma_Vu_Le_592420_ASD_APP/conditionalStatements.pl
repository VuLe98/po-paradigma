loves(romeo, juliet).

loves(juliet, romeo) :- loves(romeo, juliet).

time(22) :-
    write('It is 22:00, go to sleep').

time(17) :-
    write('It is 17:00, time to eat dinner').

time(7) :-
    write('It is 7:00, time to wake up!').

time(Hour) :-
    format('It is ~w:00', [Hour]).


grade(5) :-
    write('Go to kindergarden').

grade(6) :-
    write('Go to grade 1').

grade(Other) :-
    Grade is Other - 5,
    format('Go to grade ~w', [Grade]).