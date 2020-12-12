package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func ParseLine(input string) (string, byte, int, int) {
	// The following do the parsing. It considers only valid input.
	// The format is: n1-n2 char: pwd.
	// Our simple parsing will do:
	//
	// 1. split by ':' giving: "n1-n2 char" and "pwd"
	// 2. split the left hand side by space giving: "n1-n2" and "char"
	// 3. split the left hand side by '-' giving: "n1" and "n2".
	// 4. n1 and n2 should be converted to integers.

	strs := strings.Split(input, ":")
	pwd := strs[1]

	strs = strings.Split(strs[0], " ")
	char := strs[1][0]

	strs = strings.Split(strs[0], "-")
	n1, err := strconv.Atoi(strs[0])
	check(err)
	n2, err := strconv.Atoi(strs[1])
	check(err)

	return pwd, char, n1, n2
}

// Part 1
func IsValid(input string) bool {
	pwd, char, n1, n2 := ParseLine(input)

	count := 0
	for _, c := range pwd {
		if byte(c) == char {
			count++
		}
	}

	return count >= n1 && count <= n2
}

// Part 2
func IsValid2(input string) bool {
	pwd, char, n1, n2 := ParseLine(input)

	if pwd[n1] == char && pwd[n2] != char {
		return true
	}

	if pwd[n1] != char && pwd[n2] == char {
		return true
	}

	return false
}

func main() {
	input, err := ioutil.ReadFile("./input.txt")
	check(err)

	lines := strings.Split(string(input), "\n")

	valid := 0
	valid2 := 0
	for _, line := range lines {
		if IsValid(line) {
			valid++
		}

		if IsValid2(line) {
			valid2++
		}
	}

	fmt.Println("Part 1:", valid)
	fmt.Println("Part 2:", valid2)
}
