<?php

declare(strict_types=1);

const DEBUG = true;

$lines = getLinesFromFile('input.txt');
$sum = 0;

// Part 1:
//foreach ($lines as $line)
//{
//    [$front, $back] = splitLine($line);
//    $sharedItem = array_values(array_unique(array_intersect(str_split($front), str_split($back))))[0];
//    $score = getItemScore($sharedItem);
////    var_dump($sharedItem);
//    debugPrint("Common item is %s, with a score of %d\n", $sharedItem, $score);
//    $sum += $score;
//}

do {
    $elfOne = array_shift($lines);
    $elfTwo = array_shift($lines);
    $elfThree = array_shift($lines);

    $sharedItem = array_values(array_unique(array_intersect(str_split($elfOne), str_split($elfTwo), str_split($elfThree))))[0];
    $score = getItemScore($sharedItem);

    $sum += $score;
} while(!empty($lines));

printf("Total score: %d\n", $sum);


function splitLine(string $line): array
{
    $length = strlen($line);
    return str_split($line, $length / 2);
}

function getItemScore(string $item): int
{
    if (ctype_upper($item)) {
        return ord($item) - ord('A') + 27;
    }

    return ord($item) - ord('a') + 1;
}

function getLinesFromFile(string $filename): array
{
    $path = __DIR__ . '/input/' . $filename;
    return array_map(
        static fn (string $input) =>  trim(str_replace(["\n", "\r"], "", $input)),
        file($path)
    );
}

function debugPrint(string $format, mixed ...$values): void
{
    if (DEBUG) {
        printf($format, ...$values);
    }
}
