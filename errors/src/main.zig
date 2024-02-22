const std = @import("std");
const print = @import("std").debug.print;

// ERRORS

// an error set is similar to an enum but contains errors
const InputError = error{
    EmptyInput,
};

// we can have as many error sets as we need
const NumberError = error{ InvalidCharacter, Overflow };

// we can merge error sets with the `||` operator
const ParseError = InputError || NumberError;

// the return type of this function is an ERROR UNION, which is defined by
// defining the return type as `<error>!<return>`
fn parseNumber(s: []const u8) ParseError!u8 {
    if (s.len == 0) return error.EmptyInput;
    return std.fmt.parseInt(u8, s, 10);
}

// main also returns an error union
// no error set defined before `!` means any error
// but we could specify ParseError!void
pub fn main() !void {
    const input = "212";

    var result = parseNumber(input);
    print("type of result -> {}\n", .{@TypeOf(result)});
    print("result -> {!}\n", .{result});

    print("\n", .{});

    // we can `catch` an error and provide a default value should an error occur
    result = parseNumber(input) catch 0; // here is an error occured result would be given 0
    print("result -> {!}\n", .{result});

    print("\n", .{});

    // we can capture errors caught with `catch` an error and use a `switch` to handle different errors
    result = parseNumber(input) catch |err| switch (err) {
        error.EmptyInput => ei: {
            print("Empty imput not allowed, returning 0.\n", .{});
            break :ei 0;
        },
        else => |e| return e, // if it's any other type of error, return the error
    };
    print("result -> {!}\n", .{result});

    print("\n", .{});

    // we can use `catch` with `unreachable` to ignore the error if it is never going to occur
    result = parseNumber("100") catch unreachable; // this line will never error, as "100" will always parse to an int, unreachable will generate an error in the compiler if it does occur
    print("result -> {!}\n", .{result});

    print("\n", .{});

    // we can use `catch` and pass the error to the caller
    result = parseNumber(input) catch |err| return err;
    // Zig has a keyword to do this without needing to capture and return the error: `try`
    result = try parseNumber(input);
    print("result -> {!}\n", .{result});

    print("\n", .{});

    // we can use an if statement to capture and handle an error union
    if (parseNumber(input)) |num| { // capture the value
        print("result -> {}\n", .{num});
    } else |err| { // capture the error
        print("error -> {!}\n", .{err});
    }

    print("\n", .{});

    // while loops can also be used with error unions
    count_down = 3;

    while (countDownIterator()) |num| { // capture the value
        print("{}->", .{num});
    } else |err| { // capture the error
        print("error-> {!}", .{err});
    }

    print("\n", .{});
}

var count_down: usize = undefined;

// instead of using an error set, here we have an error union that can return `anyerror`
fn countDownIterator() anyerror!usize {
    return if (count_down == 0) error.ReachedZero else lbl: {
        count_down -= 1;
        break :lbl count_down;
    };
}
