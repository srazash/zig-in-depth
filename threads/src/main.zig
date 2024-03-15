const std = @import("std");

// CONCURRENCY IN ZIG WITH THREADS

fn work(id: usize, name: []const u8) void {
    std.time.sleep(1 * std.time.ns_per_s);
    std.debug.print("{s} -> {} finished\n", .{ name, id });
}

pub fn main() !void {
    const cpus = try std.Thread.getCpuCount();

    std.debug.print("this machine has {} cpu(s)\n", .{cpus});

    // no threads
    std.debug.print("without threading:\n", .{});
    for (0..cpus) |i| work(i, "W"); // this will run sequentially

    // manual threading with `join()`
    std.debug.print("manual threading with `join()`:\n", .{});
    // we're cheating here as the number of threads must be comptime known and not exceed the number of logical cpus (1 thread per cpu core)
    // in production where we cannot know the number of logical cpus a computer has beforehand we would allocate this value at runtime
    var handles: [8]std.Thread = undefined;
    for (0..cpus) |i| handles[i] = try std.Thread.spawn(.{}, work, .{ i, "J" });
    for (handles) |h| h.join();
    // NOTE: using `join()` we cannot guarantee the order of execution!

    // manual threading with `detach()`
    std.debug.print("manual threading with `detach()`:\n", .{});
    // `detach()` spawns threads detached from the main thread, this means the main thread may continue executing
    // before the detached thread have completed!
    for (0..cpus) |i| {
        var handle = try std.Thread.spawn(.{}, work, .{ i, "D" });
        handle.detach();
    }
    // NOTE: using `detach()` we cannot guarentee that all threads will complete before the main thread continßues execution

    std.time.sleep(1001 * std.time.ns_per_ms); // main thread continues executing

    // thread pools
    std.debug.print("threading with thread pools:\n", .{});
    // a thread pool requires an allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit(); // deinitialise our allocator
    const allocator = gpa.allocator();

    // we initialise a pool
    var pool: std.Thread.Pool = undefined;
    try pool.init(.{ .allocator = allocator });
    defer pool.deinit(); // deinitialise our pool

    // we `spawn()` threads in the pool
    for (0..cpus) |i| try pool.spawn(work, .{ i, "P" });
    // NOTE: execution of threads is limited to the number of logical cpus we have BUT
    // this is not a limit for the thread pool, as we can `spawn()` any number of jobs to execute
    // and the pool will execute them in batches until complete
}
