-module(four).
-export([split_numbers/1,start/0]).

ints(Str) ->
    lists:map(fun(X) -> {Int, _} = string:to_integer(X), Int end, 
              string:tokens(Str, " ")).

pow(I) ->
    if
      I == 0 -> 0;
      true -> trunc(math:pow(2,I-1))
    end.


split_numbers(Str) ->
    Inp = string:split(Str, ":"),
    Nums = string:split(lists:nth(2,Inp), "|"),

    Wins = ordsets:from_list(ints(lists:nth(1,Nums))),
    Have = ordsets:from_list(ints(lists:nth(2,Nums))),
    ordsets:size(ordsets:intersection(Wins,Have)).


% increase Cnt numbers in list Ls by Times, starting at index Ind
increase(Ls, _, _, 0) -> Ls;
increase(Ls, Ind, Times, Cnt) -> 
    NL = lists:sublist(Ls,Ind) ++ [lists:nth(Ind+1,Ls)+Times] ++ lists:nthtail(Ind+1,Ls),
    increase(NL, Ind+1, Times, Cnt-1).


% iterate over first list, running increase for each value
copies([],_,Ls) -> Ls;
copies([H|T],Ind,Ls) ->
    Times = lists:nth(Ind,Ls),
    L = increase(Ls, Ind, Times, H),
    copies(T,Ind+1,L). 


start() ->
    {ok, Binary} = file:read_file("input.txt"),
    Lines = string:tokens(erlang:binary_to_list(Binary), "\n"),
    Ln = lists:map(fun split_numbers/1, Lines),
    A = lists:map(fun(X) -> pow(X) end, Ln),
    erlang:display(lists:sum(A)),

    Cards = lists:duplicate(length(Ln),1),
    B = copies(Ln,1,Cards),
    erlang:display(lists:sum(B)).
