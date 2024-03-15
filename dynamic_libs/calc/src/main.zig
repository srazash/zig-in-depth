const std = @import("std");

// DYNAMIC LIBRARIES
// Zig allows us to create executable (binary) and library projects
// but we can create two types of libraries: the first is a static library
// which can be used by different project and is compiled as part of the
// binary or library using it, the other type is a dynamic (or shared)
// library which exists as a separate library file that is called by
// any executable of library using it

pub fn main() !void {
    // get the library name via command line args
    var args = std.process.args();
    const bin = args.next().?; // the first argument is always the name of the binary
    const lib_path = args.next() orelse { // get the next argument, which should be the path to our dynamic library
        std.debug.print("whoops, no library specified!\n", .{});
        std.debug.print("usage: {s} </path/to/library>\n", .{bin});
        return error.MissingArg;
    };

    // open the lib
    var lib = try std.DynLib.open(lib_path);
    defer lib.close(); // library must be closed when we're done with it, so we defer `.close()`

    // lookup a function
    // `lookup()` takes two arguments: the function type, which is a const pointer to the function with it's signature, and the name of the function
    // if we cannot find a matching function we return an error
    const calc = lib.lookup(*const fn (i32, i32) i32, "calc") orelse return error.NoSuchFunction;

    // finally, we call the function
    std.debug.print("{}\n", .{calc(50, 25)});

    // to use this, build the libraries and the binary and (assuming we are in the root director of `calc`):
    // no arg: `./zig-out/bin/calc` -> whoops, no library specified!
    // incorrect arg: `./zig-out/bin/calc ./libfoo.dylib` -> error: FileNotFound
    // `./zig-out/bin/calc ../add/zig-out/lib/libadd.dylib` -> 75
    // `./zig-out/bin/calc ../sub/zig-out/lib/libsub.dylib` -> 25
}
