counting_down(Number) :-
    Number > 0, write(Number),nl, NewNumber is Number-1,
    counting_down(NewNumber).

counting_down(0).
