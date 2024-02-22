const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // STRINGS
    // string literals are const pointers to sentinel terminaled arrays
    // the sentinel is 0, this is known as the null character in C
    // the array's bytes are included as part of the generated binary
    const hello = "Hello";
    print("type of \"hello\" -> {}\n", .{@TypeOf(hello)}); // *const [5:0]u8
}
