const std = @import("std");
const print = std.debug.print;

// USINGNAMESPACE
// `usingnamespace` allows us to avoid name collisions when we have the same
// names shared between consts, vars and functions.

// here we create a unified namespace for both `math.zig` and `person.zig`
//const my_libs = struct {
//    usingnamespace @import("math.zig");
//    usingnamespace @import("http.zig");
//    usingnamespace @import("person.zig");
//};

// we can also use `usingnamespace` to present a unified namespace from our
// external files, refer to `my_libs.zig`
const my_libs = @import("my_libs.zig");

pub fn main() !void {
    // using the maths library add function
    std.debug.print("1 + 2 == {}\n", .{my_libs.add(1, 2)});

    // using the Person struct
    const me = my_libs.Person{ .Name = "Bill", .Age = 28 };
    me.printNameAndAge();

    const you = my_libs.Person{ .Name = "Ted", .Age = 25 };
    std.debug.print("My name is {s} and I am {} years old.\n", .{ you.Name, you.Age });

    // using the http library
    const req = my_libs.Request(0);
    const req_with_timeout = req{
        .method = .get,
        .path = "/index.html",
        .body = null,
    };

    // here we check if req has the `getTimeout()` function before calling it
    // refer to `http.zig`
    if (@hasDecl(req, "getTimeout")) {
        std.debug.print("timeout -> {}\n", .{req_with_timeout.getTimeout()});
    }
}
