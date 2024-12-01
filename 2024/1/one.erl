-module(one).
-export([similarity/3,start/0]).

ints(Str) ->
    lists:map(fun(X) -> {Int, _} = string:to_integer(X), Int end, 
              string:tokens(Str, " ")).

similarity([],_,S) -> S;
similarity([H|Rest],Right,S) ->
    NS = S + lists:sum(lists:filter(fun(X) -> X == H end, Right)),
    similarity(Rest,Right,NS).

start() ->
    {ok, Binary} = file:read_file("input.txt"),
    Lines = lists:map(fun(X) -> list_to_tuple(ints(X)) end,string:tokens(erlang:binary_to_list(Binary), "\n")),
    {Left,Right} = lists:unzip(Lines),
    Diff = lists:sum(lists:zipwith(fun(X,Y) -> abs(X-Y) end, lists:sort(Left), lists:sort(Right))),
    erlang:display(Diff),
    erlang:display(similarity(Left,Right,0)).
