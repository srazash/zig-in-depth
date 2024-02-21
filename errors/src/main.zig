const std = @import("std");
const print = @import("std").debug.print;

// ERRORS

// an error set is similar to an enum but contains errors
const InputError = error{
    EmptyInput,
};

// we can have as many error sets as we need
const NumberError = error{
    InvalidCharacter,
    Overflow,
};

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
pub fn main() !void {
    const input = "212";

    var result = parseNumber(input);
    print("type of result -> {}\n", .{@TypeOf(result)});
    print("result -> {!}\n", .{result});

    print("\n", .{});

    // we can `catch` an error

}
