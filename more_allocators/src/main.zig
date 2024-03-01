const std = @import("std");

const List = @import("list.zig").List;
//const List = @import("list_arena.zig").List;

pub fn main() !void {
    // for almost every memory allocation requirement, unless we have very specific requirement,
    // our go-to allocator should be the General Purpose Allocator (GPA)!

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // in debug mode the GPA will detect memory leaks and double frees
    // overall it operates similarly to the testing allocator
    // it proivdes good performance overall, except in some scenarios where
    // we have the option of special purpose allocators (the ArenaAllocator for example)

    defer std.debug.print("GPA result: {}\n", .{gpa.deinit()});
    // here we call the deinit() method of the GPA and print out the status

    // log all allocations and frees handled by the GPA allocator
    var logging_alloc = std.heap.loggingAllocator(gpa.allocator());

    // log all allocations and frees for the ArenaAllocator
    //var logging_alloc = std.heap.loggingAllocator(std.heap.page_allocator);

    // assign the allocator()
    const allocator = logging_alloc.allocator();

    // some allocations
    var list = try List(u8).init(allocator, 50);
    defer list.deinit(); // free on scope exit
    try list.append(100);
    try list.append(200);

    // when interopping with C, use the `std.heap.c_allocator`!
    // when targetting WASM, use the `std.heap.wasm_allocator`!
}

// test for an allocation failure with the `failing_allocator`
test "allocation failure" {
    const allocator = std.testing.failing_allocator;
    var list = List(u8).init(allocator, 100);
    try std.testing.expectError(error.OutOfMemory, list);
}

// we can use a memory pool when all objects being allocated have the same type
// this is more efficient as previously allocated slots are reused instead of
// allocating more memory.
test "basic memory pool" {
    var pool = std.heap.MemoryPool(u32).init(std.testing.allocator);
    // initialise our pooll with the type we'll be using with it
    // and pass it a child allocator to use

    defer pool.deinit(); // defer a deinit() for when we leave scope

    // create pools
    const p1 = try pool.create();
    const p2 = try pool.create();
    const p3 = try pool.create();

    // assert uniqueness of each pointer
    try std.testing.expect(p1 != p2);
    try std.testing.expect(p2 != p3);
    try std.testing.expect(p3 != p1);

    // destroy and create pointers
    pool.destroy(p2);
    const p4 = try pool.create();

    // assert memory reuse, p4 is re-using the memory that was used by p2
    try std.testing.expect(p2 == p4);
}
