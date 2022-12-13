head_tail([H|T], H, T).

sum([], 0).
sum([H|T], S) :- sum(T, Rest), S is H + Rest.

is_sorted([], []).
is_sorted([], _).

is_sorted(A, B) :- not(is_list(A)), not(is_list(B)), !, A < B.
is_sorted(A, B) :- not(is_list(A)), is_list(B), !, is_sorted([A], B).
is_sorted(A, B) :- not(is_list(B)), is_list(A), !, is_sorted(A, [B]).

is_sorted([AH|AT], [BH|BT]) :- is_equal(AH, BH), !, is_sorted(AT, BT), !.
is_sorted([AH|_], [BH|_]) :-  is_sorted(AH, BH), !.

is_equal([], []).
is_equal(A, B) :- not(is_list(A)), not(is_list(B)), !, A =:= B.
is_equal(A, B) :- is_list(A), not(is_list(B)), !, is_equal(A, [B]).
is_equal(A, B) :- not(is_list(A)), is_list(B), !, is_equal([A], B).
is_equal(A, B) :- is_list(A),
                  is_list(B), !,
                  head_tail(A, AH, AT),
                  head_tail(B, BH, BT),
                  is_equal(AH, BH), !,
                  is_equal(AT, BT).

idx_sorted([], _, []).
idx_sorted([[A,B]|Rest], Idx, Out) :- is_sorted(A, B), !, IdxNext is Idx + 1,  idx_sorted(Rest, IdxNext, ROut), Out = [Idx|ROut].
idx_sorted([[A,B]|Rest], Idx, Out) :- not(is_sorted(A, B)), !, IdxNext is Idx + 1, idx_sorted(Rest, IdxNext, Out).
idx_sorted(Input, Out) :- idx_sorted(Input, 1, Out).

add_to_list_idx(X, [], [X], 1).
add_to_list_idx(X, [H|T], [X,H|T], 1) :- is_sorted(X, H), !.
add_to_list_idx(X, [H|T], [H|TOut], I1) :- not(is_sorted(X,H)), !, add_to_list_idx(X, T, TOut, I), I1 is I + 1.

sorted_list([], []).
sorted_list([H|T], Out)  :- sorted_list(T, Sorted), !, add_to_list_idx(H, Sorted, Out, _).

part_one(Input, Sum) :- idx_sorted(Input, Out), sum(Out, Sum).


part_two(Input, [I1, I2]) :- sorted_list(Input, Sorted), !,
                             add_to_list_idx([[2]], Sorted, Sorted2, I1), !,
                             add_to_list_idx([[6]], Sorted2, _, I2).

# truncated list, see input_part1.txt
run_example_one :- part_one([[[1,1,3,1,1],[1,1,5,1,1]],[[[1],[2,3,4]],[[1],4]],[[9],[[8,7,6]]],[[[4,4],4,4],[[4,4],4,4,4]],[[7,7,7,7],[7,7,7]],[[],[3]],[[[[]]],[[]]],[[1,[2,[3,[4,[5,6,7]]]],8,9],[1,[2,[3,[4,[5,6,0]]]],8,9]]], Sum), write('Output='), write(Sum), nl.
run_part_one :- part_one([], Sum), write('Output='), write(Sum), nl.

# truncated list, see input_part2.txt
run_example_two :- part_two([[1,1,3,1,1],[1,1,5,1,1],[[1],[2,3,4]],[[1],4],[9],[[8,7,6]],[[4,4],4,4],[[4,4],4,4,4],[7,7,7,7],[7,7,7],[],[3],[[[]]],[[]],[1,[2,[3,[4,[5,6,7]]]],8,9],[1,[2,[3,[4,[5,6,0]]]],8,9]], Is), write('Indexes='), write(Is), nl.
run_part_two :- part_two([], Is), write('Indexes='), write(Is), nl.