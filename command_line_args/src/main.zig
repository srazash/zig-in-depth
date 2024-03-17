const std = @import("std");
const debug = std.debug;
const io = std.io;
const process = std.process;

const clap = @import("clap");

pub fn main() !void {
    debug.print("No alloc:\n", .{});

    // in non-windows systems we can get an iterator over all command line
    // arguments with `std.process.args`
    // no allocations are required
    //var args_no_alloc_iter = process.args(); // <- disable on windows!

    // the first argument is ALWAYS the binary name
    //debug.print("binary -> {s}\n", .{args_no_alloc_iter.next().?}); // <- disable on windows!

    // the remaining arguments are those passed in by the user
    var i: usize = 1;
    //while (args_no_alloc_iter.next()) |arg| : (i += 1) // <- disable on windows!
    //    debug.print("arg[{}] -> {s}", .{ i, arg }); // <- disable on windows!

    // on windows we need to use an allocator
    var buf: [1024]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    const allocator = fba.allocator();

    debug.print("With alloc:\n", .{});

    // on windows we need to get the arguments using an allocator, and defer a deinit
    var args_alloc_iter = try process.argsWithAllocator(allocator);
    defer args_alloc_iter.deinit();

    // the first argument is the binary name
    debug.print("binary -> {s}\n", .{args_alloc_iter.next().?});

    // the remaining arguments are those passed in by the user
    i = 1;
    while (args_alloc_iter.next()) |arg| : (i += 1) debug.print("arg[{}] -> {s}\n", .{ i, arg });

    // zig-clap is a powerful command line argument parser
    // https://github.com/Hejsil/zig-clap/
    debug.print("ZIG-CLAP:\n", .{});

    // first we specify what parameters a user can pass in to our program
    // to do this we use `parseParamsComptime` to parse a string into an array
    // of `Param(Help)`
    const params = comptime clap.parseParamsComptime(
        \\-h, --help               Display help and exit.
        \\-n, --number <usize>     An option parameter which take a value.
        \\-s, --string <str>...    An option parameter which can be specified multiple times.
        \\<str>...
        \\
    );

    // parse and display help message on error
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = null,
        .allocator = allocator,
    }) catch {
        return clap.help(io.getStdErr().writer(), clap.Help, &params, .{});
    };
    defer res.deinit();

    // now we can use the args, they have the corresponding Zig types
    if (res.args.help != 0) // boolean flag
        return clap.help(io.getStdErr().writer(), clap.Help, &params, .{});
    if (res.args.number) |n| // a number (usize)
        debug.print("--number -> {}\n", .{n});
    for (res.args.string) |s| // multiple strings ([]const []const u8)
        debug.print("--string -> {s}\n", .{s});
    for (res.positionals) |p| // any other positional args ([]const []const u8)
        debug.print("{s}\n", .{p});
}
