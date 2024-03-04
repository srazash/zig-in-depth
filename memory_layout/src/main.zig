const std = @import("std");

// MEMORY LAYOUT

// an `extern struct` has a guaranteed memory layout which is compatible with
// the C ABI. Padding ensures alignment of fields and field order is preserved
// as it is in source code.
const Extern = extern struct {
    a: u16, // natural align 2 bytes
    b: u64, // natural align 8 bytes
    c: u16, // natural align 2 bytes
};
// Padding here means that all fields take up 8 bytes so that `b` has the
// correct alignment in memory. So this means that this `extern struct` is
// 24 bytes in total.

// a normal `struct` in Zig has no guarantees regarding its memory layout.
// The compiler will determine the optimal layout, which may include padding
// to ensure proper alignment of fields.
const Normal = struct {
    a: u16,
    b: u64,
    c: u16,
};

// A `packed struct` preserved field order but packs the fields together with
// no padding between, so fields only use their actual bit width in size.
// Padding may be used at the end to esure alignment of the struct in memory.
const Packed = packed struct {
    a: u16,
    b: u64,
    c: u16,
};

pub fn main() !void {
    printInfo(Extern); // order preserved, padding between fields
    printInfo(Normal); // order not preserved, no padding
    printInfo(Packed); // order preserved, padding after fields

    std.debug.print("\n", .{});

    // packed structs can be bit casted because we can guarantee order and
    // no padding between fields
    const w = Whole{
        .num = 0x1234,
    }; // 0x1234

    const p: Parts = @bitCast(w); // 0x34, 0x2, 0x1 <- order defined by
    // endianess of the CPU! this is little endian on most consumer CPUs

    std.debug.print("w.num: 0x{x}\n", .{w.num});
    std.debug.print("p.half: 0x{x}\n", .{p.half});
    std.debug.print("p.q3: 0x{x}\n", .{p.q3});
    std.debug.print("p.q4: 0x{x}\n", .{p.q4});
}

fn printInfo(comptime T: type) void {
    std.debug.print("size of {s} -> {}\n", .{ @typeName(T), @sizeOf(T) });

    inline for (std.meta.fields(T)) |field| {
        std.debug.print("\tfield {s} byte offset -> {}\n", .{ field.name, @offsetOf(T, field.name) });
    }
}

const Whole = packed struct {
    num: u16,
};

const Parts = packed struct {
    half: u8,
    q3: u4,
    q4: u4,
};
