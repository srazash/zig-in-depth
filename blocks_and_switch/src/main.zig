const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // BLOCKS AND SWITCH

    const a = 10;

    // a block defines a new scope
    {
        // everything in this block is only available within the block
        const x: u8 = 59 + a; // we can access variables outside the block
        print("x == {}\n", .{x});
    }

    // x is no longer in scope, so...
    //print("x == {}\n", .{x}); <- this will cause an error, because in this scope x is undeclared

    // blocks are expressions and can return a value using a label and the `break` keyword
    const x: u8 = lbl: { // we create a label by putting `:` on the end
        var y: u8 = 13;
        const z = 42;
        break :lbl y + z; // we break out to the label by using `:` again, but infront of the label
    };
    print("x == {}\n", .{x});

    // switches control application flow, similarly to if statements
    switch (x) {
        // we can use a range, which is defined with `...` between the values of the range
        0...20 => print("x is between 0 and 20\n", .{}), // different brances of the switch are seperated with `,`
        // we can combine multiple values as a possible branch
        21, 22, 23 => print("x is 21, 22 or 23\n", .{}),
        // we can capture the matching value on a branch
        24...30 => |n| print("x is {}\n", .{n}),
        // we can use a block for more complex branches
        31 => {
            const b = 21;
            print("x is {}\n", .{a + b});
        },
        // as long as it is know at comptime any expression can be a branch
        lbl: {
            const b1 = 28;
            const b2 = 4;
            break :lbl b1 + b2;
        } => print("x is 32\n", .{}),
        // `else` is the default is no other branches match
        // and is required if the other branches are non-exhaustive
        else => print("No match found, x is greater than 32\n", .{}),
    }

    // like `if`, switches can be used as an expression
    const c: u8 = switch (x) {
        0...50 => 1,
        51...69 => 2,
        70...255 => 3,
    };
    print("c is {}\n", .{c});
}
