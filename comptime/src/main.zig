const std = @import("std");
const print = @import("std").debug.print;

const Point = @import("Point.zig");

pub fn main() !void {
    // COMPTIME
    const a_point = Point.new(0, 0);
    const b_point = Point.new(1, 1);

    print("distance -> {d:.1}\n", .{a_point.distance(b_point)});
    print("type of a_point -> {}\n", .{@TypeOf(a_point)});
}
