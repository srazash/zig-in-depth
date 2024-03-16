const std = @import("std");
const debug = std.debug;
const time = std.time;
const Thread = std.Thread;

// imports for multex
//const Mutex = std.Thread.Mutex;

// import for rwlock
const RwLock = std.Thread.RwLock;

// MUTEX AND RWLOCK
// threading is non-deterministic, so we need a way to protect data
// from different threads accessing data at the same time, we do this
// mutex and rwlocks (read-write lock)

// mutex can cause contention where there are a lot of reads causing a lock
// which slows down write access, this is where rwlocks come in
// NOTE: RwLock does come with an additional resource hit compared to mutex
// so use it only when required, such as where there are a lot of reads but
// write needs to be done quickly!

const Counter = struct {
    //lock: Mutex = .{}, // here we create a mutex field, by default the state is unlocked
    lock: RwLock = .{}, // here we create a RwLock field
    count: u8 = 0,

    fn increment(self: *Counter) void {
        self.lock.lock(); // we use the lock before we begin any read/write operations, same for mutex and RwLock
        defer self.lock.unlock(); // defer an unlock

        const before = self.count;
        time.sleep(250 * time.ns_per_ms);
        self.count +%= 1; // wrapping increment
        debug.print("write count: {} -> {}\n", .{ before, self.count });
    }

    fn print(self: *Counter) void {
        //self.lock.lock(); // mutex lock
        self.lock.lockShared(); // RwLock lock - non exclusive lock that allows multiple reads
        defer self.lock.unlock();

        debug.print("read count: {}\n", .{self.count});
    }
};

fn incrementCounter(counter: *Counter) void {
    while (true) {
        time.sleep(500 * time.ns_per_ms);
        counter.increment();
    }
}

fn printCounter(counter: *Counter) void {
    while (true) {
        time.sleep(250 * time.ns_per_ms);
        counter.print();
    }
}

pub fn main() !void {
    var counter = Counter{};

    for (0..5) |_| {
        var thread = try std.Thread.spawn(.{}, incrementCounter, .{&counter});
        thread.detach();
    }

    for (0..100) |_| {
        var thread = try std.Thread.spawn(.{}, printCounter, .{&counter});
        thread.detach();
    }

    time.sleep(3 * time.ns_per_s);
    debug.print("\n", .{});
}
