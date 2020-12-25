use std::fs;

fn count_trees(input: &[&str], right: usize, down: usize) -> i64 {
    let mut trees = 0;
    let mut index = down;
    let mut current_right = right;

    while index < input.len() {
        let is_tree = input[index]
            .chars()
            .nth(current_right % input[index].len())
            .unwrap()
            == '#';
        if is_tree {
            trees += 1;
        }

        index += down;
        current_right += right;
    }

    trees
}

fn main() {
    let filename = "./input.txt";
    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");
    let input: Vec<&str> = contents.split('\n').collect();

    let r1d1 = count_trees(&input, 1, 1);
    let r3d1 = count_trees(&input, 3, 1);
    let r5d1 = count_trees(&input, 5, 1);
    let r7d1 = count_trees(&input, 7, 1);
    let r1d2 = count_trees(&input, 1, 2);

    println!("Part 1: {}", r3d1);
    println!("Part 2: {}", r1d1 * r3d1 * r5d1 * r7d1 * r1d2);
}
