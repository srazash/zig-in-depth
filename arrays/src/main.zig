const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // ARRAYS
    // arrays are data structures of the same type stored in contiguous memory

    // explicit type and length
    const array1: [5]u8 = [5]u8{ 1, 2, 3, 4, 5 }; // declare an array of 5 * u8 values
    print("array1: {any}, length: {d}\n", .{ array1, array1.len }); // print the array contents and it's length

    // we can also infer the type and length
    const array2 = [_]u8{ 6, 7, 8, 9, 10 }; // here we pass in _ instead of a length value, and we don't declare the type
    // on the left side of the assignment operator, as it can be inferred from the array
    print("array2: {any}, length: {d}\n", .{ array2, array2.len });
}
