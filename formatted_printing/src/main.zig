const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n\n", .{"codebase"});

    // first argument in the print statement is a format string, must be comptime known
    // second argument is a tuple literal containing a list of arguments to pass into
    // placeholders ({}) in our format string
    // {s} <- format specifier for a slice, used with strings ([]const u8)

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    // buffering is faster than the overhead created by printing directly to stdout
    const stdout = bw.writer();

    // stdout.print is very similar to std.debug.print BUT we need to `try` as we may
    // need to handle an error, std.debug.print produces no errors
    try stdout.print("Hellope.\n", .{});

    try stdout.print("\n", .{});

    // all print functions take a comptime format string that can contain placeholders
    // for argument to print into. These placeholders are called format specifiers:
    // `{<argument><specifier>:<fill><alignment><width>.<precision>}`

    const float: f64 = 3.141592;
    try stdout.print("float:\nno formatting -> `{}`\nformat as decimal -> `{0d}`,\nalign and fill -> `{0d:_<10.2}` `{0d:_^10.2}` `{0d:_>10.2}`\n", .{float});

    // argument = {0...}, the index of our argument, the first placeholder is always argument 0
    // specifier = type, `d` <- decimal, a numeric value
    // fill = filling character when we have a width larger than the value
    // alignment = < left align, ^ centre align, > right align
    // width = overall width, which will be filled if our value does not fill it
    // precision = number of decimal places for floats

    try stdout.print("\n", .{});

    // integers can be formatted as decimal, binary, hex, octal, ASCII or Unicode (UTF-8)
    const int: u8 = 42;
    try stdout.print("int decimal -> {d}\n", .{int}); // d for Decimal
    try stdout.print("int binary -> {b}\n", .{int}); // b for Binary
    try stdout.print("int octal -> {o}\n", .{int}); // o for Octal
    try stdout.print("int hex -> {x}\n", .{int}); // x for heX
    try stdout.print("int ASCII -> {c}\n", .{int}); // c like Char
    try stdout.print("int Unicode -> {u}\n", .{int}); // u for Unicode

    try stdout.print("\n", .{});

    // s is for Strings or anything that can be Sliced
    const string = "Howdy, pardner!";
    try stdout.print("string -> `{s}`\nalign and fill -> {0s:_^20}\n", .{string});
    const slice = string[7..14]; // 'pardner'
    try stdout.print("slice of string -> `{s}`\nalign and fill -> {0s:_^20}\n", .{slice});

    try stdout.print("\n", .{});

    // optionals are formatted using the optional `?` operator
    // no using this when we pass in an optional will cause a comptime error
    const optional: ?u8 = 69;
    try stdout.print("optional -> `{?}` `{?}`\n", .{ optional, @as(?u8, null) });

    // we can apply additional fromatting to an optional
    // here we right align an optional decimal and right align with a fill of 0s
    try stdout.print("optional formatted -> `{?d:0>10}`\n", .{optional});

    try stdout.print("\n", .{});

    // error unions, like optionals are formatted with the `!` operator
    const error_union: anyerror!u16 = error.WrongNumber;
    try stdout.print("error union -> `{!}` `{!}`\n", .{ error_union, @as(anyerror!u16, 420) });
    // again we can apply additional formatting
    try stdout.print("error union -> `{!d:0>10}`\n", .{@as(anyerror!u16, 420)});

    try stdout.print("\n", .{});

    // for pointers we can use default format specifier or the pointer operator `*` when formatting
    // when deferencing we apply the format of the dereferenced type (decimal format for a float in this case)
    const ptr = &float;
    try stdout.print("pointer -> `{*}` `{0}` `{d:.3}`\n", .{ ptr, ptr.* });

    try stdout.print("\n", .{});

    const S = struct {
        a: bool = true,
        b: f16 = 3.142,
    };
    const s = S{}; // S struct with default values

    // usually we use a tuple literal to pass in arguments, but because we have a struct we can pass that in instead
    try stdout.print("s -> `{[a]}` `{[b]d:0>10.3}`\n", s); // we need to access the fields by name using `[]` square brackets
    try stdout.print("s -> `{}` `{d:0>10.3}`\n", .{ s.a, s.b }); // or we can pass in the fields individually

    try stdout.print("\n", .{});

    // when we need to format a string to use within our program we can either
    // 1. print using a fixed buffer with `std.fmt.bufPrint()`:
    var buffer: [256]u8 = undefined;
    const str = try std.fmt.bufPrint(&buffer, "`{[a]}` `{[b]d:0>10.3}\n", s);
    try stdout.print("str -> {s}", .{str});

    // 2. use an allocator with `std.fmt.allocaPrint()`:
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const str_alloc = try std.fmt.allocPrint(allocator, "`{[a]}` `{[b]d:0>10.3}\n", s);
    defer allocator.free(str_alloc);
    try stdout.print("str_alloc -> {s}", .{str_alloc});

    try stdout.print("\n", .{});

    // to print a literal `{` or `}` we repeat them in the formatting string
    try stdout.print("curly braces -> `{{}}`\n", .{});

    try stdout.print("\n", .{});

    try bw.flush(); // don't forget to flush!

    // the same rules for formatting apply to debug and log output
    std.debug.print("debug print -> {d:.3}\n", .{float});
    // log inserts a newline automatically
    std.log.debug("log debug -> {d:.3}", .{float});
    std.log.info("log info -> {d:.3}", .{float});
    std.log.warn("log warn -> {d:.3}", .{float});
    std.log.err("log err -> {d:.3}", .{float});

    std.debug.print("\n", .{});

    // `any` can print anything, which is very useful for debugging
    std.debug.print("any -> `{any}` `{any}` `{any}`\n", .{ s, string, float });
}
