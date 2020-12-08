// Not really happy about this solution.
// Probably using a proper graph I could have done the parsing
// once and using the traverse functions to complete part 1 or 2...
// But it was the very first time using D, I might try to solve it
// more efficiently later on.
import std.stdio : writeln, stdin;
import std.array : array, split, join;
import std.typecons : Tuple, tuple;
import std.conv : to;

string getColor(string input)
{
  switch (input)
  {
  case "no other bags.":
    return "";
  default:
    return input.split(" ")[1 .. $ - 1].join(" ");
  }
}

Tuple!(string, int) getColorAndNumberOfBags(string input)
{
  switch (input)
  {
  case "no other bags.":
    return tuple("", 0);
  default:
    auto temp = input.split(" ");
    return tuple(temp[1 .. $ - 1].join(" "), to!int(temp[0]));
  }
}

ulong part1(string[] ar)
{
  string[][string] acc;

  foreach (string line; ar)
  {
    string[] temp = line.split(" bags contain ");
    string[] contained = temp[1].split(", ");
    foreach (string a; contained)
    {
      string color = getColor(a);
      if (!(temp[0] in acc))
      {
        acc[temp[0]] = [];
      }

      if (color in acc)
      {
        acc[color] ~= temp[0];
      }
      else
      {
        acc[color] = [temp[0]];
      }
    }
  }

  byte[string] res;
  void traverse(string[] directParents)
  {
    foreach (parent; directParents)
    {
      res[parent] = 1;
      traverse(acc[parent]);
    }
  }

  traverse(acc["shiny gold"]);
  return res.length;
}

ulong part2(string[] ar)
{
  Tuple!(string, int)[][string] acc;

  foreach (string line; ar)
  {
    string[] temp = line.split(" bags contain ");
    string[] contained = temp[1].split(", ");
    acc[temp[0]] = [];
    foreach (string a; contained)
    {
      auto t = getColorAndNumberOfBags(a);
      if (t[1] != 0)
      {
        acc[temp[0]] ~= t;
      }
    }
  }

  ulong traverse(Tuple!(string, int)[] bags)
  {
    ulong res = 1;
    foreach (bag; bags)
    {
      res += bag[1] * traverse(acc[bag[0]]);
    }

    return res;
  }

  return traverse(acc["shiny gold"]) - 1;
}

void main()
{
  string[] ar = stdin.byLineCopy().array();

  writeln("Part 1: ", part1(ar));
  writeln("Part 2: ", part2(ar));
}
