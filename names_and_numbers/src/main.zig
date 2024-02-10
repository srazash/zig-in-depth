const std = @import("std");

// constant and variable names should be snake_case

// we can declare global constants and global variables
// these are declared outside of function bodies and can be accessed
// by any function in the file, these can be accessed from other files
// if they have the `pub` keyword
pub const pi_val: f64 = 3.14159; // const cannot be changed
const meaning_of_life: u8 = 42; // const ints will be `comptime int`
var apples_num: u8 = 69; // var can be changed

// function names should be camelCase
fn printTypeInfo(name: []const u8, x: anytype) void {
    std.debug.print("{s:>10} {any:^10}\t{}\n", .{ name, x, @typeInfo(x) });
}

pub fn main() !void {
    printTypeInfo("pi_val", pi_val);
    printTypeInfo("meaning_of_life", meaning_of_life);
    printTypeInfo("apples_num", apples_num);
}
