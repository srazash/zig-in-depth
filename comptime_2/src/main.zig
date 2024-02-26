const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // COMPTIME II

    // comptime expression evaluation
    // const values are comptime known as they cannot change during runtime
    const condition = false;

    // condition is comptime known, so it is evaluated at comptime
    if (condition) {
        @compileError("condition is true");
    }

    // inline for
    const nums = [_]i32{ 2, 4, 6 };
    var sum: usize = 0;

    // and inline for is unrolled, each branch of the switch statement handles a different type
    // at comptime Zig will create a different for, for each type it handles, this can only happen
    // at comptime which is why we need an inline for
    inline for (nums) |i| {
        // a non-inline for can't deal with types, for it is required here
        const T = switch (i) {
            2 => f32,
            4 => i8,
            6 => bool,
            else => unreachable, // we use `unreachable` here as this branch will never be reached
        };
        sum += typeNameLength(T);
    }

    print("inline for sum -> {}\n\n", .{sum}); // 9

    // inline while
    sum = 0;
    // we need a comptime var for our inline while because the while loop is evaluated at comptime
    comptime var i = 0;

    // an inline while loop is also unrolled much like our inline for
    inline while (i < 3) : (i += 1) {
        // inlining our while mean it can deal with types too
        const T = switch (i) {
            0 => f32,
            1 => i8,
            2 => bool,
            else => unreachable, // we use `unreachable` here as this branch will never be reached
        };
        sum += typeNameLength(T);
    }

    print("inline while sum -> {}\n\n", .{sum}); // 9

    // testing both inline for and inline switch branches
    print("isOptFor A -> {}\n", .{isOptFor(A, 1)});
    print("isOptFor B -> {}\n\n", .{isOptFor(B, 1)});

    print("isOptSwitch A -> {}\n", .{isOptSwitch(A, 1)});
    print("isOptSwitch B -> {}\n\n", .{isOptSwitch(B, 1)});

    // testing inline else
    const a: U = .{ .a = .{ .a = 0, .b = null } };
    const b: U = .{ .b = .{ .a = 0, .b = 0 } };

    print("a.hasImpl() -> {}\n", .{a.hasImpl()});
    print("b.hasImpl() -> {}\n\n", .{b.hasImpl()});

    // runtime function evaluation
    print("runtime fib(7) -> {}\n", .{fib(7)}); // ruuning fib() within a print forces runtime evaluation

    // comptime function evaluation
    const ct_fib = comptime ctf: {
        break :ctf fib(7); // calling fib() as as part of this comptime block means the function is evaluation at comptime
    };

    // we could also call the function with the `comptime` keyword, without using a block and lable
    const unwanted_ct_fib = comptime fib(7);
    _ = unwanted_ct_fib;

    print("comptime fib(7) -> {}\n", .{ct_fib});
}

// this function requires a comptime type parameter, again because we are working with types
fn typeNameLength(comptime T: type) usize {
    return @typeName(T).len;
}

// struct with optional field and `impl` declaration
const A = struct {
    a: u8,
    b: ?u8,

    fn impl() void {}
};

// struct without optional field and no `impl` declaration
const B = struct {
    a: u8,
    b: u8,
};

// using an inline for
// return true if a field is optional
fn isOptFor(comptime T: type, field_index: usize) bool {
    const fields = @typeInfo(T).Struct.fields;

    // this will be unrolled at comptime
    inline for (fields, 0..) |field, i| {
        if (field_index == i and @typeInfo(field.type) == .Optional) return true;
    }

    return false;
}

// using a switch with inline branches
// like `isOptFor` returns true if a field is optional
fn isOptSwitch(comptime T: type, field_index: usize) bool {
    const fields = @typeInfo(T).Struct.fields;

    return switch (field_index) {
        // for all eleents in fields, capture the index (i), check if it optional and return true of it is
        inline 0...fields.len - 1 => |i| @typeInfo(fields[i].type) == .Optional,
        else => false,
    };
}

// a tagged union with the fields of both A and B struct types
const U = union(enum) {
    a: A,
    b: B,

    // using an inline else to handle all variations
    fn hasImpl(self: U) bool {
        return switch (self) {
            // the inline else will unroll for each field of the struct
            inline else => |s| @hasDecl(@TypeOf(s), "impl"),
        };
    }
};

// a normal function that requires no runtime context can be comptime automatically
// even if it has no inline or comptime elelemnts, Zig will evaluate it at comptime if possible
fn fib(n: usize) usize {
    if (n < 2) return n;

    var a: usize = 0;
    var b: usize = 1;
    var i: usize = 0;

    while (i < n) : (i += 1) {
        const tmp = a;
        a = b;
        b = tmp + b;
    }

    return a;
}
