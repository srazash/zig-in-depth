const std = @import("std");
const print = @import("std").debug.print;

const Point = @import("point.zig").Point; // we now `@import` the Point function from `point.zig`

// COMPTIME
// comptime = compile time - anything marked as comptime must be know at compile time
// there can be no side effect that occur at runtime, eg. reading a file, printing to screen
// working with types is done at comptime, we can implement generics in Zig at comptime

// Point.zig currently only accepts f32 values, using comptime features in Zig we will
// implement a generic version of the struct, as part of this change `Point.zig` becomes
// `point.zig`, this aligns with Zig's naming standards: a struct with fields, functions/methods
// should start with a capital letter, but because our changes will make point operate like
// a function, it is now camelCase: Point -> point

pub fn main() !void {
    // we have to specify the type T -> `Point(f32)`
    //const a_point = Point(f32).new(0, 0);
    //const b_point = Point(f32).new(1, 1);

    // so we don't have to specify `Point(f32)` everytime we create a new point we can create
    // a constant to act as an alias by asssigning it a type
    //const P = Point(f32);
    //const P = Point(f16); // because the Point function is generic we can assign another data type
    const P = Point(i8);
    const a_point: P = P.new(0, 0);
    const b_point: P = P.new(1, 1); // we can even assign it as a type directly

    print("distance -> {d:.1}\n", .{a_point.distance(b_point)});
    print("type of a_point -> {}\n", .{@TypeOf(a_point)});
}
