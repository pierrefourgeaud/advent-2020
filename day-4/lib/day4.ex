defmodule Day4 do
  @fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]

  def main(_) do
    passports = IO.read(:stdio, :all)
      |> String.split("\n\n")

    IO.puts("Part 1: #{validate_passports(passports, &check/2)}")
    IO.puts("Part 2: #{validate_passports(passports, fn f, p ->
      check(f, p) && check2(f, String.slice(p, 4..-1))
    end)}")
  end

  # Part 1
  defp validate_passports([], _), do: 0
  defp validate_passports([passport | tail], fn_check) do
    pfields = String.split(String.replace(passport, "\n", " "))

    valid = Enum.all?(@fields, fn f ->
      Enum.any?(pfields, fn p ->
        fn_check.(f, p)
      end)
    end)

    num = if valid, do: 1, else: 0

    num + validate_passports(tail, fn_check)
  end

  defp check(:cid, _), do: :true
  defp check(f, p), do: String.starts_with?(p, Atom.to_string(f))

  # Part 2
  defp check2(:cid, _), do: :true
  defp check2(:byr, p) when is_bitstring(p) and byte_size(p) == 4,
    do: String.to_integer(p) |> integer_in_range(1920, 2002)
  defp check2(:iyr, p) when is_bitstring(p) and byte_size(p) == 4,
    do: String.to_integer(p) |> integer_in_range(2010, 2020)
  defp check2(:eyr, p) when is_bitstring(p) and byte_size(p) == 4,
    do: String.to_integer(p) |> integer_in_range(2020, 2030)
  defp check2(:hgt, <<p::binary-size(3)>> <> "cm"),
    do: String.to_integer(p) |> integer_in_range(150, 193)
  defp check2(:hgt, <<p::binary-size(2)>> <> "in"),
    do: String.to_integer(p) |> integer_in_range(59, 76)
  defp check2(:hcl, "#" <> p), do: String.match?(p, ~r/^[0-9a-f]{6}$/)
  defp check2(:ecl, p) when p in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], do: :true
  defp check2(:pid, p) when is_bitstring(p), do: String.match?(p, ~r/^[0-9]{9}$/)
  defp check2(_, _), do: :false

  defp integer_in_range(i, min, max), do: i >= min && i <= max
end
