friend(rob, derek).
friend(rob, phillip).
friend(rob, ming).

friend(derek, hailey).
friend(derek, jan).

friend_of_friend(X,Y) :-
    friend(X, Z),
    friend_of_friend(Z, Y).



