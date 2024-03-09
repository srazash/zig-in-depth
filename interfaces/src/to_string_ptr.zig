const std = @import("std");

/// a pointer interface for anything that can be turned into a string
pub const Stringer = struct {
    ptr: *anyopaque, // anyopaque is a "type-erased pointer"
    toStringFn: *const fn (*anyopaque, []u8) anyerror![]u8, // a pointer to a fn, matches the toString fn signature

    // Implements our interface by returning an implementation of toString
    pub fn toString(self: Stringer, buf: []u8) anyerror![]u8 {
        return self.toStringFn(self.ptr, buf);
    }
};

// the User and Animal structs can be implemented anywhere, we only need to ensure they satisfy the Stringer interface

/// User implementation
pub const User = struct {
    name: []const u8,
    email: []const u8,

    pub fn toString(ptr: *anyopaque, buf: []u8) ![]u8 {
        var self: *User = @ptrCast(@alignCast(ptr)); // cast our pointer and align cast (because of anyopaque's unknown pointer size)
        return std.fmt.bufPrint(buf, "User(name: {[name]s}, email: {[email]s})", self.*);
    }

    // returns the stringer interface for User
    pub fn stringer(self: *User) Stringer {
        return .{
            .ptr = self,
            .toStringFn = User.toString,
        };
    }
};

/// Animal implementation
pub const Animal = struct {
    name: []const u8,
    sound: []const u8,

    pub fn toString(ptr: *anyopaque, buf: []u8) ![]u8 {
        var self: *Animal = @ptrCast(@alignCast(ptr));
        return std.fmt.bufPrint(buf, "{[name]s} says \"{[sound]s}\"", self.*);
    }

    pub fn stringer(self: *Animal) Stringer {
        return .{
            .ptr = self,
            .toStringFn = Animal.toString,
        };
    }
};
