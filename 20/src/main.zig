const std = @import("std");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const Item = struct {
    value: i64,
    index: usize
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const file = std.fs.cwd().openFile("input/input.txt", .{}) catch unreachable;
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var items = ArrayList(Item).init(allocator);

    var buf: [1024]u8 = undefined;
    var num_items: usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const parsedValue = fmt.parseInt(i64, line, 10) catch unreachable;
        try items.append(Item { .value = parsedValue * 811589153, .index = num_items });
        num_items += 1;
    }

    var itemArray = items.toOwnedSlice();

    var shuffled: u8 = 0;

    while (shuffled < 10) : (shuffled += 1) {

        std.debug.print("Doing shuffle {d}\n", .{shuffled});

        var itemsMoved: u16 = 0;
        var itemsToMove: u16 = @truncate(u16, itemArray.len);

        while (itemsMoved < itemArray.len) : (itemsMoved += 1) {
            var firstNonMovedIndex: u16 = 0;
            while (firstNonMovedIndex < itemsToMove) : (firstNonMovedIndex += 1) {
                if (itemArray[firstNonMovedIndex].index == itemsMoved) {
                    break;
                }
            }

            const itemToMove = itemArray[firstNonMovedIndex];
            const value = itemToMove.value;

            var nextIndex: i64 = firstNonMovedIndex + value;
            nextIndex = @mod(nextIndex, itemsToMove - 1);

            if (nextIndex == 0) {
                nextIndex = itemsToMove - 1;
            }

            const finalIndex = @intCast(usize, nextIndex);
            if (nextIndex == firstNonMovedIndex) {
                continue;
            }

            if (nextIndex > firstNonMovedIndex) {
                var indexToMove = firstNonMovedIndex + 1;
                while (indexToMove <= nextIndex) : (indexToMove += 1) {
                    itemArray[indexToMove - 1] = itemArray[indexToMove];
                }
            } else {
                var indexToMove = firstNonMovedIndex;
                while (indexToMove > finalIndex) : (indexToMove -= 1) {
                    itemArray[indexToMove] = itemArray[indexToMove - 1];
                }
            }

            itemArray[finalIndex] = itemToMove;
        }
    }

    std.debug.print("Getting 0...\n", .{});
    var indexOfZero: usize = 0;
    while (true) : (indexOfZero += 1) {
        if (itemArray[indexOfZero].value == 0) {
            break;
        }
    }

    const one = itemArray[(1000 + indexOfZero) % itemArray.len].value;
    const two = itemArray[(2000 + indexOfZero) % itemArray.len].value;
    const three = itemArray[(3000 + indexOfZero) % itemArray.len].value;
    std.debug.print("Sum: {d}\n", .{ one + two + three });
}
