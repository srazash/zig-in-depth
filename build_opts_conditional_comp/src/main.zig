const std = @import("std");

// import the config containing our options (from `build.zig`)
const config = @import("config");

// import the fibonacci module from our `build.zig` command line option (`-Dloop`)
const fib = @import("fibonacci").fib; // note that our function in both `fib_loop.zig` and `fib_recurse.zig` is called `fib`

pub fn main() !void {
    // exe command line processing, these are arguments passed in with `--`
    var args_iter = std.process.args();
    _ = args_iter.next(); // program name

    // retrieve `n` from our arguments
    const n: usize = if (args_iter.next()) |arg|
        try std.fmt.parseInt(usize, arg, 10) // parse a usize int from the captured arg as a base 10 value
    else
        7; // otherwise we default to 7 if o argument is passed in

    // use the `-Dloop` option pulled in with our config module
    const fib_type: []const u8 = if (config.use_loop) "loop" else "recursive"; // simply use to to set a string

    // print the fibonacci sequence to the nth value
    std.debug.print("\n\n{}th fibonacci ({s}): {}\n\n", .{ n, fib_type, fib(n) });
}
