%%%-------------------------------------------------------------------
%%% @author Heinz N. Gies <heinz@Heinz-N-Giess-MacBook-Pro.local>
%%% @copyright (C) 2010, Heinz N. Gies
%%% @doc This module offers an interface to the underlaying database.
%%% 
%%% @end
%%% Created : 26 Aug 2010 by Heinz N. Gies <heinz@Heinz-N-Giess-MacBook-Pro.local>
%%%-------------------------------------------------------------------
-module(mushdb).

-export([set/3, 
  get/2,
  delete/1, 
  match/1, add_connection/2]).

%%--------------------------------------------------------------------
%% @doc
%% Inserts a object in the database or replaces it.
%%
%% @spec set(ID::integer(), Key::any(), Value::any()) -> {ok, Pid::pid}
%% @end
%%--------------------------------------------------------------------

set(ID, Attr, Value) ->
  case mdb_store:lookup(ID) of
    {ok, Pid} ->
      mdb_store:update(ID, {Attr, Value}),
      mdb_element:set(Pid, Attr, Value);
    {error, _} ->
      {ok, Pid} = mdb_element:create(ID),
      mdb_element:set(Pid, Attr, Value),
      mdb_store:insert(ID, Pid)
  end.

%%--------------------------------------------------------------------
%% @doc
%% Gets an attribute from an object in the database.
%%
%% @spec get(ID::integer(), Key::any()) -> {ok, Value::any()} | {error, not_found}
%% @end
%%--------------------------------------------------------------------
get(ID, Attr) ->
  try
    {ok, Pid} = mdb_store:lookup(ID),
    {ok, Value} = mdb_element:get(Pid, Attr),
    {ok, Value}
  catch
    _Class:Exception ->
      io:format("~w~n", [Exception]),
      {error, not_found}
  end.

%%--------------------------------------------------------------------
%% @doc
%% Tries to match a object on some characteristics.
%%
%% @spec match(Match) -> {ok, Value::any()} | {error, not_found}
%%  Match = {Type, Name} | {Type, Name, Location}
%%  Type = thing | exit | room
%%  Name = string()
%%  Location = integer()
%% @end
%%--------------------------------------------------------------------
match(Match) ->
  try 
    mdb_store:match(Match)
  catch
    _Class:_Exception ->
    {error, not_found}
  end.
	
%%--------------------------------------------------------------------
%% @doc
%% Deletes object.
%%
%% @spec delete(ID::integer()) -> ok
%% @end
%%--------------------------------------------------------------------
delete(ID) ->
  case mdb_store:lookup(ID) of
    {ok, Pid} ->
      sc_element:delete(Pid);
    {error, _Reason} ->
      ok
  end.

%%--------------------------------------------------------------------
%% @doc
%% Adds a Object to a TCP connection to bind those two.
%%
%% @spec add_connection(Obj, Con::pid()) -> ok
%%  Obj = ID | Pid
%%  ID = integer() 
%%  Pid = pid()
%% @end
%%--------------------------------------------------------------------
add_connection(ID, Con) when is_integer(ID) ->
  {ok, Pid} = mdb_store:lookup(ID),
  add_connection(Pid, Con);
add_connection(Pid, Con) when is_pid(Pid) ->
  mdb_element:add_connection(Pid, Con).