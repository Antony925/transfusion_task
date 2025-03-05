% Задаємо ємність посудин (четверта посудина — нескінченний кран/стік, позначаємо великою кількістю)
capacity([8, 3, 7, 1000]).

% Задаємо початковий стан і фінальний стан
start_stage([8, 0, 0, 0]).
goal_stage([3, 0, 5, _]).  % Четверта посудина може бути в будь-якому стані

% Операція переливання води з однієї посудини в іншу
pour([X, Y, Z, W], [X1, Y1, Z, W]) :- capacity([_, MaxY, _, _]), transfer(X, Y, X1, Y1, MaxY).
pour([X, Y, Z, W], [X1, Y, Z1, W]) :- capacity([_, _, MaxZ, _]), transfer(X, Z, X1, Z1, MaxZ).
pour([X, Y, Z, W], [X, Y1, Z1, W]) :- capacity([_, _, MaxZ, _]), transfer(Y, Z, Y1, Z1, MaxZ).
pour([X, Y, Z, W], [X1, Y1, Z, W]) :- capacity([MaxX, _, _, _]), transfer(Y, X, Y1, X1, MaxX).
pour([X, Y, Z, W], [X1, Y, Z1, W]) :- capacity([MaxX, _, _, _]), transfer(Z, X, Z1, X1, MaxX).
pour([X, Y, Z, W], [X, Y1, Z1, W]) :- capacity([_, MaxY, _, _]), transfer(Z, Y, Z1, Y1, MaxY).

% Додаємо переливання з крана / в стік
pour([X, Y, Z, W], [X1, Y, Z, W1]) :- capacity([_, _, _, MaxW]), transfer(X, W, X1, W1, MaxW). % Виливаємо в стік
pour([X, Y, Z, W], [X, Y1, Z, W1]) :- capacity([_, _, _, MaxW]), transfer(Y, W, Y1, W1, MaxW).
pour([X, Y, Z, W], [X, Y, Z1, W1]) :- capacity([_, _, _, MaxW]), transfer(Z, W, Z1, W1, MaxW).
pour([X, Y, Z, W], [X1, Y, Z, W1]) :- capacity([_, _, _, MaxW]), transfer(W, X, W1, X1, MaxW). % Наповнюємо з крана
pour([X, Y, Z, W], [X, Y1, Z, W1]) :- capacity([_, _, _, MaxW]), transfer(W, Y, W1, Y1, MaxW).
pour([X, Y, Z, W], [X, Y, Z1, W1]) :- capacity([_, _, _, MaxW]), transfer(W, Z, W1, Z1, MaxW).

% Функція переливу з однієї посудини в іншу
transfer(A, B, A1, B1, MaxB) :-  
    Total is A + B,  
    (Total =< MaxB -> A1 = 0, B1 = Total ; A1 is Total - MaxB, B1 = MaxB).

% Основний пошук шляху
path(P) :-
    start_stage(Start),
    goal_stage(Goal),
    bfs_algorithm([[Start]], Goal, RevPath),
    reverse(RevPath, P).

% Алгоритм пошуку в ширину
bfs_algorithm([[Goal | Rest] | _], Goal, [Goal | Rest]).
bfs_algorithm([[State | Rest] | Queue], Goal, P) :-
    findall([Next, State | Rest],
            (pour(State, Next), \+ member(Next, [State | Rest])),
            NewPaths),
    append(Queue, NewPaths, NewQueue),
    bfs_algorithm(NewQueue, Goal, P).