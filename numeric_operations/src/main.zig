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
    print("{d}\n", .{result});

    // We can also overflow using Saturating
    // unlike with wrapping, saturating simply hits the limit of the data type and leaves it maxed out
    // here we try to put 250*2 into a u8 (0-255), once we hit 255 the value is saturated and no further changes are made to the value
    result = two_fifty *| two; // | added to our operator allow for saturating
    print("{d}\n", .{result});

    // we can also use wrapping and saturation when subtracting and we will wrap and saturate in the opposite direction
    // wrapping will go down to 0 and wrap back around to 255
    // satuation will hit 0 and make no further changes to the value
    result = two -% two_fifty;
    print("{d}\n", .{result});

    result = two -| two_fifty;
    print("{d}\n", .{result});
}
