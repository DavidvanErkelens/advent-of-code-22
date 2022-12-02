<?php

declare(strict_types=1);

const OPPONENT_ROCK = 'A';
const OPPONENT_PAPER = 'B';
const OPPONENT_SCISSORS = 'C';

const ME_ROCK = 'X';
const ME_PAPER = 'Y';
const ME_SCISSORS = 'Z';

const SCORE_WIN = 6;
const SCORE_DRAW = 3;
const SCORE_LOSE = 0;

const GOAL_LOSE = 'X';
const GOAL_DRAW = 'Y';
const GOAL_WIN = 'Z';

const BEATS = [OPPONENT_ROCK => ME_PAPER, OPPONENT_PAPER => ME_SCISSORS, OPPONENT_SCISSORS => ME_ROCK];
const TO_PLAY = [
    OPPONENT_ROCK => [GOAL_LOSE => ME_SCISSORS, GOAL_DRAW => ME_ROCK, GOAL_WIN => ME_PAPER],
    OPPONENT_PAPER => [GOAL_LOSE => ME_ROCK, GOAL_DRAW => ME_PAPER, GOAL_WIN => ME_SCISSORS],
    OPPONENT_SCISSORS => [GOAL_LOSE => ME_PAPER, GOAL_DRAW => ME_SCISSORS, GOAL_WIN => ME_ROCK]
];

$lines = getLinesFromFile('input.txt');

$totalScore = 0;

foreach ($lines as $line) {
    [$opponent, $goal] = explode(' ', $line);
    $me = TO_PLAY[$opponent][$goal];
    $totalScore += processRound($opponent, $me);
}

printf("Total score: %d\n", $totalScore);


function getLinesFromFile(string $filename): array
{
    $path = __DIR__ . '/input/' . $filename;
    return array_map(
        static fn (string $input) =>  trim(str_replace(["\n", "\r"], "", $input)),
        file($path)
    );
}

function processRound(string $opponent, string $me): int
{
    $shapeScore = ord($me) - ord('W');

    if (ord($me) - ord($opponent) === 23) {
        return SCORE_DRAW + $shapeScore;
    }

    if (BEATS[$opponent] === $me) {
        return SCORE_WIN + $shapeScore;
    }

    return SCORE_LOSE + $shapeScore;
}

