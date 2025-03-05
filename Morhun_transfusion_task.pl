% Задаємо ємність посудин
capacity([8, 3, 7]). 

% Задаємо початковий стан і фінальний стан
start_stage([8, 0, 0]).
goal_stage([3, 0, 5]).

% Операція переливання води з однієї посудини в іншу
pour([X, Y, Z], [X1, Y1, Z]) :- capacity([_, MaxY, _]), transfer(X, Y, X1, Y1, MaxY).
pour([X, Y, Z], [X1, Y, Z1]) :- capacity([_, _, MaxZ]), transfer(X, Z, X1, Z1, MaxZ).
pour([X, Y, Z], [X, Y1, Z1]) :- capacity([_, _, MaxZ]), transfer(Y, Z, Y1, Z1, MaxZ).
pour([X, Y, Z], [X1, Y1, Z]) :- capacity([MaxX, _, _]), transfer(Y, X, Y1, X1, MaxX).
pour([X, Y, Z], [X1, Y, Z1]) :- capacity([MaxX, _, _]), transfer(Z, X, Z1, X1, MaxX).
pour([X, Y, Z], [X, Y1, Z1]) :- capacity([_, MaxY, _]), transfer(Z, Y, Z1, Y1, MaxY).

% Функція переливаємо з однієї посудини в іншу
transfer(A, B, A1, B1, MaxB) :-  
    Total is A + B,  
    (Total =< MaxB -> A1 = 0, B1 = Total ; A1 is Total - MaxB, B1 = MaxB).

% Основний пошук шляху
path(P) :-
    start_stage(Start),
    goal_stage(Goal),
    bfs_algorithm([[Start]], Goal, RevPath),
    reverse(RevPath, P).              % отримуємо список у зворотньому порядку, 
                                      % бо кожне переливання додається на початок списку

% Алгоритм пошуку в ширину
bfs_algorithm([[Goal | Rest] | _], Goal, [Goal | Rest]).
bfs_algorithm([[State | Rest] | Queue], Goal, P) :-
    findall([Next, State | Rest],
            (pour(State, Next), \+ member(Next, [State | Rest])),
            NewPaths),
    append(Queue, NewPaths, NewQueue),
    bfs_algorithm(NewQueue, Goal, P).