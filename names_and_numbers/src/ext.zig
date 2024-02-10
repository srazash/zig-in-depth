const std = @import("std");
const m = @import("main.zig"); // import main.zig to access pi_val

// simple function that is `pub`
pub fn extTest() void {
    std.debug.print("Area of a circle with a radius on 5 = {any}\n", .{m.global_pi * (5 * 5)});
}
