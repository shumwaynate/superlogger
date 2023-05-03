%%%-------------------------------------------------------------------
%% @doc superlogger public API
%% @end
%%%-------------------------------------------------------------------

-module(superlogger_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    superlogger_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
