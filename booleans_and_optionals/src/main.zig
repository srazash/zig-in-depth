const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // BOOLEANS AND OPTIONALS
    // booleans (`bool`) can be either `true` or `false`
    const t: bool = true;
    const f: bool = false;
    // bools can be convered to integers, where true == 1 and false == 0
    print("true: {}, false: {}\n", .{ @intFromBool(t), @intFromBool(f) });

    // optionals allow us to make variables nullable
    // only variables marked as optional can be assigned a NULL value
    // we mark a variable as an optional by prepending the type with a `?` operator
    // NOTE: any type can be marked as optional
    var maybe_byte: ?u8 = null;
    //var cannot_be_null: u8 = null; <- will cause a compiler error
    print("maybe_byte: {?}\n", .{maybe_byte});
    maybe_byte = 69;
    print("maybe_byte: {?}\n", .{maybe_byte});

    // we can also use the `?` operator to assert an optional is not null and extract it's value
    var not_null = maybe_byte.?; // if maybe_byte was null this would cause an error

    // a safer way to assert a value is not null is to use `orelse` to set a default value if what is being evaluated is null
    not_null = maybe_byte orelse 0; // if maybe_byte was null it would set not_null to 0

    // we can control application flow using an if statement with bools and optionals
    if (t) {
        print("True: {}\n", .{t});
    } else if (f) {
        print("False: {}\n", .{f});
    } else {
        print("None of the above\n", .{});
    }

    // we can capture the payload of an optional if it is not null
    if (maybe_byte) |b| {
        print("maybe_byte is {}\n", .{@TypeOf(b)});
    } else {
        print("maybe_byte is null\n", .{});
    }

    // we can also discard the payload and simply evaluate if a value is not null
    // our if statements can be on a single line if we only need to peform a single operation after evaluation
    if (maybe_byte) |_| print("maybe_byte is not null\n", .{});

    // we can check if an optional is equal to null, we can only do this with optionals!
    if (maybe_byte == null) print("maybe_byte is nill\n", .{});

    // we also have the option of using an if expression
    // this is Zig's version of a ternary operator
    not_null = if (maybe_byte) |b| b else 0; // this function identically to our `orelse` above

    // when using an if expression we cannot use the `{ . . . }` brackets for each branch
    // but we can break the expression out over multiple lines
    not_null = if (maybe_byte != null and maybe_byte.? == 42)
        42 * 2
    else
        0;

    print("not_null = {}\n", .{not_null});
}
