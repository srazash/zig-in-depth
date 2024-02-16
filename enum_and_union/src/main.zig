const std = @import("std");
const print = @import("std").debug.print;

// ENUM & UNION

// enums auto-asign integer values starting at 0
// enums use the smallest possible unsigned integer type to do this
// const Colour = enum(u8) { <- it is possible to explicitly type our enums
const Colour = enum {
    red, // 0
    green, // 1
    blue, // 2

    // an enum can be non-exhaustive by including `_` as an option
    //_, <- including this does require explicitly typing the enum!

    // enums can contain namespace functions (methods)
    fn isRed(self: Colour) bool {
        return self == .red;
    }
};

// a union is a compount data type that is sized for the size of the used type
// so we could have an array of type Number, and each element will only use
// the size of used given type: so an array with an f32, f32, f64, f32 = 20 bytes
// because we only needed 4 bytes for the f32's and 8 bytes for the f64
const Number = union {
    float: f32,
    double: f64,
}; // unions can also have methods

// tagged union
const Token = union(enum) {
    keyword_if, // default type is void
    keyword_switch: void,
    digit: usize,

    fn is(self: Token, tag: std.meta.Tag(Token)) bool {
        return self == tag;
    }
};

pub fn main() !void {
    // accessing the enum using . notation is the idomatic way to do so
    const my_colours = [_]Colour{ .red, .green, .blue };

    for (my_colours) |c| {
        // we can get the integer value and name of enums using @intFromEnum() and @tagName
        print("{s} ({d}) is red? -> {any}\n", .{ @tagName(c), @intFromEnum(c), Colour.isRed(c) });
    }

    const favourite_colour: Colour = @enumFromInt(2);

    // enums work particularly well when paired with the switch statement
    print("My favourite colour is ", .{});
    switch (favourite_colour) {
        .red => print("red.\n", .{}),
        .green => print("green.\n", .{}),
        .blue => print("blue.\n", .{}),
    }

    // unions types can only be of a single type from the union
    var number: Number = .{ .float = 3.142 }; // this is a float
    print("Number was: {d}\n", .{number.float}); // we have to specify the type
    number = .{ .double = 3.14159 }; // this is now a double
    print("Number is: {d}\n", .{number.double});
    // but in both are Number type

    // Tagged unions get the benefits of both enums and unions
    var tok: Token = .keyword_if;
    print("Is if? {}\n", .{tok.is(.keyword_if)});

    // and are very powerful when paired with switch statements and payload capture
    switch (tok) {
        .keyword_if => print("If.\n", .{}),
        .keyword_switch => print("Switch.\n", .{}),
        .digit => |d| print("Digit -> {d}\n", .{d}),
    }

    tok = .{ .digit = 69 };
    switch (tok) {
        .keyword_if => print("If.\n", .{}),
        .keyword_switch => print("Switch.\n", .{}),
        .digit => |d| print("Digit -> {d}\n", .{d}),
    }

    // we can compare a tagged union with the enum tag name
    if (tok == .digit and tok.digit == 69) print("Nice.\n", .{});
}
