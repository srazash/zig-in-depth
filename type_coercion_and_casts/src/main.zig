const std = @import("std");

fn add(a: u8, b: u16) u32 {
    return a + b;
}

pub fn main() !void {
    // TYPE COERCION AND CASTS
    // coercions are safe as they involve no risk of loss of data, coercions
    // can be performed without using special functions or built-ins

    // int widening is a good example of this
    const a: u8 = 69; // our integer literal is of type comptime_int which we coerce into u8
    const b: u16 = a;
    const c: u32 = b;
    const d: u64 = c;
    const e: u128 = d;
    std.debug.print("int widening: u8 -> u128: {} ({})\n", .{ e, @TypeOf(e) });

    // we can also perform float widening
    const f: f16 = 3.142; // our float literal is of type comptime_float which we coerce into f16
    const g: f32 = f;
    const h: f64 = g;
    const i: f80 = h;
    const j: f128 = i;
    std.debug.print("float widening: f16 -> f128: {} ({})\n", .{ j, @TypeOf(j) });

    // function call argument coercion
    // our function take a u8 and u16, adds them and returns a u32
    const a_u8: u8 = 50;
    const a_result = add(a_u8, a_u8); // we pass in two u8 values
    std.debug.print("function args: u8, u16 -> u32: {} ({})\n", .{ a_result, @TypeOf(a_result) });

    // we can also perform safe narrowing of a comptime know value
    // that is from a larger integer into a smaller one that can hold the integer value
    const b_u64: u64 = 2000; // can fit within u16 and u32
    const b_result = add(a_u8, b_u64);
    std.debug.print("comptime narrowing: u64 -> u32: {} ({})\n", .{ b_result, @TypeOf(b_result) });

    // comptime known unsafe narrowing will cause a compile time error
    //const c_u64: u64 = 20_000_000_000;
    //const c_u32: u32 = c_u64; // error: type 'u32' cannot represent integer value '20000000000'
    //std.debug.print("int narrowing: u64 -> u32: {} ({})\n", .{ c_u32, @TypeOf(c_u32) });

    // coercion can happen between pointer types
    const array = [_]u8{ 1, 2, 3 };
    const a_slice: []const u8 = &array; // array to a slice
    const a_mptr: [*]const u8 = &array; // array to a multi-pointer
    _ = a_mptr;

    // coercion can happen between optionals and non-optionals of matching types
    var a_optional: ?u8 = null; // optional u8
    a_optional = a_u8; // assign a non-optional u8 value

    // coercion can happen between error unions and non-error unions of matching types
    var a_err: anyerror!u8 = error.InvalidNumber; // error union u8
    a_err = a_u8; // assign a non-error union u8 value

    // peer type resolution requires all btanches to coerce to a common type
    var runtime_zero: usize = 0;
    var happy_medium = if (runtime_zero < 1) a else f; // both types can coerce to f16
    std.debug.print("peer if: u8 or f16 -> f16: {} ({})\n", .{ happy_medium, @TypeOf(happy_medium) });

    // this can also happen in binary operations
    const c_result = a + e; // u8 + u128, both types can coerce to a u128
    std.debug.print("peer add: u8 + u128 -> u128: {} ({})\n", .{ c_result, @TypeOf(c_result) });

    // when types cannot be coerced safely we must explicitly cast using cast built-ins
    // NOTE: built-in casting will cast to the type assigned to the var/const we cast to!
    const k: u8 = @intFromFloat(f); // loss of data
    std.debug.print("@intFromFloat(): f16 -> u8: {} ({})\n", .{ k, @TypeOf(k) });

    const l: f16 = @floatFromInt(c); // no loss of data
    std.debug.print("@floatFromInt(): u32 -> f16: {} ({})\n", .{ l, @TypeOf(l) });

    // we can also cast pointers
    const b_mptr: [*]const u8 = @ptrCast(a_slice); // slice to multi pointer
    std.debug.print("@ptrCast(): []const u8 -> [*]const u8: {}\n", .{@TypeOf(b_mptr)});

    // we can cast a value without changing the bits in memory that make up the value using @bitCast()
    const float: f64 = 3.141592;
    const bits: u64 = @bitCast(float);
    const as_u64: u64 = @intFromFloat(float);
    const as_f64: f64 = @bitCast(bits);
    std.debug.print("@bitCast():\n", .{});
    std.debug.print("\tf64 -> {d}\n", .{float});
    std.debug.print("\tu64 bits -> {b}\n", .{bits});
    std.debug.print("\tu64 from f64 -> {d}\n", .{as_u64});
    std.debug.print("\tu64 from f64 bits -> {b}\n", .{as_u64});
    std.debug.print("\tback to f64 -> {d}\n", .{as_f64});

    // we cannot @intCast() an integer to a smalelr type if the value will not fit
    // we can force this integer narrowing with data loss using @truncate() however
    var big_int: u64 = 20_000_000_000;
    var little_int: u32 = @truncate(big_int);
    std.debug.print("@intCast(): u64 -> u32: {} ({})\n", .{ little_int, @TypeOf(little_int) });
}
