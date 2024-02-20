const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // WHILE LOOPS
    // a basic while loop loops while an external condition is true
    var i: usize = 0;

    while (i < 3) {
        print("{}->", .{i});
        i += 1;
    }
    print("END\n", .{});

    // we can use a "continue expression" that executes when each loop completes
    i = 0;

    while (i < 3) : (i += 1) {
        print("{}->", .{i});
    }
    print("END\n", .{});

    // continue expressions can be more complex and expanded into a block
    i = 0;
    var j: usize = 10;

    while (i < 3) : ({
        i += 1;
        j *= 2;
    }) {
        print("i:{} j:{}->", .{ i, j });
    }
    print("END\n", .{});

    // we can use the `break` and `continue` keywords with labels
    i = 0;

    outer: while (true) : (i += 1) {
        while (i < 10) : (i += 1) {
            if (i == 4) continue :outer; // continue to the outer loop
            if (i == 6) break :outer; // break out of the outer look
            print("{}->", .{i});
        }
    }
    print("END\n", .{});

    // we can use a while loop as an expression
    const start: usize = 1;
    const end: usize = 20;
    i = start;
    const target: usize = 13;

    const in_range = while (i <= end) : (i += 1) {
        if (target == i) break true; // once n == i set in_range to true
    } else false; // otherwise in_range is false
    print("{} in {} to {}? {}\n", .{ target, start, end, in_range });

    // while with optional and capture
    count_down = 3;
    while (countDownIterator()) |val| print("{}->", .{val}); // while countDownIterator is not null, capture the value
    print("END\n", .{});
}

var count_down: usize = undefined;

fn countDownIterator() ?usize {
    return if (count_down == 0) null else lbl: { // if count_down == 0 return `null`
        count_down -= 1; // otherwise, decrement count_down and return it
        break :lbl count_down;
    };
}
