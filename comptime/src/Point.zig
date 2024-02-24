const std = @import("std");

// Point.zig is almost a direct copy of the Point struct in main.zig
// and it will function the same way as the Point struct
// except for a couple of differences:

x: f32,
y: f32 = 0,

// we need to use the @This() built-in
// in a regular struct we declare `const <Name> = struct { ... }`
// Zig is able to take the `<Name>` we assign the struct and reference the structs fields, functions and methods
// when we create a file like Point.zig we need a way to tell Zig that our fields, functions and methods relate
// to "Point", and we do this with @This()
const Point = @This();

// we need to make our functions and methods `pub` so they are accessible outside of this file
pub fn new(x: f32, y: f32) Point {
    return .{ .x = x, .y = y };
}

pub fn distance(self: Point, dst: Point) f32 {
    const diffx = dst.x - self.x;
    const diffy = dst.y - self.y;
    return @sqrt(std.math.pow(f32, diffx, 2.0) + std.math.pow(f32, diffy, 2.0));
}
