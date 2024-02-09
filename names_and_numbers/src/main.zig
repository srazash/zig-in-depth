const std = @import("std");

// constant and variable names should be snake_case

// we can declare global constants and global variables
const pi_val: f64 = 3.14159; // const cannot be changed
var number_of_apples: u8 = 69; // var can be changed

// function names should be camelCase
fn printTypeInfo(name: []const u8, x: anytype) void {
    std.debug.print("{s:>10} {any:^10}\t{}\n", .{ name, x, @TypeOf(x) });
}

pub fn main() !void {}
