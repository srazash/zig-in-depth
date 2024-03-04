const std = @import("std");

pub fn main() !void {
    // TUPLES
    // tuples are an anonymous struct without field names

    // define a tuple typed constant
    // anonymous struct, no field names, assign values using a tuple literal
    const tuple_a: struct { u8, bool } = .{ 69, true };
    std.debug.print("tuple_a -> {any}, {}\n", .{ tuple_a, @TypeOf(tuple_a) });

    // we can access elements of tuples using index synatx (like an array)
    std.debug.print("tuple_a[0] -> {}\n", .{tuple_a[0]});
    std.debug.print("tuple_a[1] -> {}\n", .{tuple_a[1]});
    // and like an array, tuples have a `len` field too
    std.debug.print("tuple_a.len -> {}\n", .{tuple_a.len});

    // we can access fields using dot notation like a struct, but because
    // tuples do not have field names we use the index again with the `@`
    // operator
    std.debug.print("tuple_a.@\"0\" -> {}\n", .{tuple_a.@"0"});
    std.debug.print("tuple_a.@\"1\" -> {}\n", .{tuple_a.@"1"});

    // NOTE: `.@""` can be used anywhere an identifier can!
    // it allows otherwise illegal identifiers, such as those starting
    // with numbers or using reserved keywords
    const @"123_const" = 123;
    _ = @"123_const";
    const @"while" = "while";
    _ = @"while";

    // we can concatinate tuples with the array concatination operator (`++`)
    const tuple_b: struct { f16, i32 } = .{ 69.0, -420 };
    const tuple_c = tuple_a ++ tuple_b; // we use the `++` operator to do this
    std.debug.print("tuple_c -> {any}\n", .{tuple_c});
    std.debug.print("tuple_c.len -> {any}\n", .{tuple_c.len});
    std.debug.print("tuple_c[1] -> {}\n", .{tuple_c[1]});
    std.debug.print("tuple_c.@\"2\" -> {}\n", .{tuple_c.@"2"});
    std.debug.print("@TypeOf(tuple_c) -> {}\n", .{@TypeOf(tuple_c)});

    // tuples can be concatinated with other tuples, no matter what type they
    // contain. arrays always have the same type, we can concatinate a tuple
    // with an array AS LONG AS THEY CONTAIN THE SAME TYPES!
    const array: [3]u8 = .{ 1, 2, 3 };
    const tuple_d = .{ 4, 5, 6 };
    const result = array ++ tuple_d;
    std.debug.print("result -> {any}, {}\n", .{ result, @TypeOf(result) });

    // we can iterate over a tuple with an inline for
    std.debug.print("inline for over a tuple:\n", .{});
    inline for (tuple_c, 0..) |value, i| {
        std.debug.print("\t{}->{}\n", .{ i, value });
    }

    // we can index a pointer like we can index an array
    const ptr = &tuple_c;
    // accessing the index of a ptr dereferences the values automatically
    std.debug.print("ptr[0] -> {}\n", .{ptr[0]});
    std.debug.print("ptr.@\"0\" -> {}\n", .{ptr.@"0"});

    // we can use the array multiplication operator (`**`)
    const tuple_e = tuple_a ** 2;
    std.debug.print("tuple_e -> {any}\n", .{tuple_e});

    // we can use a tuple to pass in multiple arguments to a function
    // this is done with comptime type reflection
    // SEE `VARARGSINZIG()`
    varargsInZig(.{ 69.0, 420, "ayooo", false });
    //varargsInZig(420);
}

fn varargsInZig(args: anytype) void {
    // get type info
    const args_info = @typeInfo(@TypeOf(args));

    // check if it is a tuple
    if (args_info != .Struct) @panic("not a struct");
    if (!args_info.Struct.is_tuple) @panic("not a tuple");

    // use the args
    inline for (args) |arg| std.debug.print("{any}\n", .{arg});
}
