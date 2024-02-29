const std = @import("std");

// FIXED BUFFER ALLOCATOR
// the FixedBufferAllocator is best when we know how much memory we need ahead of
// time, and any allocations wont exceed that amount. an FBA uses memory on the stack
// which is much faster than the allocating to the heap, but is limited in size

// concatAlloc function from memory_management, this returns a slice to a combined
// string that has been allocated to memory, the caller must free the memory
fn concatAlloc(allocator: std.mem.Allocator, a: []const u8, b: []const u8) ![]u8 {
    const bytes = try allocator.alloc(u8, a.len + b.len);
    std.mem.copy(u8, bytes, a);
    std.mem.copy(u8, bytes[a.len..], b);
    return bytes;
}

test "fba bytes" {
    // inputs
    const h = "Hello, "; // 7
    const w = "world!"; // 6

    // if we know the required memory size ahead of time we can create a fixed-size
    // array to act as a buffer
    var buf: [13]u8 = undefined; // 7 + 6 = 13

    // and use the buffer as the memory for a FixedBufferAllocator
    var fba = std.heap.FixedBufferAllocator.init(&buf); // wants a slice of u8, pass in address of buffer
    // there is no `deinit()` for fba because it it on the stack, other allocators do have a `deinit()` method
    const allocator = fba.allocator(); // all allocators have an `allocator()` method

    const result = try concatAlloc(allocator, h, w);
    defer allocator.free(result); // we do still need to free the memory once we are done with it

    try std.testing.expectEqualStrings(h ++ w, result);
}

pub fn main() !void {
    // nothing here again :)
}
