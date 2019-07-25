-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% Sparse Arrays
%% https://www.hackerrank.com/challenges/sparse-arrays/problem
main() ->
    {ok, [StringSize]} = io:fread("", "~d"),
    SFormat = lists:flatten(lists:duplicate(StringSize, "~s")),
    {ok, Strings} = io:fread("", SFormat),
    {ok, [QuerySize]} = io:fread("", "~d"),
    QFormat = lists:flatten(lists:duplicate(QuerySize, "~s")),
    {ok, Queries} = io:fread("", QFormat),
    Result = matching_strings(Strings, Queries),
    [io:format("~p~n", [Res]) || Res <- Result].

matching_strings(Strings, Queries) ->
    lists:foldr(
      fun(Query, Acc) ->
              [lists:foldl(
                 fun(String, Number) ->
                         case Query == String of
                             true ->
                                 Number + 1;
                             false ->
                                 Number
                         end
                 end, 0, Strings) | Acc]
      end, [], Queries).

%% -----------------------------------------------------------------------------
%% Tests
simple_test() ->
    ?assert(matching_strings(["aba","baba","aba","xzxb"],
                             ["aba","xzxb","ab"]) =:= [2,1,0]),
    ?assert(matching_strings(["def","de","fgh"],
                             ["de","lmn","fgh"]) =:= [1,0,1]),
    ?assert(matching_strings(
              ["abcde","sdaklfj","asdjf","na","basdn","sdaklfj","asdjf","na",
               "asdjf","na","basdn","sdaklfj","asdjf"],
              ["abcde","sdaklfj","asdjf","na","basdn"]) =:= [1,3,4,3,2]).

