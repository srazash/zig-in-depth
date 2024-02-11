const std = @import("std");
const e = @import("ext.zig"); // adjacent files are imported by filename
const s = @import("sub/sub.zig"); // files organised into subfolder "packages" are imported by relative path

// constant and variable names should be snake_case

// we can declare global constants (`const`) and global variables (`var`)
// these are declared outside of function bodies and can be accessed
// by any function in the file, these can be accessed from other files
// if they have the `pub` keyword meaning they are exported

pub const global_pi: f64 = 3.14159; // const is immutable and cannot be changed
var global_counter: u8 = 69; // var is mutable and can be changed

// function names should be camelCase
// this function is not declared `pub` so it only accessible within main.zig
fn printTypeInfo(name: []const u8, T: anytype) void {
    std.debug.print("{s:>10} {any:^10}\t{}\n", .{ name, T, @TypeOf(T) });
}

// the main function is declared `pub` so it can be accessed by the compiler
pub fn main() !void {
    // output labelling
    std.debug.print("{s:>10} {s:^10}\t{s}\n", .{ "name", "value", "type" });
    std.debug.print("{s:>10} {s:^10}\t{s}\n", .{ "----", "-----", "----" });

    printTypeInfo("pi_val", global_pi);
    printTypeInfo("apples_num", global_counter);

    // consts do not need to be declared with a type, this is inferred by the compiler
    // at compilation time
    const jupiters_moons = 95; // this will be inferred as a comptime_int
    const jupiters_albedo = 0.503; // this will be inferred as a comptime_float

    // comptime values are known when the application compiles and do not change during runtime

    printTypeInfo("jupiters_moons", jupiters_moons);
    printTypeInfo("jupiter_albedo", jupiters_albedo);

    var temp_in_c: f64 = 23.1; // variables must be given an explicit datatype or marked as `comptime`
    //comptime var temp_in_c = 23.1;
    // variables marked as comptime have their data type inferred at compile time and their value
    // is know at compile time too, which can help with application optimisation
    temp_in_c += 0.3; // Zig does not use the ++ or -- operators for incrementing/decrementing

    printTypeInfo("temp_in_c", temp_in_c);
    std.debug.print("Temp: {d:.1}\n", .{temp_in_c});

    // all contsants and variables must be initialised with an initial value, if we do not yet want
    // to assign a value it can be `undefined`
    var undef_num: u8 = undefined;
    printTypeInfo("undef_num: undefined", undef_num); // random garbage value
    undef_num = 69;
    printTypeInfo("undef_num: defined", undef_num); // asigned value

    // variables and consts must be used
    // if a value is defined but never used it will cause a compile time error
    // this can be worked around by assigning the value to an underscore
    var i_am_unused: u16 = 420; // "unused local variable"
    _ = i_am_unused; // now it's used

    // DATA TYPES
    // integers
    // unsigned: u8, u16, u32, u64, u128, usize: u8 -> 0-255
    // signed: i8, i16, i32, i64, i128, isize: i8 -> -128-127
    // u/isize sizes the integer to the host address size, in most cases 64-bit = u64/i64
    // arbitrary integer sizes are possible: u/i(0-65535)
    // literals can be decimal, binary, hex or octal
    // underscores can be used to improve readability
    _ = 1_000_000; // decimal
    _ = 0b1111_0101_0111; // binary
    _ = 0x10ff_ffff; // hex
    _ = 0o777; // octal

    // floating points
    // f16, f32, f64, f80, f128
    // literals can be decimal or hex
    _ = 69.0; // without exponent
    _ = 4.2e+2; // with exponent (can also be E)
    _ = 0x45; // hex without exponent
    _ = 0x64p-1; // hex with exponent (can also be P)

    // underscores can be used for readability
    _ = 420_000.0;
    _ = 0.000_069;

    // floats can also be assigned infinity and NaN
    _ = std.math.inf(f64); // positive infinity
    _ = -std.math.inf(f64); // negative infinity
    _ = std.math.nan(f64); // not a number

    e.extTest(); // `pub` functions from imported files are called using dot notation
    s.echo("hello");
}
