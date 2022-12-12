extern crate core;

mod hand;
mod strategy;

use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;
use crate::hand::Hand;
use crate::strategy::Strategy;

const SCORE_WIN: i32 = 6;
const SCORE_DRAW: i32 = 3;
const SCORE_LOSE: i32 = 0;

fn main() {
    let lines = read_file_lines("input/input.txt");
    let mut score = 0;
    for line in lines {
        let mut items = line.split(" ");
        let opponent = Hand::from(items.next().unwrap());
        // let me = Hand::from(items.next().unwrap());
        let strategy = Strategy::from(items.next().unwrap());
        let me = Hand::for_strategy(&strategy, &opponent);
        score += get_score(&me, &opponent)
    }

    println!("The total score is {}", score);
}

fn read_file_lines(filename: &str) -> Vec<String> {
    let path = Path::new(filename);
    let file = File::open(path);

    if let Ok(file_handle) = file {
        return BufReader::new(file_handle)
            .lines()
            .map(|l| l.expect("Could not parse line"))
            .collect();
    }

    panic!("Could not read file!")
}

fn get_score(me: &Hand, other: &Hand) -> i32 {
    let hand_score = me.get_hand_score();

    if me.does_beat(other) {
        return hand_score + SCORE_WIN;
    }

    if me.eq(other) {
        return hand_score + SCORE_DRAW;
    }

    return hand_score + SCORE_LOSE;
}

