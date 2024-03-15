const std = @import("std");
const testing = std.testing;

export fn calc(a: i32, b: i32) i32 {
    return sub(a, b);
}

fn sub(a: i32, b: i32) i32 {
    return a -% b; // wrapping overflow
}

test "basic add functionality" {
    try testing.expect(sub(10, 3) == 7);
}
