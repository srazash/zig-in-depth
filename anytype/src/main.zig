const std = @import("std");
const print = @import("std").debug.print;

// ANYTYPE
// anytype is Zig's version of duck typing:
// if it walks like a duck, and it quacks like a duck - it's a duck
// in Zig all duck typing (anytype) is evaluated and performed at comptime
const A = struct {
    // method
    fn toString(_: A) []const u8 {
        return "A";
    }
};

const B = struct {
    // function
    fn toString(s: []const u8) []const u8 {
        return s;
    }
};

const C = struct {
    // const declaration
    const toString: []const u8 = "C";
};

const D = enum {
    // fields
    d,
    e,

    // method
    fn toString(self: D) []const u8 {
        return @tagName(self);
    }
};

fn prnt(x: anytype) void {
    const T = @TypeOf(x); // get the type of `x`

    // do we have a `toString` declaration?
    if (!@hasDecl(T, "toString")) return; // if not, return

    // is it a function?
    const decl_type = @TypeOf(@field(T, "toString"));
    if (@typeInfo(decl_type) != .Fn) return; // if not, return

    // is that function a method?
    const args = std.meta.ArgsTuple(decl_type); // returns a tuple of parameter types
    inline for (std.meta.fields(args), 0..) |arg, i| {
        if (i == 0 and arg.type == T) { // if the first parameter is of type T...
            // we know we can call it as a method, so we do
            print("{s}\n", .{x.toString()});
        }
    }
}

pub fn main() !void {
    const a = A{};
    const b = B{};
    const c = C{};
    const d = D.d;

    prnt(a);
    prnt(b);
    prnt(c);
    prnt(d);
}
