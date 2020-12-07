import sys

input = sys.stdin.read().split("\n\n")


def process_group_anyone(grp):
    line = ""
    line = line.join(grp.split("\n"))
    # I would use an unordered_set in c++. Giving O(1) amortized for access and insert
    # and guaranty uniqueness. I am kinda rusty in python so I will use a dictionary...
    uniq = {}
    for c in line:
        uniq[c] = True

    return len(uniq)


def process_group_everyone(grp):
    ppl = grp.split("\n")
    answers = ppl.pop(0)
    for person in ppl:
        answers = set(answers).intersection(person)

        if len(answers) == 0:
            return 0

    return len(answers)


part1 = 0
part2 = 0
for grp in input:
    part1 += process_group_anyone(grp)
    part2 += process_group_everyone(grp)

print("Part 1: " + str(part1))
print("Part 2: " + str(part2))
