const std = @import("std");
const m = @import("main.zig"); // import main.zig to access pi_val

// simple function that is `pub`
pub fn extTest() void {
    std.debug.print("Area of a circle with a radius on 5 = {d:.5}\n", .{areaCircle(5)});
    compareMyPi(m.global_pi);
}

fn areaCircle(radius: f64) f64 {
    return std.math.pi * (std.math.pow(f64, radius, 2.0));
}

fn compareMyPi(my_pi: f64) void {
    if (my_pi > std.math.pi) {
        std.debug.print("*my_pi* - std.math.pi = {d}\n", .{my_pi - std.math.pi});
    } else {
        std.debug.print("*std.math.pi* - my_pi = {d}\n", .{std.math.pi - my_pi});
    }
}
