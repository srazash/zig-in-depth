const std = @import("std");

// HASHMAPS
// hashmaps are very efficient lookup tables which use hashing to map values
// to each other

// allocates memory for the email field
const User = struct {
    allocator: std.mem.Allocator,
    id: usize,
    email: []u8,

    fn init(allocator: std.mem.Allocator, id: usize, email: []const u8) !User {
        return .{
            .allocator = allocator,
            .id = id,
            .email = try allocator.dupe(u8, email),
        };
    }

    fn deinit(self: *User) void {
        self.allocator.free(self.email);
    }
};

// use a hashmap internally to store users mapped to their ID
const UserData = struct {
    map: std.AutoHashMap(usize, User), // standardhashmap in Zig

    fn init(allocator: std.mem.Allocator) UserData {
        return .{ .map = std.AutoHashMap(usize, User).init(allocator) };
    }

    fn deinit(self: *UserData) void {
        self.map.deinit();
    }

    // replaces existing entry
    fn put(self: *UserData, user: User) !void {
        try self.map.put(user.id, user);
    }

    fn get(self: *UserData, id: usize) ?User {
        return self.map.get(id);
    }

    // safe to call on non-existent keys
    fn del(self: *UserData, id: usize) ?User {
        return if (self.map.fetchRemove(id)) |kv| kv.value else null;
    }
};

pub fn main() !void {
    // setup GPA
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // create a UserData store
    var users = UserData.init(allocator);
    defer users.deinit();

    // add some users
    var ryan = try User.init(allocator, 1, "ryan@email.local");
    defer ryan.deinit();
    try users.put(ryan);

    var ben = try User.init(allocator, 2, "ben@email.local");
    defer ben.deinit();
    try users.put(ben);

    var will = try User.init(allocator, 3, "will@email.local");
    defer will.deinit();
    try users.put(will);

    // GET users
    if (users.get(ryan.id)) |user| std.debug.print("got: id -> {}, email -> {s}\n", .{ user.id, user.email });
    if (users.get(ben.id)) |user| std.debug.print("got: id -> {}, email -> {s}\n", .{ user.id, user.email });
    if (users.get(will.id)) |user| std.debug.print("got: id -> {}, email -> {s}\n", .{ user.id, user.email });

    // delete an entry
    _ = users.del(will.id); // o7
    if (users.get(will.id)) |user| {
        std.debug.print("got: id -> {}, email -> {s}\n", .{ user.id, user.email });
    } else {
        std.debug.print("user not found o7\n", .{});
    }

    // we can count entries in the map
    std.debug.print("count -> {}\n", .{users.map.count()});

    // we can check for a specific entry by key
    std.debug.print("ryan found? -> {}\n", .{users.map.contains(ryan.id)});

    // we can iterate over all the entries of a map and access their keys and values
    // we progress the iterator with `.next()`
    // NOTE: iterators are pointers, so we have to dereference the data it points to
    // for a hashmap this is `.key_ptr.*` and `.value_ptr.<name of value>`!
    var entry_iter = users.map.iterator();
    while (entry_iter.next()) |entry| std.debug.print("got: id -> {}, email -> {s}\n", .{ entry.key_ptr.*, entry.value_ptr.email });

    // we can get an existing entry or add it if it does not exist
    var gopr = try users.map.getOrPut(ben.id); // get or put result
    if (!gopr.found_existing) gopr.value_ptr.* = ben; // if gorp.found_existing is false, we set the value_ptr to our user

    // if we need a set of *unique* items we can create a hashmap with the void value type
    var primes = std.AutoHashMap(usize, void).init(allocator);
    defer primes.deinit();

    // add some values
    try primes.put(5, {});
    try primes.put(7, {});
    try primes.put(7, {});
    try primes.put(5, {});

    // because we cannot have duplicate keys...
    std.debug.print("primes -> {}\n", .{primes.count()}); // 2
    std.debug.print("contains 5? -> {}\n", .{primes.contains(5)});
    std.debug.print("contains 7? -> {}\n", .{primes.contains(7)});
}
