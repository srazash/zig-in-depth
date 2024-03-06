const std = @import("std");

// WORKING WITH C
// we can call and use C code directly within a Zig program
// without building a separate library with `@cImport()`
//const math = @cImport({
//    @cDefine("INCREMENT_BY", "2"); // like `#DEFINE INCREMENY_BY 2` in C
//   @cInclude("math.c"); // like `#include <math.h>`in C
//});

// we can also use C code from a linked library
extern fn add(a: i32, b: i32) i32;
extern fn increment(x: i32) i32;

pub fn main() !void {
    // this closely matches what we have in `main.c`, except:
    const a = 34; // 1. our const definition
    const b = 35;
    //const c = math.add(a, b); // 2. we call add through it's namespace
    const c = add(a, b); // using linked C library

    // 3. we use the Zig debug print statement, instead of C's `printf()`
    // and change the format string and arguments we pass to it
    std.debug.print("zig -> a + b = {}\n", .{c});
    //std.debug.print("zig -> a++ = {}\n", .{math.increment(a)}); // called through the math namespace
    std.debug.print("zig -> a++ = {}\n", .{increment(a)}); // using linked C library

    // we can also call on the C standard library through Zig's standard library
    _ = std.c.printf("zig(.c) -> a + b = %d\n", c);
}
