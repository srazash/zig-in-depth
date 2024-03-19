const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const io = std.io;

fn populate(dir: *fs.Dir) !void {
    for (0..3) |i| {
        // format file name
        var buf: [8]u8 = undefined;
        const filename = try fmt.bufPrint(&buf, "file_{}", .{i});
        // create file
        var file = try dir.createFile(filename, .{});
        // defer file close
        defer file.close();
        // buffer the writes for performance, more critical where there are multiple writes
        var buf_writer = io.bufferedWriter(file.writer());
        const writer = buf_writer.writer();
        // use `print()` for formatted output
        _ = try writer.print("This is file_{}.\n", .{i});
        // flush the buffer
        try buf_writer.flush();
    }
}

pub fn main() !void {
    // create (if it doesn't already exist) and open a directory, relative to the current directory
    var sub_2 = try fs.cwd().makeOpenPath("test_dir/sub_1/sub_2", .{});
    // clean up on exit, delet directory and all sub directories and files
    defer fs.cwd().deleteTree("test_dir") catch |err| debug.print("error deleting dir tree: {}\n", .{err});
    // close directory
    defer sub_2.close();

    // populate directory with files
    try populate(&sub_2);

    // open another directory
    // NOTE: we only `openDir()` this directory, as it was created when we `makeOpenPath()` above
    var sub_1 = try fs.cwd().openDir("test_dir/sub_1", .{});
    defer sub_1.close();
    try populate(&sub_1);

    // and again in the root dir!
    var test_dir = try fs.cwd().openDir("test_dir", .{});
    defer test_dir.close();
    try populate(&test_dir);

    // we need an allocator to walk the tree
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // create an iterator of the tree
    var iter = try fs.cwd().openIterableDir("test_dir", .{});
    defer iter.close();

    // obtain a walker, the walker handles recursively iterating over the tree for us
    // where the iterator would not
    var walker = try iter.walk(allocator);
    defer walker.deinit();

    // iterate over the tree with the walker
    while (try walker.next()) |entry| {
        debug.print("{s} ({s}) ", .{ entry.path, @tagName(entry.kind) });

        if (entry.kind == .file) {
            // open the file
            var file = try entry.dir.openFile(entry.basename, .{});
            defer file.close();

            // buffer the read for better persormance
            var buf_reader = io.bufferedReader(file.reader());
            const reader = buf_reader.reader();

            var buf: [4096]u8 = undefined;
            while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
                debug.print("-> {s}", .{line});
            }
        }

        debug.print("\n", .{});
    }
}
