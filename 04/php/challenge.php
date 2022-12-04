<?php

declare(strict_types=1);

$lines = getLinesFromFile('input.txt');

$counter = 0;

foreach ($lines as $line) {
    [$one, $two] = explode(',', $line);
//    if (fullyContains($one, $two) || fullyContains($two, $one)) {
//        $counter += 1;
//    }
    if (overlaps($one, $two)) {
        $counter += 1;
    }
}

printf("Counted pairs: %d\n", $counter);

// ...XXXXXXX....
// .....XXXX.....
function fullyContains($lh, $rh): bool
{
    [$startOne, $endOne] = explode('-', $lh);
    [$startTwo, $endTwo] = explode('-', $rh);

    return $startOne <= $startTwo && $endOne >= $endTwo;
}

// ....XXXXX
// ..XXXX...

// .XXXX...
// ....XXXX
function overlaps($lh, $rh): bool
{
    [$startOne, $endOne] = explode('-', $lh);
    [$startTwo, $endTwo] = explode('-', $rh);

    return ($startOne >= $startTwo && $startOne <= $endTwo) || ($startTwo >= $startOne && $startTwo <= $endOne);
}

function getLinesFromFile(string $filename): array
{
    $path = __DIR__ . '/input/' . $filename;
    return array_map(
        static fn (string $input) =>  trim(str_replace(["\n", "\r"], "", $input)),
        file($path)
    );
}
