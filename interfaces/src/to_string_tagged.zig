const std = @import("std");

/// a tagged union interface for anything that can be turned into a string
pub const Stringer = union(enum) {
    user: User,
    animal: Animal,

    // if we want to add more implementations we need to do so here
    // which is why we need control over the source code, if that isn't a
    // problem then this is the simplest and most performant option

    pub fn toString(self: Stringer, buf: []u8) ![]u8 {
        return switch (self) {
            inline else => |itself| itself.toString(buf),
        };
    }
};

// User implementation
pub const User = struct {
    name: []const u8,
    email: []const u8,

    pub fn toString(self: User, buf: []u8) ![]u8 {
        return std.fmt.bufPrint(buf, "User(name: {[name]s}, email: {[email]s})", self);
    }
};

// Animal implementation
pub const Animal = struct {
    name: []const u8,
    sound: []const u8,

    pub fn toString(self: Animal, buf: []u8) ![]u8 {
        return std.fmt.bufPrint(buf, "{[name]s} says \"{[sound]s}\"", self);
    }
};
