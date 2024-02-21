const std = @import("std");
const print = @import("std").debug.print;

// FUNCTIONS
// a simple function
// a function declaration is made up of:
// `fn` <- the function declaration
// `add` <- the name of the function
// `(a: u8, b: u8) <- named and typed parameters
// `u8` <- a return type
// everything up to this point is the FUNCTION SIGNATURE
// `{ ... }` <- the FUNCTION BODY, contained in curly braces
fn add(a: u8, b: u8) u8 {
    return a +| b;
}

// if a function doesn't return a value the return type is `void`
fn printVal(a: u8) void {
    print("{}\n", .{a});
}

// a function that never returns uses the `noreturn` type
// this differs from a function with no return type
fn oops() noreturn {
    @panic("Oops!"); // never return to the calling function!
}

// if a function is never called it is not evaluated by the compiler
fn neverCalled() void {
    @compileError("This error never happens!"); // if the function was called it would generate a comptime error!
}

// a function marked as `pub` can be imported from a different namespace
pub fn sub(a: u8, b: u8) u8 {
    return a -| b;
}

// an `extern` function is one linked in from an external object file
// `extern` <- indicated we're using a function from an external object file
// "c" <- this is the name of the library, here we are lining to "libc"
// the remainder is a normal function signature, but lacking a function body
extern "c" fn atan2(a: f64, b: f64) f64;

// an `export` function is how we make a function available in external object files
export fn mul(a: u8, b: u8) u8 {
    return a *| b;
}

// we can force inlining a function, this is typically handled by the compiler
// inlining a function means the compiler inserts the function into the caller
// rather than having it exist as seperate code called by the caller. this can be
// beneficial to performance, especially where the function is simple, shuch as here:
inline fn answer() u8 {
    return 42;
}

// Zig will always determine whether to pass paramaters by value or by reference
// typically smaller, simpler types (u8) are passed by value (as a copy), while more
// complex data types (structs) are passed as a reference
// parameters are ALWAYS constants and are therefore immutable
fn addOneNot(n: u8) void {
    n += 1;
}

// if we want to directly modify values passed in as parameter we must pass in a pointer
// and dereference it within the function, of course the value we pass in must be a
// variable so we can mutate it!
fn addOne(n: *u8) void {
    n.* += 1;
}

pub fn main() !void {
    var n: u8 = 9;

    addOne(&n);
    print("n -> {}\n", .{n});
}
