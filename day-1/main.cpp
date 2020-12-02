#include <iostream>
#include <fstream>
#include <unordered_set>
#include <unordered_map>
#include <tuple>
#include <vector>
#include <utility>

const int32_t toFind = 2020;

// Part 1
std::pair<int, int> GetPair(const std::vector<int32_t>& input, int32_t toSum) {
  std::unordered_set<int32_t> cache;

  for (const auto& current : input) {
    int32_t diff = toSum - current;
    auto res = cache.find(diff);

    if (cache.end() != res) {
      return {*res, current};
    }

    cache.insert(current);
  }

  return {0, 0};
}

// Part 2
// TODO(pierre) I want to redo that part. It was made in a hurry but I want to rework it
// at a later stage.
std::tuple<int32_t, int32_t, int32_t> GetPairFor3(const std::vector<int32_t>& input, int32_t toSum) {
  if (input.size() < 3) {
    return {0, 0, 0};
  }
  std::unordered_map<int32_t, std::pair<int32_t, int32_t>> cache;
  // auto pair = std::make_pair(input[0] + input[1]], std::make_pair(input[0], input[1]));
  cache[input[0] + input[1]] = {input[0], input[1]};

  for (int i = 2; i < input.size(); ++i) {
    int32_t diff = toSum - input[i];
    auto res = cache.find(diff);

    if (cache.end() != res) {
      return {res->second.first, res->second.second, input[i]};
    }

    // This is not optimal I gues but "meh"
    for (int j = 0; j < i; ++j) {
      cache[input[i] + input[j]] = {input[i], input[j]};
    }
  }

  return {0, 0, 0};
}

int main() {
  // Not check for input, we assume it is valid
  std::ifstream input("./input.txt");

  if (!input.is_open()) {
    std::cout << "Fail to find input file";
    return 1;
  }

  std::vector<int32_t> numbers;

  int32_t n;
  while (input >> n) {
    std::cout << n << std::endl;
    numbers.push_back(n);
  }

  auto pair = GetPair(numbers, toFind);
  auto t = GetPairFor3(numbers, toFind);

  std::cout << "Part 1: " << (pair.first * pair.second) << std::endl;
  std::cout << "Part 2: " << (std::get<0>(t) * std::get<1>(t) * std::get<2>(t)) << std::endl;
  return 0;
}