const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // FOR LOOP
    var array = [_]u8{ 0, 1, 2, 3, 4, 5 };

    // we can easily interate over an array with a for loop
    for (array) |item| print("{} ", .{item});
    print("\n", .{});

    // we can also do this with a slice
    for (array[0..3]) |item| print("{} ", .{item});
    print("\n", .{});

    // we can add a range to include the index
    for (array, 1..) |item, i| print("{}:{} ", .{ i, item });
    print("\n", .{});

    // we can iterate over multiple items
    // NOTE: they must all be of equal length!
    for (array[0..2], array[1..3], array[2..4]) |a, b, c| print("{}-{}-{} ", .{ a, b, c });
    print("\n", .{});

    // we can iterate over a range but it cannot be unbounded (x..)
    // NOTE: the upper bound of ranges, like slices, are exclusive, so a range 1..11 would count 1 to 10
    for (1..11) |item| print("{} ", .{item});
    print("\n", .{});

    // break and continue
    var sum: usize = 0;
    for (array) |item| {
        if (item == 3) continue; // if item is 3, continue to the next iteration
        if (item == 4) break; // if item is 4, exit the loop entirely
        sum += item;
    }
    print("sum -> {}\n", .{sum}); // should be 3

    sum = 0;

    // we can use labels with for loops
    lbl: for (1..11) |item| {
        if (item % 2 != 0) continue :lbl; // if the item is odd continue to the next iteration
        sum += item;
    }
    print("sum -> {}\n", .{sum}); // should be 30
    // we can also use labels with `break`

    // we can obtain a pointer to an item to modify it directly
    // the array and values cannot be const and we must use a pointer
    // NOTE: a slice is also a pointer type!
    for (&array) |*item| { // using the address (&) of the array, and iterating over a pointer (*) to the items in it
        item.* *= 2; // we have to dereference (.*) a pointer to work on it's value - these items are changed in the array!
        print("double -> {}\n", .{item.*}); // another dereference
    }

    // as with many other statements in Zig we can also use a for loop as an expression
    // here we will iterate over a new array to obtain a slice of the non-null optional values
    const null_num_array = [_]?u8{ 0, 1, 2, 3, null, null };
    print("null_num_array -> {any}\n", .{null_num_array});

    const num_slice = for (null_num_array, 0..) |item, i| { // iterate over the null_num_array
        if (item == null) break null_num_array[0..i]; // break out at the current index once the item is null
    } else null_num_array[0..];

    print("just_num_slice -> {any}\n", .{num_slice}); // {0, 1, 2, 3}
}
