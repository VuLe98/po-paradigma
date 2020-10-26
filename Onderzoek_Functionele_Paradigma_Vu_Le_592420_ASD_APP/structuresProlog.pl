has(arthur, food(fruit, banana)).

/* Format */
bank_account(jeff, grimm).
bank_account(nigel, holiday).
money(jeff, grimm, 100.00).
money(nigel, holiday, 13.55).

get_money(FName, LName) :- bank_account(FName, LName),
  money(FName, LName, Bal),
  write(FName), tab(1),
  format('~w has $~2f ~n', [LName, Bal]).
