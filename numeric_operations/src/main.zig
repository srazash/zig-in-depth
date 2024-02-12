const std = @import("std");
const print = @import("std").debug.print; // we can alias common functions from std, or any library we use

pub fn main() !void {
    // NUMERIC OPERATIONS
    const zero: u8 = 0;
    const one: u8 = 1;
    const two: u8 = 2;
    const two_fifty: u8 = 250;

    // the standard selection of arithmetic operators are available:
    // add, subtract, multiply, divide, modulo
    var result = zero + two - one * two / one % two; // type of `result` inferred from the data type we are assigning to it
    print("{d}\n", .{result});

    // add, subtract and multiply can OVERFLOW
    result = two_fifty + two; // no issues, this is within the bounds of a u8
    //result = two_fifty * two; <- this would cause an overflow error, as 250 * 2 is greater than 254

    // Zig allows us to overflow using wrapping
    // if our value needs to wrap, it will go up to the maximum value and then wrap around to the lowest value
    // here we try to put 250*2 into a u8 (0-255), once we hit 255 Zig wrap teh value back around to 0 and add the remainder to it
    result = two_fifty *% two; // % added onto our arithmetic operator allows for wrapping
    print("*% -> {d}\n", .{result});

    // We can also overflow using Saturating
    // unlike with wrapping, saturating simply hits the limit of the data type and leaves it maxed out
    // here we try to put 250*2 into a u8 (0-255), once we hit 255 the value is saturated and no further changes are made to the value
    result = two_fifty *| two; // | added to our operator allow for saturating
    print("*| -> {d}\n", .{result});

    // we can also use wrapping and saturation when subtracting and we will wrap and saturate in the opposite direction
    // wrapping will go down to 0 and wrap back around to 255
    // satuation will hit 0 and make no further changes to the value
    result = two -% two_fifty;
    print("-% -> {d}\n", .{result});

    result = two -| two_fifty;
    print("-| -> {d}\n", .{result});

    // one overflow edge case to be aware of is negation of signed integers
    const neg_one_two_eight: i8 = -128; // i8 (-128-127)
    // result = -neg_one_two_eight; <- this would cause an overflow error, negating -128 = 128
    print("-% -128 -> {d}\n", .{-%neg_one_two_eight}); // we wraparound and come back to -128!
    //print("-| -128 -> {d}", .{-|neg_one_two_eight}); <- NOTE: there is no saturating wrap for negation!

    // Bit shifting operators
    _ = 1 << 2; // left shift
    print("1 << 2 = {}\n", .{1 << 2}); // 4
    _ = 1 <<| 2; // saturating left shift
    var sat_byte: u8 = 0b0000_0001;
    print("0b0000_0001 <<| 8 = {b}\n", .{sat_byte <<| 8}); // 11111111 / 255
    _ = 32 >> 1; // right shift
    print("32 >> 1 = {}\n", .{32 >> 1}); // 16

    // Bitwise operators
    _ = 32 | 2; // bitwise or
    _ = 32 & 1; // bitwise and
    _ = 32 ^ 0; // bitwise xor
    var one_bit: u8 = 0b0000_0001; // 1 in binary
    _ = ~one_bit; // bitwise not

    // Comparison operators
    _ = 3 < 9; // less than
    _ = 3 <= 0; // less than or equal
    _ = 9 > 3; // greater than
    _ = 9 >= 3; // greater than or equal
    _ = 3 == 3; // equal
    _ = 3 != 3; // not equal

    // Type coercion
    // Zig allows "safe" type coercion, that is from a smaller data type to a large one
    // where no loss is possible
    const u_eight: u8 = 100;
    const u_sixteen: u16 = 1000;
    var u_three_two: u32 = u_eight + u_sixteen;
    print("u32 from u8 + u16 = {d}\n", .{u_three_two});

    // if we need to take from a larger data type to a smaller one, even where no loss
    // of data is possible, we need to cast
    var u_sixteen_2: u16 = @intCast(u_three_two);
    print("u16 cast from a u32 = {d}\n", .{u_sixteen_2});

    // when moving between data types we have to convert, when moving from floats to ints
    // this can involve data loss, as intergers do not have decimal places
    var f_six_four: f64 = 3.14159;
    const f_to_i: i32 = @intFromFloat(f_six_four);
    print("float to int conversion = {}\n", .{f_to_i});
    f_six_four = @floatFromInt(f_to_i);
    print("int to float conversion = {}\n", .{f_six_four});

    // Builtins
    // there are numerous builtins that provide arithmetic functions
    //@addWithOverflow, @multWithOverflow, @mod, @rem, @fabs, @sqrt, @min, @max . . .
    print("@sqrt(): square root of 64.0 = {}\n", .{@sqrt(64.0)}); // must be a float

    // std.math arithmetic operators
    // Zig's standard library has a rich collection of maths functionality
    //std.math.add, std.math.sub, std.math.divExact . . .
    print("std.math.sqrt(): square root of 64 = {}\n", .{std.math.sqrt(64)}); // accepts anytype
}
