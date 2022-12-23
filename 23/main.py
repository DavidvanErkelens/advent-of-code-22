def do_round(elves, r):
    proposed_moves = {}
    moved = 0
    for elfid, elf in elves.items():
        other_elves = [x for other_id, x in elves.items() if abs(x[0] - elf[0]) <= 1 and abs(x[1] - elf[1]) <= 1 and elfid != other_id]
        if len(other_elves) == 0:
            continue

        blocking_elves = [
            [x for x in other_elves if x[1] == elf[1] - 1 and abs(x[0] - elf[0]) <= 1],
            [x for x in other_elves if x[1] == elf[1] + 1 and abs(x[0] - elf[0]) <= 1],
            [x for x in other_elves if x[0] == elf[0] - 1 and abs(x[1] - elf[1]) <= 1],
            [x for x in other_elves if x[0] == elf[0] + 1 and abs(x[1] - elf[1]) <= 1]
        ]

        moves = [
            (elf[0], elf[1] - 1),
            (elf[0], elf[1] + 1),
            (elf[0] - 1, elf[1]),
            (elf[0] + 1, elf[1])
        ]

        for i in range(4):
            if len(blocking_elves[(i + r) % 4]) == 0:
                proposed_moves[elfid] = moves[(i + r) % 4]
                break

    all_moves = list(proposed_moves.values())
    for elfid, move in proposed_moves.items():
        if all_moves.count(move) == 1:
            elves[elfid] = move
            moved += 1

    return moved


def count_empty_fields(elves):
    xs = [x[0] for x in elves.values()]
    ys = [x[1] for x in elves.values()]
    width = max(xs) - min(xs) + 1
    height = max(ys) - min(ys) + 1
    print(width, height)
    return width * height - len(elves)


if __name__ == '__main__':
    f = open('input/input.txt', 'r')
    lines = f.read().split('\n')

    elves = {}

    for y, line in enumerate(lines):
        print(line)
        for x, char in enumerate(list(line)):
            if char == '#':
                elves[len(elves)] = (x, y)

    for r in range(10000): # change to 10 for part 1
        moved = do_round(elves, r)
        print("moved " + str(moved) + " in round " + str(r + 1))
        if moved == 0:
            break
    fields = count_empty_fields(elves)
    print(fields)



