const std = @import("std");
const testing = std.testing;

export fn calc(a: i32, b: i32) i32 {
    return add(a, b);
}

fn add(a: i32, b: i32) i32 {
    return a +% b; // wrapping overflow
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
