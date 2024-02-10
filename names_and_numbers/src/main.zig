const std = @import("std");
const e = @import("ext.zig"); // adjacent files are imported by filename
const s = @import("sub/sub.zig"); // files organised into subfolder should be imported using their relative path

// constant and variable names should be snake_case

// we can declare global constants (`const`) and global variables (`var`)
// these are declared outside of function bodies and can be accessed
// by any function in the file, these can be accessed from other files
// if they have the `pub` keyword meaning they are exported

pub const global_pi: f64 = 3.14159; // const is immutable and cannot be changed
var global_counter: u8 = 69; // var is mutable and can be changed

// function names should be camelCase
// this function is not declared `pub` so it only accessible within main.zig
fn printTypeInfo(name: []const u8, x: anytype) void {
    std.debug.print("{s:>10} {any:^10}\t{}\n", .{ name, x, @TypeOf(x) });
}

// the main function is declared `pub` so it can be accessed by the compiler
pub fn main() !void {
    // output labelling
    std.debug.print("{s:>10} {s:^10}\t{s}\n", .{ "name", "value", "type" });
    std.debug.print("{s:>10} {s:^10}\t{s}\n", .{ "----", "-----", "----" });

    printTypeInfo("pi_val", global_pi);
    printTypeInfo("apples_num", global_counter);

    e.extTest(); // `pub` functions from imported files are called using dot notation
    s.echo("hello");
}
