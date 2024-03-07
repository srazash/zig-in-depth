const std = @import("std");

// import the dependency
const ziglyph = @import("ziglyph");

pub fn main() !void {
    // BUILD DEPENDENCIES
    // review `build.zig.zon` and `build.zig`
    // call on ziglyph to return a lowercase unicode character to the format string
    std.debug.print("{u}\n", .{ziglyph.toLower('A')});
}
