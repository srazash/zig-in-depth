const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

// MEMORY MANAGEMENT

// basics of memory
// memory is broken down into three areas: stack, heap and static (or global)
// static is where compiled items are stored - such as strings or constants
// the stack is where variables within functions are stored while executing
// each function creates a new stack frame which pops after it is returns
// the heap is an area of memory which we need to allocate and free, any
// heap memory we have allocated will be available until we free it and isn't
// tied to function lifetimes like the stack is

pub fn main() !void {}

// take an output variable, return number of bytes written into it
fn concatLen(a: []const u8, b: []const u8, out: []u8) usize {
    // ensure we have enough memory
    std.debug.assert(out.len >= (a.len + b.len));

    // copy the bytes
    // NOTE: std.mem.copy is deprecated!
    // @memcpy requires destination and source to be equal length
    std.mem.copy(u8, out, a);
    std.mem.copy(u8, out[a.len..], b);

    // return the number of bytes copied
    return a.len + b.len;
}

test "concatLen" {
    const h: []const u8 = "Howdy, ";
    const w: []const u8 = "world!";

    // output buffer
    var buf: [128]u8 = undefined; // memory is set aside but not initialised

    // write to buf and receive length
    const len = concatLen(h, w, &buf);

    // test string equality
    try testing.expectEqualStrings(h ++ w, buf[0..len]);

    // we could also have combined both the above into
    try testing.expectEqualStrings(h ++ w, buf[0..concatLen(h, w, &buf)]);
}

// take an output variable, return a slice from it
fn concatSlice(a: []const u8, b: []const u8, out: []u8) []u8 {
    // ensure we have enough memory
    std.debug.assert(out.len >= (a.len + b.len));

    // copy the bytes
    // NOTE: std.mem.copy is deprecated!
    // @memcpy requires destination and source to be equal length
    std.mem.copy(u8, out, a);
    std.mem.copy(u8, out[a.len..], b);

    // return the number of bytes copied
    return out[0 .. a.len + b.len];
}

test "concatSlice" {
    const h: []const u8 = "Howdy, ";
    const w: []const u8 = "world!";

    // output buffer
    var buf: [128]u8 = undefined; // memory is set aside but not initialised

    // write to buf and receive length
    const slice = concatSlice(h, w, &buf);

    // test string equality
    try testing.expectEqualStrings(h ++ w, slice);
}

// take an allocator, return bytes allocated with it, called must free bytes
fn concatAlloc(allocator: std.mem.Allocator, a: []const u8, b: []const u8) ![]u8 {
    // allocate required space
    const bytes = try allocator.alloc(u8, a.len + b.len);
    //errdefer allocator.free(bytes); // free the memory ONLY in the event of an error

    // copy the bytes
    // NOTE: std.mem.copy is deprecated!
    // @memcpy requires destination and source to be equal length
    std.mem.copy(u8, bytes, a);
    //try mayFail(); // <- will cause a memory leak without `errdefer`!
    std.mem.copy(u8, bytes[a.len..], b);

    // return the bytes
    return bytes;
}

test "concatAlloc" {
    const h: []const u8 = "Howdy, ";
    const w: []const u8 = "world!";
    const allocator = std.testing.allocator; // testing allocator will detect memory leaks

    // write to buf and receive slice
    const slice = try concatAlloc(allocator, h, w);
    defer allocator.free(slice); // defer a `free()` to prevent memory leak!

    // `defer` in Zig executes when exiting scope, not at when the function returns!

    // test string equality
    try testing.expectEqualStrings(h ++ w, slice);
}

fn mayFail() !void {
    return error.Boom;
}

// test foo in sections.zig
test {
    _ = @import("sections.zig");
}
