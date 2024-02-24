const std = @import("std");

// Point becomes a function, take a parameter that is a type, and returns a type
// specifically we mark the parameter as `comptime` to ensure it is known at compile time
// because we return a type our function name starts with an uppercase letter
pub fn Point(comptime T: type) type {
    return struct {
        const Self = @This(); // const Point becomes const Self

        // our fields are now of type T
        x: T = 0,
        y: T = 0,

        // parameters are now of type T, and we return Self
        pub fn new(x: T, y: T) Self {
            return .{ .x = x, .y = y };
        }

        // parameters are now Self, and we return type T
        pub fn distance(self: Self, dst: Self) T {
            const diffx = dst.x - self.x;
            const diffy = dst.y - self.y;
            return @sqrt(std.math.pow(T, diffx, 2) + std.math.pow(T, diffy, 2));
        }
    };
}
