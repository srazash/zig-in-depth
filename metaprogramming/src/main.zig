const std = @import("std");
const meta = std.meta;

// METAPROGRAMMING
// Zig's metaprogramming happens at comptime
// the standard library has the `std.meta` namespace for dealing with
// metaprogramming tasks

// `meta.Tag` is used to obtain the tag type for a tagged union
const Number = union(enum) {
    int: i32,
    float: f32,

    fn is(self: Number, tag: meta.Tag(Number)) bool {
        return self == tag;
    }
};

pub fn main() !void {
    // meta.Tag
    var num: Number = .{ .int = 69 };
    std.debug.print("num.is(.int) -> {}\n", .{num.is(.int)});
    num = .{ .float = 3.141592 };
    std.debug.print("num.is(.float) -> {}\n", .{num.is(.float)});

    // meta.activeTag returns the active tage of a tagged union
    std.debug.print("active tag -> {s}\n", .{@tagName(meta.activeTag(num))});

    // meta.stringToEnum turns a string into an enum field
    // functionally the opposite of @tagName
    const NumberTagEnum = meta.Tag(Number);
    std.debug.print("Number.int == \"int\" -> {}\n", .{NumberTagEnum.int == meta.stringToEnum(NumberTagEnum, "int")});

    // meta.Child returns the type of elements of anything that can have
    // elements, or the payload of anything that can have a payload.
    // e.g. slices, arrays, optionals
    std.debug.print("element type of []const u8 -> {}\n", .{meta.Child([]const u8)});
    std.debug.print("payload type of ?u8 -> {}\n", .{meta.Child(?u8)});

    // meta.Sentinel converts any non-sentinel type to a sentinel type
    std.debug.print("`[]const u8` to sentinel terminated `[]const u8` -> {}\n", .{meta.Sentinel([]const u8, 0)});

    // meta.containerLayout returns the memory layout of a type
    std.debug.print("memory layout of a zig struct -> {s}\n", .{@tagName(meta.containerLayout(struct { a: u8 }))});
    std.debug.print("memory layout of a extern struct -> {s}\n", .{@tagName(meta.containerLayout(extern struct { a: u8 }))});
    std.debug.print("memory layout of a packed struct -> {s}\n", .{@tagName(meta.containerLayout(packed struct { a: u8 }))});

    // meta.fields returns the fields of a type like structs, enums, unions, error sets
    const fields = meta.fields(struct { a: u8, b: i64, c: f32 });
    // because the type data is only available at comptime we must use an inline for loop
    inline for (fields) |field| std.debug.print("{s} -> {}\n", .{ field.name, field.type });

    // meta.tags returns an array containing the fields of an enum or error set
    const tags = meta.tags(enum { a, b, c });
    for (tags, 0..) |tag, i| std.debug.print("tags[{}] -> {s}\n", .{ i, @tagName(tag) });

    // meta.FieldEnum creates an enum from the fields of a type
    const FE = meta.FieldEnum(struct { a: u8, b: i64, c: f32 });
    std.debug.print("FE.b -> {s}\n", .{@tagName(FE.b)});

    // meta.DeclEnum creates an enum from the public declarations of a type
    const DE = meta.DeclEnum(struct {
        pub const a: u8 = 0;
        pub const b: i64 = 0;
        pub const c: f32 = 0.0;
    });
    std.debug.print("DE.b -> {s}\n", .{@tagName(DE.b)});

    // meta.eql tests for the equality of types
    const S1 = struct { a: u8, b: bool };
    const s_1 = S1{ .a = 69, .b = true };
    const s_2 = S1{ .a = 69, .b = true };
    const s_3 = S1{ .a = 72, .b = false };
    std.debug.print("s_1 == s_2 -> {}\n", .{meta.eql(s_1, s_2)});
    std.debug.print("s_1 == s_3 -> {}\n", .{meta.eql(s_1, s_3)});

    // meta.fieldIndex returns the index of a field of a type as defined in source code
    std.debug.print("S1.b index -> {?}\n", .{meta.fieldIndex(S1, "b")});

    // meta.Int create an integer type of a specified sign type and bit width
    const bits = comptime std.math.log2_int_ceil(usize, 1_000_000); // comptime keyword used to pass in comptime T
    std.debug.print("bits required to represent 1 million -> {}\n", .{bits});
    std.debug.print("int type to store 1 million -> {}\n", .{meta.Int(.unsigned, bits)});

    // meta.isError returns a bool indicating is an error union is an error type
    var maybe_error: anyerror!u8 = error.NotANumber;
    std.debug.print("maybe_error an error? -> {}\n", .{meta.isError(maybe_error)});
    maybe_error = 69;
    std.debug.print("maybe_error an error? -> {}\n", .{meta.isError(maybe_error)});
}
