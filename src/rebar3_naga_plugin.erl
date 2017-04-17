-module(rebar3_naga_plugin).

-behaviour(provider).

-export([init/1,
         do/1,
         format_error/1]).

-define(PROVIDER, compile).
-define(DEPS, [{default, compile}]).


%% ===================================================================
%% Public API
%% ===================================================================

-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
-spec do(rebar_state:t())   -> {ok, rebar_state:t()} | {error, string()}.
-spec format_error(any())   -> iolist().


init(State) ->
    Info = [{name, ?PROVIDER},
            {module, ?MODULE},
            {namespace, naga},
            {bare, false},
            {deps, ?DEPS},
            {example, "rebar3 naga compile"},
            {short_desc, "Compile naga apps."},
            {desc, "Compile naga apps."},
            {opts, []}],
    State1 = rebar_state:add_provider(State, providers:create(Info)),
    {ok, State1}.

do(State) ->
    rebar_api:info("Running naga...", []),
    Apps = case rebar_state:current_app(State) of
               undefined ->
                   rebar_state:project_apps(State);
               AppInfo ->
                   [AppInfo]
           end,

    rebar_api:info("Apps ~p", [Apps]),
           
    [begin
         Opts    = rebar_app_info:opts(AppInfo),
         Dir     = rebar_app_info:dir(AppInfo),
         OutDir  = rebar_app_info:ebin_dir(AppInfo),
         DtlOpts = proplists:unfold(rebar_opts:get(Opts, erlydtl_opts, [])),

         rebar_api:info("DtlOpts ~p", [DtlOpts]),

     end || AppInfo <- Apps],

    {ok, State}.


format_error(Reason) -> io_lib:format("~p", [Reason]).

%% ===================================================================
%% Internal functions
%% ===================================================================


