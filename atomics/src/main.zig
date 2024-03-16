const std = @import("std");
const Atomic = std.atomic.Atomic;
const time = std.time;
const Thread = std.Thread;

// ATOMICS
// atomics are an alternative to Mutex and RwLocks, atomics ensure any given
// operation cannot be interrupted or broken up by another operation, atomics
// are controlled by the CPU which has specific instructions to perform an
// atomic operation which guarantee thread and memory safety while doing so

// NOTE: The following is for demonstration only!
// std.Threads.WaitGroup is available to do this in production code!
const WaitGroup = struct {
    members: Atomic(usize), // generally use a primitive type, like usize

    fn init() WaitGroup {
        return .{ .members = Atomic(usize).init(0) }; // initialise a WaitGroup with 0 members
    }

    // New member joins the group
    fn add(self: *WaitGroup) void {
        _ = self.members.fetchAdd(1, .Acquire); // like a mutex/rwlock lock
    }

    // Existing member leaves the group
    fn done(self: *WaitGroup) void {
        _ = self.members.fetchSub(1, .Release); // like a mutex/rwlock unlock
    }

    // Wait for all members to leave
    fn wait(self: WaitGroup) void {
        // Use .Monotonic when ordering isn't crucial
        while (self.members.load(.Monotonic) > 0) time.sleep(500 * time.ns_per_ms); // "spinning", inefficient but good for demonstration
    }
};

// A sample worker thread
fn worker(id: usize, wg: *WaitGroup) void {
    // Signal we're leaving the wait group on exit
    defer wg.done();

    std.debug.print("{} started\n", .{id});
    time.sleep(1 * time.ns_per_ms);
    std.debug.print("{} finished\n", .{id});
}

pub fn main() !void {
    // Create the wait group
    var wg = WaitGroup.init();
    // Ensure we wait for all members of the wait group to leave before exiting main
    defer wg.wait();

    for (0..5) |i| {
        // Add a member to the wait group
        wg.add();
        // Spawn the thread
        const thread = Thread.spawn(.{}, worker, .{ i, &wg }) catch |err| {
            // Remove from wait group on error so wg.wait() doesn't wait forever
            wg.done();
            return err;
        };
        // No need to join, we'll wait via the wait group
        thread.detach();
    }
}
