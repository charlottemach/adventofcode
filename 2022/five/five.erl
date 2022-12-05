-module(five).
-export([procedure/1,mv/2,mvB/2,move/4,moveB/4,start/0]).

procedure(Str) ->
    L = string:tokens(Str," "),
    [list_to_integer(lists:nth(2,L)),list_to_integer(lists:nth(4,L)),list_to_integer(lists:nth(6,L))].

% returns state after applying all lines
mv(State,[]) -> State;
mv(State,[H|T]) -> 
    Cnt = lists:nth(1,H),
    From = lists:nth(2,H),
    To = lists:nth(3,H),
    mv(move(Cnt,From,To,State), T).

move(0, _, _, Lst) -> Lst;
move(Cnt, From, To, Lst) ->
    ColFrom = lists:nth(From,Lst),
    NewColFrom = string:slice(ColFrom,0,string:len(ColFrom)-1),
    Item = string:slice(ColFrom,string:len(ColFrom)-1),
    % replace column from where item is taken
    L2 = lists:append(lists:append(lists:sublist(Lst,1,From-1),[NewColFrom]), lists:sublist(Lst,From+1,10)),
    % replace column to where item is moved
    NewLst = lists:append(lists:append(lists:sublist(L2,1,To-1),[lists:nth(To,Lst)++Item]),lists:sublist(L2,To+1,10)),
    move(Cnt - 1, From, To, NewLst).

% returns state after applying all lines
mvB(State,[]) -> State;
mvB(State,[H|T]) -> 
    Cnt = lists:nth(1,H),
    From = lists:nth(2,H),
    To = lists:nth(3,H),
    mvB(moveB(Cnt,From,To,State), T).

moveB(Cnt, From, To, Lst) ->
    ColFrom = lists:nth(From,Lst),
    NewColFrom = string:slice(ColFrom,0,string:len(ColFrom)-Cnt),
    Items = string:slice(ColFrom,string:len(ColFrom)-Cnt),
    % replace column from which items are taken
    L2 = lists:append(lists:append(lists:sublist(Lst,1,From-1),[NewColFrom]), lists:sublist(Lst,From+1,10)),
    % replace column to which items are moved
    lists:append(lists:append(lists:sublist(L2,1,To-1),[lists:nth(To,Lst)++Items]),lists:sublist(L2,To+1,10)).


start() ->
    State = [ "SMRNWJVT","BWDJQPCV","BJFHDRP","FRPBMND","HVRPTB","CBPT","BJRPL","NCSLTZBW","LSG" ],
    {ok, Binary} = file:read_file("five.txt"),
    Lines = string:tokens(erlang:binary_to_list(Binary), "\n"),
    Ln = lists:map(fun procedure/1, Lines),

    erlang:display(lists:map(fun lists:last/1,mv(State, Ln))),
    erlang:display(lists:map(fun lists:last/1,mvB(State, Ln))).
