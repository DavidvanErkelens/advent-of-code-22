import * as fs from 'fs';

const input: string = fs.readFileSync('input/input.txt', 'utf8');

// Part 1:
// const uniqueCharsRequired: number = 4;

// Part 2:
const uniqueCharsRequired: number = 14;

for (let i: number = 0; i < input.length - uniqueCharsRequired; i++) {
    const substr: string = input.substr(i, uniqueCharsRequired);
    const set: Set<string> = new Set(substr.split(''));
    if (set.size === uniqueCharsRequired) {
        console.log(`We have ${uniqueCharsRequired} unique items after reading ${i+uniqueCharsRequired} characters. The substring is '${substr}'`);
        break;
    }
}