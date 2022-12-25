<?php

declare(strict_types=1);

$lines = getLinesFromFile('input.txt');
$sum = 0;

foreach ($lines as $line)
{
    $digits = str_split($line);
    $value = 0;
    foreach ($digits as $index => $digit) {
        $offset = count($digits) - $index - 1;
        $value += (5 ** $offset) * snafu_to_regular($digit);
    }
    printf("%s has value %d\n", $line, $value);
    $sum += $value;
}

echo regular_to_snafu($sum);

function snafu_to_regular(string $snafu): int {
    return match ($snafu) {
        '=' => -2,
        '-' => -1,
        default => (int) $snafu
    };
}

function regular_to_snafu(int $regular): string
{
    $base5 = base_convert((string) $regular, 10, 5);
    $digits = array_map('intval', str_split($base5));

    for ($i = count($digits) - 1; $i >= 0; $i--) {
        if ($i > 0) {
            if ($digits[$i] > 2) {
                $digits[$i - 1] += 1;
                $digits[$i] -= 5;
            }
        } else {
            if ($digits[$i] > 2) {
                array_unshift($digits, 1);
                $digits[$i] -= 5;
            }
        }
    }

    $digits = array_map('digit_to_snafu', $digits);
    return implode('', $digits);
}

function digit_to_snafu(int $digit): string {
    return match ($digit) {
        -2 => '=',
        -1 => '-',
        default => (string) $digit
    };
}

function getLinesFromFile(string $filename): array
{
    $path = __DIR__ . '/input/' . $filename;
    return array_map(
        static fn (string $input) =>  trim(str_replace(["\n", "\r"], "", $input)),
        file($path)
    );
}
