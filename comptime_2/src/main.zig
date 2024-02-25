const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // COMPTIME II

    // comptime expression evaluation
    // const values are comptime known as they cannot change during runtime
    const condition = false;

    // condition is comptime known, so it is evaluated at comptime
    if (condition) {
        @compileLog("condition is true");
    } else {
        @compileLog("condition is false");
    }
}
