const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

// TESTING
// it is good practive to have tests close to what is being tested
fn add(a: i32, b: i32) i32 {
    return a + b;
}

// tests are defined with the `test` keyword
// we give a string literal describing the test, this will be printed as part of the
// test process to indicate which test is running or has passed/failed
test "basic add functionality" {
    try testing.expect(add(3, 7) == 10); // we can test a function using `testing.expect()`
    // given our function we expect it to match this output, so if `add(3, 7)` gives us 10,
    // the test passes otherwise it simply fails
}

fn sub(a: i32, b: i32) i32 {
    return a - b;
}

test "basic sub functionality" {
    try testing.expect(sub(3, 7) == -4);
}

const Foo = struct {
    a: bool,
    b: u8,
    c: []const usize,
    d: []const u8, // string

    fn new(flag: bool) Foo {
        return if (flag) .{
            .a = true,
            .b = 1,
            .c = &[_]usize{ 1, 2, 3 },
            .d = "Hello",
        } else .{
            .a = false,
            .b = 0,
            .c = &[_]usize{ 9, 8, 7 },
            .d = "Goodbye",
        };
    }

    // we can have tests inside of a struct
    test "inside foo" {
        try testing.expect(true);
    }
};

// `std.testing` has many other tests we can use
test "new foo: true" {
    const foo = Foo.new(true); // we can declare consts and variables inside a test

    // and we can have multiple tests within a single test block
    try testing.expect(foo.a); // simple boolean test
    try testing.expectEqual(@as(u8, 1), foo.b); // equality test
    try testing.expectEqualSlices(usize, &[_]usize{ 1, 2, 3 }, foo.c); // equality of slices, firstly of size, then of values
    try testing.expectEqualStrings("Hello", foo.d); // equality of strings, firstly of size and then content
}

pub fn main() !void {}
