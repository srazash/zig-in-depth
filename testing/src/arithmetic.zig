const std = @import("std");
const testing = std.testing;

fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(45, 55) == 100);
}

fn sub(a: i32, b: i32) i32 {
    return a - b;
}

test "basic sub functionality" {
    try testing.expect(sub(18, 6) == 12);
}

fn mult(a: i32, b: i32) i32 {
    return a * b;
}

test "basic mult functionality" {
    try testing.expect(mult(10, 10) == 100);
}

fn div(a: i32, b: i32) i32 {
    return @divExact(a, b);
}

test "basic div functionality" {
    try testing.expect(div(21, 7) == 3);
}
