const std = @import("std");

// STRUCT FORMATTING

const Method = enum {
    get,
    post,
    put,

    // we can print a struct using the default format specifier
    // we define a `format()` method to do this
    // typically this only needs a `writer` argument and a pointer to the struct instance (self)
    pub fn format(
        self: Method, // self
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype, //writer
    ) !void {
        switch (self) {
            .get => try writer.writeAll("GET"),
            .post => try writer.writeAll("POST"),
            .put => try writer.writeAll("PUT"),
        }
    }
};

const Encoding = enum {
    brotli,
    deflate,
    gzip,

    pub fn format(
        self: Encoding,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        switch (self) {
            .brotli => try writer.writeAll("br"),
            // inline else will create options for all remaining options
            // `@tagName()` will return the string version of the enum options
            inline else => |enc| try writer.writeAll(@tagName(enc)),
        }
    }
};

const Version = enum {
    // we use the `@""` syntax to use characters that would normally be illegal
    @"1.0",
    @"1.1",
    @"2",
    @"3",

    pub fn format(
        self: Version,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        switch (self) {
            // inline else to return "HTTP/x.x" for all versions
            inline else => |ver| try writer.writeAll("HTTP/" ++ @tagName(ver)),
        }
    }
};

const Request = struct {
    accept: []const Encoding = &.{
        .deflate,
        .gzip,
        .brotli,
    },
    body: []const u8 = "Howdy pardner!\n",
    method: Method = .get,
    path: []const u8 = "/",
    version: Version = .@"1.1",

    pub fn format(
        self: Request,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        // multiline string can be very helpful when preparing conplex format strings
        const fmt_str_1 =
            \\{} {s} {}
            \\Accept-Heading: 
        ;
        _ = try writer.print(fmt_str_1, .{ self.method, self.path, self.version });

        // to print out a comma-separated list we loop over the items of the accept slice
        for (self.accept, 0..) |enc, i| {
            if (i != 0) try writer.writeAll(", ");
            _ = try writer.print("{}", .{enc});
        }

        const fmt_str_2 =
            \\
            \\
            \\{s}
        ;
        _ = try writer.print(fmt_str_2, .{self.body});
    }
};

pub fn main() !void {
    var req = Request{};
    std.debug.print("{}\n", .{req}); // our format functions print to any print functions

    req.method = .put;
    req.path = "/about.html";
    req.accept = &.{.gzip};
    req.body = "About";
    std.debug.print("{}\n", .{req});
}
