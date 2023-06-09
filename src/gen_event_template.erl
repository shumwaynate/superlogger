%%%-------------------------------------------------------------------
%%% @author Lee Barney  <barney.cit@gmail.com>
%%% @copyright © 2022, Lee S. Barney
%%% @reference Licensed under the 
%%% <a href="http://creativecommons.org/licenses/by/4.0/">
%%% Creative Commons Attribution 4.0 International License</a>.
%%%
%%% @doc
%%% This is a template for gen_event handlers. Usually, event handlers
%%% and their event manager are initiated by one or more supervisors, 
%%% though event handlers can be initialized directly by their manager.
%%%
%%% Event handlers' methods are intended to be used by their manager.
%%% Therefore, event handlers do not have an API that is used
%%% in other parts of your code.
%%%
%%%
%%% @end

%%% Created : 24 October 2022 by Lee Barney <barney.cit@gmail.com>
%%%-------------------------------------------------------------------
-module(gen_event_template).
-behaviour(gen_event).

%% Only include the eunit testing library
%% in the compiled code if testing is 
%% being done.
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.


%% Supervisor Callbacks
-export([init/1,terminate/3,code_change/2]).
%% event Callbacks
-export([handle_event/2,handle_info/2,handle_call/2]).
-export([start_event_manager/1, notify_manager/2]).


start_event_manager(Name) ->
    {ok, P} = gen_event:start(),
    gen_event:add_handler(P, gen_event_template, standard_io),
    register(Name, P).

notify_manager(P, Message) ->
    gen_event:notify(P, {Message, {no_frequency, self()}}).

%%%===================================================================
%%% Mandatory callback functions
%%%===================================================================

terminate(_Reason, _State, _Data) ->
    void.

code_change(_Vsn, _State) ->
    ok.

init(standard_io) ->
    %% This function has a value that is a tuple
    %% consisting of ok and the initial state data.
    {ok, {standard_io, 1}};
init(Args) ->
    {error, {args, Args}}.


%%%===================================================================
%%% Callback functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%%
%% Used when a non-OTP-standard message is sent to a manager.
%%
%%
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {ok,State}.

%%--------------------------------------------------------------------
%% @doc
%%
%% Used when a manager is sent a request using gen_event:call/3/4.
%%
%%
%% @end
%%--------------------------------------------------------------------
handle_call(_Request,State)->
    Response = [],
    {ok,Response,State}.

%%--------------------------------------------------------------------
%% @doc
%%
%% Used when a manager is sent an event using gen_event:notify/2 or 
%% gen_event:sync_notify/2.
%%
%%
%% @end
%%--------------------------------------------------------------------
handle_event(Message,State={standard_io, Count}) ->
    %Modify the state as appropriate.
    io:format("~p~n", [State]),
    io:format("~p~n", [Message]),
    case Message of
        {msg, _Data} -> io:format("Nice Job Scrub~n"), {ok, State};
        {candy, _Data} -> io:format("I like candy~n"),  {ok, State};
        {increment, _Data} -> io:format("Count: ~p~n", [Count]),  {ok, {standard_io, Count+1}}
    end.


%% This code is included in the compiled code only if 
%% 'rebar3 eunit' is being executed.
-ifdef(EUNIT).
%%
%% Unit tests go here. 
%%
    handle_event_test_() ->
    [
        ?_assertEqual({ok, {standard_io, 2}}, handle_event({increment, {no_frequency, somewhere}}, {standard_io, 1})),
        ?_assertEqual({ok, {standard_io, 3}}, handle_event({increment, {no_frequency, somewhere}}, {standard_io, 2})),
        ?_assertEqual({ok, {standard_io, 2}}, handle_event({msg, {no_frequency, somewhere}}, {standard_io, 2})),
        ?_assertEqual({ok, {standard_io, 2}}, handle_event({candy, {no_frequency, somewhere}}, {standard_io, 2}))
    ].
-endif.
