const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // VECTORS AND SIMD
    // vector items can only be beeoleans, intergers, floats or pointers
    // they are created with the `@Vector` built-in
    // if our CPU supports SIMD (single instruction, multiple data) we can use
    // a vector to perform an operation on all data within the vector
    // simultaneously

    // `@Vector` -> length - must be comptime know, type
    const bools_vec_a: @Vector(3, bool) = .{ true, false, true }; // initialised with a tuple literal

    // vectors and arrays of the same length and type can be coerced to each other
    const bool_array_a: [3]bool = [_]bool{ true, true, true };
    const bools_vec_b: @Vector(3, bool) = bool_array_a; // initialised with array coercion

    const bool_vec_c = bools_vec_a == bools_vec_b; // SIMD equality check of each element, the results become a new vector
    print("bool_vec_c -> {any}, {}\n", .{ bool_vec_c, @TypeOf(bool_vec_c) });

    const bool_array_b: [3]bool = bool_vec_c; // coerced to an array
    print("bool_array_b -> {any}, {}\n", .{ bool_array_b, @TypeOf(bool_array_b) });

    // arithmetic operations on vectors
    const int_vec_a = @Vector(3, u8){ 1, 2, 3 };
    const int_vec_b = @Vector(3, u8){ 4, 5, 6 };
    const int_vec_c = int_vec_a + int_vec_b; // SIMD addition of each element of the vectors -> { 5, 7, 9 }
    print("int_vec_c -> {any}\n", .{int_vec_c});

    // `@splat` allows us to turn a scalar into a vector
    const twos: @Vector(3, u8) = @splat(2);
    const int_vec_d = int_vec_a * twos; // SIMD multiplication of each element of the vectors -> { 2, 4, 6 }
    print("int_vec_d -> {any}\n", .{int_vec_d});

    // `@reduce` allows us to turn a vector into a scalar
    // we can perform logical operations on bools: .Or, .And, .Xor
    // we can perform arithmetic operations on ints and floats: .Min, .Max, .Add, .Mul
    const all_true = @reduce(.And, bools_vec_a); // logical AND
    print("all_true -> {}\n", .{all_true});
    const any_true = @reduce(.Or, bools_vec_a); // logical OR
    print("any_true -> {}\n", .{any_true});

    // we can use array index syntax to access vector elements
    print("bools_vec_a[1] -> {}\n", .{bools_vec_a[1]});

    // we can use `@shuffle` to re-order vector elements into a new vector
    // the ordering is based on an index mask we provide
    const a = @Vector(7, u8){ 'o', 'l', 'h', 'e', 'r', 'z', 'w' };
    const b = @Vector(4, u8){ 'w', 'd', '!', 'x' };

    // `@shuffle` is intended to work with two input vectors, but we can
    // pass in `undefined` to use only a single input vector
    const mask1 = @Vector(5, i32){ 2, 3, 1, 1, 0 }; // NOTE: the mask vector is of type i32!

    // we pass in the type (u8), first (a) and second (undefined) input vectors, and then the mask vector
    const result1 = @shuffle(u8, a, undefined, mask1);

    // if we want to use two input vectors we need to use positive and negative numbers for the mask
    // positive values pull elements from the first vector (0, 1, 2...)
    // negative values pull elements from the second vector (-1, -2, -3...)
    // this is why the mask vector must be an i32
    const mask2 = @Vector(6, i32){ -1, 0, 4, 1, -2, -3 };
    const result2 = @shuffle(u8, a, b, mask2);

    // here we print out the new vectors as strings
    // but to do this we must coerce them into a []u8 as Zig cannot coerce from a vector directly
    // we also use the `&` address operator so the resulting []u8 functions as a slice
    print("{s}, {s}\n", .{ &@as([5]u8, result1), &@as([6]u8, result2) });

    // `@select` functions similarly to the `@shuffle` built-in
    // but uses booleans instead of signed integers
    const c = @Vector(4, u8){ 'x', 'i', 'j', 'd' };
    const d = @Vector(4, u8){ 's', 'b', 'm', 'd' };

    const mask3 = @Vector(4, bool){ false, true, false, true };

    // we pass in the type (u8), the mask vector (mask3), then the input vectors (c and d)
    const result3: @Vector(4, u8) = @select(u8, mask3, c, d);

    // again we pass a slice of []u8 to the format string
    print("{s}\n", .{&@as([4]u8, result3)});

    // SIMD case-insensitive ascii comparison
    print("a == A -> {}\n", .{asciiCaselessEquality('a', 'A')});
    print("a == a -> {}\n", .{asciiCaselessEquality('a', 'a')});
    print("A == A -> {}\n", .{asciiCaselessEquality('A', 'A')});
    print("A == a -> {}\n", .{asciiCaselessEquality('A', 'a')});

    print("a == B -> {}\n", .{asciiCaselessEquality('a', 'B')});
    print("a == b -> {}\n", .{asciiCaselessEquality('a', 'b')});
    print("A == B -> {}\n", .{asciiCaselessEquality('A', 'B')});
    print("A == b -> {}\n", .{asciiCaselessEquality('A', 'b')});
}

fn asciiCaselessEquality(a: u8, b: u8) bool {
    // check if input is valid ascii characters
    std.debug.assert(std.ascii.isAlphabetic(a) and std.ascii.isAlphabetic(b));

    // check exact equality
    if (a == b) return true;

    // create vector for comparison
    const a_vec: @Vector(2, u8) = .{ a, a };
    const b_vec: @Vector(2, u8) = .{ b, b ^ 0x20 }; // XOR to invert case
    // NOTE: this XOR only works with ascii, not UTF-8!

    // compare vectors
    const result = a_vec == b_vec;

    // `@reduce` to scalar boolean to return
    return @reduce(.Or, result); // only one element comparison needs to be true
}
