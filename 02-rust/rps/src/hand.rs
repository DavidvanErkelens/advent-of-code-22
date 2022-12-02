use crate::strategy::Strategy;

use std::collections::HashMap;

#[derive(Debug, PartialEq, Eq, Hash, Clone)]
pub enum Hand {
    Rock,
    Paper,
    Scissors
}

impl Hand {
    pub fn from(str: &str) -> Hand {
        match str {
            "A" | "X" => Hand::Rock,
            "B" | "Y" => Hand::Paper,
            "C" | "Z" => Hand::Scissors,
            _ => panic!("not possible")
        }
    }

    pub fn for_strategy(strategy: &Strategy, other: &Hand) -> Hand {
        match strategy {
            Strategy::Lose => other.beats(),
            Strategy::Draw => other.clone(),
            Strategy::Win => other.is_beaten_by()
        }
    }

    pub fn does_beat(&self, other: &Hand) -> bool {
        self.beats().eq(other)
    }

    pub fn get_hand_score(&self) -> i32 {
        match self {
            Hand::Rock => 1,
            Hand::Paper => 2,
            Hand::Scissors => 3
        }
    }

    fn beats(&self) -> Hand {
        match self {
            Hand::Rock => Hand::Scissors,
            Hand::Paper => Hand::Rock,
            Hand::Scissors => Hand::Paper
        }
    }

    fn is_beaten_by(&self) -> Hand {
        match self {
            Hand::Rock => Hand::Paper,
            Hand::Paper => Hand::Scissors,
            Hand::Scissors => Hand::Rock
        }
    }
}
