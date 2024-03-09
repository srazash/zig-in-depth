const std = @import("std");

// INTERFACES
// Zig doesn't have interfaces out of the box but it does provide the building
// blocks that allow us to implement an interface

// we will implement a `Stringer` interface using a tagged union, this is the
// easiest and most performant way of doing so but we need full control of the
// source code to implement it

//const Stringer = @import("to_string_tagged.zig").Stringer;

// we can also implement interfaces using pointers, this allows us to decouple
// our Stringer from our User and Animal implementations (hence why we need to
// import them seperately now)

const Stringer = @import("to_string_ptr.zig").Stringer;
const Animal = @import("to_string_ptr.zig").Animal;
const User = @import("to_string_ptr.zig").User;

// remains the same no matter which type of interface implementation we use
fn printStringer(s: Stringer) !void {
    var buf: [256]u8 = undefined;
    const str = try s.toString(&buf);
    std.debug.print("{s}\n", .{str});
}

pub fn main() !void {
    // tagged union interface examples
    //var ryan = Stringer{ .user = .{
    //    .name = "Ryan",
    //    .email = "ryan@nesbit.local",
    //} };
    //try printStringer(ryan);

    //var ben = Stringer{ .animal = .{
    //    .name = "Ben",
    //    .sound = "I'm a dingus!",
    //} };
    //try printStringer(ben);

    // pointer cast interface
    var ryan = User{
        .name = "Ryan",
        .email = "ryan@nesbit.local",
    };
    const ryan_impl = ryan.stringer(); // obtain User implementation of Stringer
    try printStringer(ryan_impl);

    var ben = Animal{
        .name = "Ben",
        .sound = "I'm a dingus!",
    };
    const ben_impl = ben.stringer(); // obtain Animal implementation of Stringer
    try printStringer(ben_impl);
}
