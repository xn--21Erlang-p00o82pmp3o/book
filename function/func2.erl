-module(func2).
-compile({no_auto_import, [apply/2]}).

-export([test/0]).


subst(_, []) ->
    none;
subst(K, [{K, V}|_]) ->
    {ok, V};
subst(K, [_|T]) ->
    subst(K, T).


apply(Expr, Env)
  when is_atom(Expr) ->
    {ok, Value} = subst(Expr, Env),
    {Value, Env};
apply([H|T], Env) ->
    {Fun, Env1} = apply(H, Env),
    call(Fun, T, Env1).


call({fn, quote}, [X], Env) ->
    {{data, X}, Env}.


new_env() ->
    [{quote, {fn, quote}}].


id(X) ->
    X.


test(id) ->
    a = id(a),
    a = id(id(a));
test(quote) ->
    {{data, a}, _} =
        apply([quote, a], new_env()),
    {{data, [quote, a]}, _} =
        apply([quote, [quote, a]], new_env()).


test() ->
    test(id),
    test(quote),
    ok.