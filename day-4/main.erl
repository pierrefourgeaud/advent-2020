-module(main).

main(_) ->
  Input = string:join(get_input(), ""),
  start(Input).

get_input() ->
  case io:get_line("") of
    eof ->
      [];
    Line ->
      [Line] ++ get_input()
  end.

start(Input) ->
  Passports = string:split(Input, "\n\n", all),
  Res = validate_passports(Passports, fun(F, P) -> check(F, P) end),
  io:fwrite("Part 1: ~p\n", [Res]),
  Res2 = validate_passports(Passports, fun(F, P) ->
    check(F, P) and check2(F, string:slice(P, 4, string:len(P)))
  end),
  io:fwrite("Part 2: ~p\n", [Res2]).

fields() -> [byr, iyr, eyr, hgt, hcl, ecl, pid, cid].

validate_passports([], _) -> 0;
validate_passports([Passport | Tail], Check) -> 
  SingleLinedPassport = string:replace(Passport, "\n", " ", all),
  PassportFields = string:split(SingleLinedPassport, " ", all),
  Res = case lists:all(fun(F) ->
    lists:any(fun(P) ->
      Check(F, P)
      end, PassportFields)
    end, fields()) of
    true -> 1;
    false -> 0
  end,
  Res + validate_passports(Tail, Check).

check(cid, _) -> true;
check(F, P) -> string:slice(P, 0, 3) =:= atom_to_list(F).

% Part 2
check2(cid, _) -> true;
check2(byr, P) when is_list(P), length(P) == 4 ->
  integer_in_range(string:to_integer(P), 1920, 2002);
check2(iyr, P) when is_list(P), length(P) == 4 ->
  integer_in_range(string:to_integer(P), 2010, 2020);
check2(eyr, P) when is_list(P), length(P) == 4 ->
  integer_in_range(string:to_integer(P), 2020, 2030);
check2(hgt, [P, cm]) ->
  integer_in_range(string:to_integer(P), 150, 193);
check2(hgt, [P, in]) ->
  integer_in_range(string:to_integer(P), 59, 76);
check2(hgt, P) when is_list(P) ->
  % I hate the double case but I don't know how to solve it otherwise
  case lists:suffix("in", P) of
    true -> check2(hgt, [string:substr(P, 1, string:len(P) - 2), in]);
    false -> case lists:suffix("cm", P) of
      true ->check2(hgt, [string:substr(P, 1, string:len(P) - 2), cm]);
      false -> false
    end
  end;
check2(hcl, "#" ++ P) ->
  case re:run(P, "^[0-9a-f]{6}$") of
    {match,_} -> true;
    _ -> false
  end;
check2(ecl, P) ->
  lists:member(P, ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]);
check2(pid, P) when is_list(P) ->
  case re:run(P, "^[0-9]{9}$") of
    {match, _} -> true;
    _ -> false
  end;
check2(_, _) -> false.

integer_in_range({I, _}, Min, Max) ->
  I >= Min andalso I =< Max.