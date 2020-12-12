BEGIN {
   FS="[- ]|(: )";
   RS="\n";
}
{
  # Part2
  split($4,a,"")
  if (a[$1] == $3 && a[$2] != $3) {valid2++}
  if (a[$1] != $3 && a[$2] == $3) {valid2++}

  # Part1
  c = gsub($3, "", $4)
  if (c >= $1 && c <= $2) {valid++}
}
END {
  printf "Part 1: " valid "\n"
  printf "Part 2: " valid2 "\n"
}