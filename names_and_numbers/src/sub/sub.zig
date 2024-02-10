const std = @import("std");

pub fn echo(input: []const u8) void {
    std.debug.print("Echo: {s} {s} {s}\n", .{ input, input, input });
}
