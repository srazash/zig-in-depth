const std = @import("std");

// CODE GEN
// refer to build.zig and gen.zig for the code generation steps!

// import the generated Zig file, our code gen steps in build.zig guarantee this file is available!
const fib = @import("fib.zig").fib;

pub fn main() !void {
    for (&fib, 1..) |n, i| std.debug.print("fib {} -> {}\n", .{ i, n });
}
