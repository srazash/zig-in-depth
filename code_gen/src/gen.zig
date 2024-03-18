const std = @import("std");

pub fn main() !void {
    var args = std.process.args();
    _ = args.next(); // discard first arg (always the binary name)

    // access filename arg passed in from build.zig
    const filename = args.next().?;

    // using the arg passed in as the filename means we'll use the build
    // systems cached version and only regenerate if required
    var file = try std.fs.cwd().createFile(filename, .{}); // create file
    defer file.close(); // defer a file close
    var bw = std.io.bufferedWriter(file.writer()); // create a buffered writer
    const writer = bw.writer();

    const content_head =
        \\pub const fib = [_]usize{
    ;
    try writer.writeAll(content_head);

    // access the fib-end arg passed in from build.zig
    const n = try std.fmt.parseInt(usize, args.next().?, 10);

    for (0..n) |i| {
        if (i != 0) try writer.writeAll(", ");
        try writer.print("{}", .{fib(i)});
    }

    const content_tail =
        \\ };
        \\
    ;
    try writer.writeAll(content_tail);

    try bw.flush(); // flush our buffered writer
}

// standard looping finbonacci function
fn fib(n: usize) usize {
    if (n < 2) return n;

    var a: usize = 0;
    var b: usize = 1;

    for (0..n) |_| {
        var tmp = a;
        a = b;
        b = tmp + b;
    }

    return a;
}
