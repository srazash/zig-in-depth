const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

// TESTING
// we run our tests with `zig build test`, usually we would use `zig build run` to compile and executre our code
// instead we compile and run the tests on our code instead

// NOTE: Zig conforms to the Unix standard of no output where there are no errors, so if a test has no output it means it passed
// we can add `--summary all` which will show how many tests have run and passwed/skipped/failed BUT only the first time they are
// run after a change, as Zig caches compiled code and test results!

// zig build test --summary all
// Build Summary: 3/3 steps succeeded; 10/11 tests passed; 1 skipped <- TESTS PASSED / SKIPPED
// test success
// └─ run test 10 passed 1 skipped 470ms MaxRSS:2M
//    └─ zig test Debug native success 2s MaxRSS:208M

// zig build test --summary all
// Build Summary: 3/3 steps succeeded <- NO TEST RESULTS
// test cached <- CACHED TEST RESULTS
// └─ run test cached
//    └─ zig test Debug native cached 32ms MaxRSS:31M

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

// we can test for specific errors
// here we have a simple error set with one error - `Boom`
const Error = error{Boom};

// a function which only return the error we defined
fn harmless() Error!void {
    return error.Boom;
}

test "explosive error" {
    try testing.expectError(error.Boom, harmless()); // we can test for an error to occur with `expectError()`
    // this is useful if we want to test error handling, we can cause a function to error and check the correct error is generated
    // NOTE: typically we call an function that returns an error union with the `try` keyword, here we do no because `expectError()` handled this
    // for use (note that we invoke every test with the `try` keyword!)
}

// we can include tests in other .zig files by discarding them in a test block
test {
    _ = @import("arithmetic.zig"); // this tells the test runner to check arithmetic.zig for tests, but it is otherwise unused
}
// our "inside foo" test in the Foo struct functions similarly, if Foo was not referenced anywhere it would not run that test
// but because we have `const foo = Foo.new(true)` that means this test is run when we `zig build test`

// in build.zig we can add a filter to our tests, on line 57 our tests are defined and on line 63 we filter to only tests which have the word
// "basic" in their description. normally this filter is not in build.zig, and so all tests run normally

const skip_flag = true;

// we can also skip tests using `error.SkipZigTest`
test "skip test" {
    const true_or_false: bool = false; // if true pass test, if false skip test :)
    //if (!true_or_false) return error.SkipZigTest; // this will cause an unreachable code error if we don't put it behind an if statement
    _ = skip_flag or return error.SkipZigTest; // we can also use a flag to skip tests, this is very useful when we need to be able to skip multiple tests
    try testing.expect(true_or_false);
}

pub fn main() !void {
    const run_test_instead =
        \\ run:
        \\ `zig build test --summary all`
    ;

    print("{s}\n", .{run_test_instead});
}
