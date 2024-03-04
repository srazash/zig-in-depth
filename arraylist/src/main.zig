const std = @import("std");

pub fn main() !void {
    // ARRAYLIST
    // ArrayList (`std.ArrayList`) is Zig's equivalent to Java's ArrayList, or
    // a vector in C++ or Rust. Like an array, the elements of an ArrayList
    // must all be of the same type, but unlike an array, an ArrayList can grow
    // dynamically as items are added to it.

    // ArrayList needs memory allocation
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // create a new empty ArrayList
    // len == 0, cap == 0
    var list = std.ArrayList(u8).init(gpa.allocator());
    defer list.deinit();

    // add items to the ArrayList with `append()`
    for ("Howdy, pardner!") |byte| try list.append(byte);
    printList(list);

    // we can interact with an ArrayList like a stack
    try list.append('!'); // like .push(), add item to the end of the list
    printList(list);
    _ = list.pop(); // removes and returns the last item, discarded here
    printList(list);

    // we can write to an ArrayList of bytes using `writer()`
    const writer = list.writer();
    _ = try writer.print(" Writing to an ArrayList: {}", .{69});
    printList(list);

    // we can use an ArrayList like an interator
    while (list.popOrNull()) |byte| std.debug.print("{c}", .{byte});
    std.debug.print("\n", .{});
    printList(list);

    // we can append a slice
    try list.appendSlice("Howdy, pardner!");
    printList(list);

    // we can perform an ordered remove
    // this is an O(n) operation
    _ = list.orderedRemove(5); // removes and returns, discarded here
    printList(list);

    // we can swap remove, which swaps the last item into the index we specify
    // this is an O(1) operation
    _ = list.swapRemove(5); // remove item at index, swaps in item at last index
    // discarded here
    printList(list);

    // ArrayList functions as a wrapper around an underlying slice of items
    // we can always access these directly with `.items[<index>]`
    list.items[5] = ' ';
    printList(list);

    // we can clear the list and return all items from it to an owned slice
    // which we must free
    const slice = try list.toOwnedSlice();
    defer gpa.allocator().free(slice); // free the slice on scope exit
    printList(list);

    // we can create an ArrayList and allocate the capacity ahead of time
    list = try std.ArrayList(u8).initCapacity(gpa.allocator(), 15);

    // we can then append assuming we have the required capacity
    for ("Howdy") |byte| list.appendAssumeCapacity(byte);
    std.debug.print("len -> {}, cap -> {}\n", .{ list.items.len, list.capacity });
    printList(list);

    // 'gatherBytes()' uses an ArrayList internally
    const bytes = try gatherBytes(gpa.allocator(), "Howdy there!");
    defer gpa.allocator().free(bytes);
    std.debug.print("{s}\n", .{bytes});
}

fn printList(list: std.ArrayList(u8)) void {
    std.debug.print("list -> ", .{});
    for (list.items) |item| std.debug.print("{c}", .{item});
    std.debug.print("\n", .{});
}

fn gatherBytes(allocator: std.mem.Allocator, slice: []const u8) ![]u8 {
    var list = try std.ArrayList(u8).initCapacity(allocator, slice.len);
    defer list.deinit();
    for (slice) |byte| list.appendAssumeCapacity(byte);
    return try list.toOwnedSlice();
}
