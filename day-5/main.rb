input = STDIN.read.split("\n")

def get_num(seat, low, high, max)
  min = 0

  seat.each_char {|c|
    h = ((max - min) / 2)
    if c == low
      max -= h + 1
    elsif c == high
      min += h + 1
    end
  }

  min
end

# Part 1: I use memoization because it is technically nicer than to have to store
# the array - Especially if the number would be big (considering the problem being an airplane
# the array shouldn't be big but still...). Considering the part two where I use an array sort,
# I could simply take the last element and it would be the answer.
#
# Part 2: I haven't investigated some of the mathematical properties but I am wondering if it
# couldn't be solved with a xor or some clever +/-.
def process_input(input)
  highest = 0
  arr = []
  input.each {|seat|
    # val = get_row(seat[0..6]) * 8 + get_col(seat[7..9])
    val = get_num(seat[0..6], 'F', 'B', 127) * 8 + get_num(seat[7..9], 'L', 'R', 7)
    arr.push(val)
    highest =[highest, val].max
  }
  # There are smarter ways but eh...
  arr = arr.sort()
  i = 1
  missing = 0
  while i < arr.size()
    if arr[i] - arr[i - 1] > 1
      missing = arr[i] - 1
      break
    end
    i = i + 1
  end
  return highest, missing
end

highest, missing = process_input(input)
puts "Part 1: #{highest}"
puts "Part 1: #{missing}"