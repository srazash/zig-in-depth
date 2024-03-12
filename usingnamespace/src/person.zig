const std = @import("std");

pub const Person = struct {
    Name: []const u8,
    Age: u8,

    const Self = @This();

    pub fn getName(self: Self) []const u8 {
        return self.Name;
    }

    pub fn getAge(self: Self) u8 {
        return self.Age;
    }

    pub fn printNameAndAge(self: Self) void {
        std.debug.print("Name -> {s}, Age -> {d}\n", .{ self.Name, self.Age });
    }
};
