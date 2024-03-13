const std = @import("std");
const allocator = std.heap.wasm_allocator; // wasm requires a specific allocator

// WEB ASSEMBLY (WASM)

// the following functions are exported to and will be accessible in JS

/// add a to b, wrap on overflow
pub export fn add(a: i32, b: i32) i32 { // i32 is the primary integer data type used with WASM
    return a +% b;
}

/// subtract b from a, wrap on overflow
pub export fn sub(a: i32, b: i32) i32 {
    return a -% b;
}

/// allocate `len` bytes in WASM memory
/// return a many item pointer on success, null on failure
pub export fn alloc(len: usize) ?[*]u8 { // when dealing with WASM and sequential items in memory, we use a multi item pointer
    return if (allocator.alloc(u8, len)) |slice|
        slice.ptr // this is a multi item pointer
    else |_|
        null;
}

/// free `len` bytes in WASM memory
pub export fn free(ptr: [*]u8, len: usize) void {
    allocator.free(ptr[0..len]); // free our memory with slice syntax
}

/// called from JS but is used to print back to the browser console
pub export fn zlog(ptr: [*]const u8, len: usize) void {
    jsLog(ptr, len);
}

// we import this frunction *from* JS

/// log to the browser console
extern "env" fn jsLog(ptr: [*]const u8, len: usize) void;
