const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // SLICES
    // if we slice comptime known bounds the result is a pointer and not a slice!
    var array = [_]u8{ 0, 1, 2, 3, 4, 5 }; // array of inferred type and size, comptime known bounds
    const array_ptr = array[0..array.len]; // slicing operation (array[x..y])
    print("type of array_ptr -> {}\n", .{@TypeOf(array_ptr)});

    // this is a runtime know value, forces a slice instead of a pointer
    var zero: usize = 0;

    // slicing syntax
    const a_slice: []u8 = &array; // []u8 = a slice of u8 values, even though we passed in an address
    // Zig will coerce this to a slice because of the data type we specified
    a_slice[0] += 1; // increment the value at index 0, our slice is const but the underlying array is not
    print("a_slice[0] -> {}\na_slice.len -> {}\n", .{ a_slice[0], a_slice.len });
    print("type of a_slice -> {}\n", .{@TypeOf(a_slice)});

    // a slice is a multi item pointer with a length (usize)
    // the length isn't part of the slice's type, it is a runtime know value
    print("type of a_slice.ptr -> {}\n", .{@TypeOf(a_slice.ptr)});
    print("type of a_slice.len -> {}\n", .{@TypeOf(a_slice.len)});

    // if declared as a variable we can directly manipulate a slice
    var b_slice = array[zero..];
    b_slice.ptr += 2; // pointer arithmatic
    // but we must ensure the length is updated with this otherwise it will cause error later on!
    b_slice.len -= 2;
    print("b_slice -> {any}\n", .{b_slice});

    // we can alos slice a slice
    // we force a const slice by specifiting the result type
    const c_slice: []const u8 = a_slice[0..3]; // note `[]const u8`
    print("c_slice -> {any}\n", .{c_slice});

    // slices have bounds checkling at comptime
    //b_sclice[10] = 1 <- this will cause a runtime error as this index is out of bounds

    // we can slice a pointer to an array
    const d_slice = array_ptr[zero..2];
    print("d_slice -> {any}\n", .{d_slice});

    // sentinel terminated slices are similar to sentinel terminated pointers
    array[4] = 0;
    const e_slice: [:0]u8 = array[0..4 :0]; // `[:0]u8` <- sentinel terminated slice of u8
    print("e_slice[e_slice.len] -> {any}\n", .{e_slice[e_slice.len]});

    // a useful idiom is to slice by length
    var start: usize = 2;
    var length: usize = 2;
    const f_slice = array[start..][0..length]; // slice from start to the end THEN slice from 0 to the length
    // the compiler will combine these operations into a single slice
    print("f_slice -> {any}\n", .{f_slice});
}
