const std = @import("std");
const print = std.debug.print;

// MULTIARRAYLIST
// a MultiArrayList in Zig is similar to the ArrayList but it allows us to
// conform to the principles of data oriented development

// this struct uses 16 bytes (with padding) in an array or an ArrayList
// to maintain alignment in memory (based on an 8 byte boundary), in a
// MultiArrayList it will only use 12 bytes (requires no padding)
const Foo = struct {
    a: u16,
    b: u64,
    c: u16,
};

// a MultiArrayList works, as the name suggest, by managing multiple arrays in
// the background for each type that makes up our struct - a STRUCT OF ARRAYS
// each array, for `Foo` this would be three arrays for a, b and c
// this is incredibly memory efficient in Zig as we have no data padding

pub fn main() !void {
    // general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // initialise a MultiArrayList
    var multi = std.MultiArrayList(Foo){};
    defer multi.deinit(allocator);

    // add an item, allocating where required automatically
    try multi.append(allocator, .{ .a = 1, .b = 10, .c = 100 });

    // pre-allocated additional capacity
    try multi.ensureUnusedCapacity(allocator, 2);

    // this allows us to add without calling on the allocator
    // NOTE: we don't need the `try` keyword as there are no allocations that can fail!
    multi.appendAssumeCapacity(.{ .a = 2, .b = 20, .c = 200 });
    multi.appendAssumeCapacity(.{ .a = 3, .b = 30, .c = 300 });

    // we can take a slice of a specific field from all the items in the list with `items`
    print(".a -> {any}\n", .{multi.items(.a)});
    print(".b -> {any}\n", .{multi.items(.b)});
    print(".c -> {any}\n", .{multi.items(.c)});

    // if we want to access more than one field it's better to get a slice of all fields first
    // we can then call `items` on that, this provides better performance
    const sliced = multi.slice();
    const a_fields = sliced.items(.a);
    const b_fields = sliced.items(.b);
    const c_fields = sliced.items(.c);

    print("1st .a -> {any}\n", .{a_fields[0]});
    print("2nd .b -> {any}\n", .{b_fields[1]});
    print("3rd .c -> {any}\n", .{c_fields[2]});

    // we can also iterate over all fields for all items this way
    for (a_fields, 0..) |a, i| print(".a[{}] -> {}\n", .{ i, a });
    for (b_fields, 0..) |b, i| print(".b[{}] -> {}\n", .{ i, b });
    for (c_fields, 0..) |c, i| print(".c[{}] -> {}\n", .{ i, c });

    // we can get an item at an index in the list
    const first_foo = multi.get(0);
    print("first foo -> {any}\n", .{first_foo});

    // as with an ArrayList we can use a MultiArrayList as a stack
    const head = multi.pop();
    print("head -> {any}\n", .{head});

    try multi.append(allocator, .{ .a = 5, .b = 50, .c = 255 }); // functionally equivalent to push

    // we can use `popOrNull()` to iterate through a list with a while loop
    var i: u8 = 0;
    while (multi.popOrNull()) |item| : (i += 1)
        print("item[{}] -> {any}\n", .{ i, item });

    // NOTE: if the list structure is modified any previously obtained slices
    // will be invalid. this can happen when appending/removing/popping items
    print("a_fields.len -> {}\n", .{a_fields.len}); // slices maintain their own length!
    print("b_fields.len -> {}\n", .{b_fields.len});
    print("c_fields.len -> {}\n", .{c_fields.len});
    print("list len -> {}\n", .{multi.items(.a).len}); // the actual length is now 0!
}
