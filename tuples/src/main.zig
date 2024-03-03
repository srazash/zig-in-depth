const std = @import("std");

pub fn main() !void {
    // TUPLES
    // tuples are like an anonymous struct

    // define a tuple typed constant
    const tuple_a: struct { u8, bool } = .{ 69, true };
    std.debug.print("tuple_a: {any}, {}\n", .{ tuple_a, @TypeOf(tuple_a) });
}
