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

    // we can repeat an array using the ** operator
    const array3 = array1 ** 2; // again, the size and type are inferred
    print("array3: {any}, length: {d}\n", .{ array3, array3.len });
    // the ** operator can be used to initialise an array with a default value
    const array4 = [_]u8{0} ** 5; // array4 = { 0, 0, 0, 0, 0 }
    print("array4: {any}, length: {d}\n", .{ array4, array4.len });

    // the lenth of the array must be known at comptime
    // the length must be a const, whether inferred or explicit
    // var v_array_length: u8 = 5;
    // const array = [_]u8{0} ** v_array_lenth; <- COMPTIME ERROR, a var is a runtime value

    // an array can be undefined if it is intended to be worked with later during the application runtime
    var array5: [5]u8 = undefined; // because the length and data type cannot be inferred we must define them
    array5[0] = 25;
    array5[1] = 50;
    array5[2] = 75;
    array5[3] = 100;
    array5[4] = 125;
    print("array5: {any}, length: {d}\n", .{ array5, array5.len });

    // multi-dimensional arrays
    const md_array: [2][2]u8 = [_][2]u8{ // create a array of two arrays of 2 u8's each!
        // we don't specify the lenth of the outer array ([_]) but must specify the lenth of the inner array
        // this is because this is part of the type the outer array stored and must be explicitly defined
        .{ 1, 2 }, // we define the inner arrays using a TUPLE LITERAL (.{})
        .{ 3, 4 },
    };
    print("md_array: {any}, length: {d}\n", .{ md_array, md_array.len });
    print("md_array[1][0] -> {d}\n", .{md_array[1][0]}); // we access values using the indeces of both arrays ([x][y])

    // Zig has Sentinel terminated arrays
    const array6: [2:0]u8 = .{ 99, 98 }; // assign the array values using a tuple literal
    // this array has a hidden third element containing `0` - the value we selected as our sentinel
    // we set this value after the length and seperated by a colon ([x:0]T)
    print("array6: {any}, length: {d}\n", .{ array6, array6.len });
    print("array6 value 0 -> {d}\n", .{array6[0]});
    print("array6 value 1 -> {d}\n", .{array6[1]});
    print("array6 sentinel value -> {d}\n", .{array6[2]}); // we can access the sentinel directly

    // if we attempted this on a normal array we would wncounter a comptime error
    // const array: [2]u8 = .{ 50, 60 };
    // print("array sentinel value -> {d}\n", .{ array[2] }); <- index outside of length error!

    // we can concatinate arrays
    const array7 = array1 ++ array2; // { 1, 2, 3, . . . 8, 9, 10 }
    print("array7: {any}, length: {d}\n", .{ array7, array7.len });

    // we can initialise an array with the results of a function call
    // and combine this with the ** operator
    const array8 = [_]u8{getSquare(5)} ** 3;
    print("array8: {any}, length: {d}\n", .{ array8, array8.len });

    // defining empty arrays
    _ = [0]u8{};
    _ = [_]u8{};
}

fn getSquare(x: u8) u8 {
    return x *| x;
}
