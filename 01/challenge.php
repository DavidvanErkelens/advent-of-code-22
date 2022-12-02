<?php
// just because you can doesn't mean you should =D
echo array_sum(array_slice(call_user_func(static function($array) { rsort($array); return $array; }, array_map(static fn ($elfList) =>  array_sum(explode("\n", $elfList)), explode("\n\n", file_get_contents(__DIR__ . '/input/input.txt')))), 0, 3));
