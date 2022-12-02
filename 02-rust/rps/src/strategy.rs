pub enum Strategy {
    Lose,
    Draw,
    Win
}

impl Strategy {
    pub fn from(str: &str) -> Strategy {
        match str {
            "X" => Strategy::Lose,
            "Y" => Strategy::Draw,
            "Z" => Strategy::Win,
            _ => panic!("not possible")
        }
    }
}
