const std = @import("std");
const print = @import("std").debug.print;

// enums auto-asign integer values starting at 0
// enums use the smallest possible unsigned integer type to do this
const Colour = enum {
    // const Colour = enum(u8) { <- it is possible to manually type our enums
    red, // 0
    green, // 1
    blue, // 2

    // enums can contain namespace functions (otherwise called a method)
    fn isRed(self: Colour) bool {
        return self == .red;
    }
};

pub fn main() !void {
    // ENUM & UNION
    //

}
