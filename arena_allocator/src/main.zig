const std = @import("std");
const print = std.debug.print;

//const List = @import("list.zig").List;
const List = @import("list_arena.zig").List;

// ARENA ALLOCATOR
// most allocators allocate and then are deallocated as needed
// the arena allocator allocates when needed and only deallocates once
// this can be beneficial when a lot of cyclical allocations are occuring
// as we only allocate when needed and deallocate everything all at once

pub fn main() !void {
    // using the GeneralPurposeAllocator
    //var gpa = std.heap.GeneralPurposeAllocator(.{}){}; // pass in an empty tuple so we use the default config
    //defer _ = gpa.deinit(); // defer a deinit() of the gpa
    //const allocator = gpa.allocator(); // obtain the allocator

    // we use the page_allocator as the backend allocator for the arena allocator
    // page_allocator is *not* recommended for normal allocations since it allocates
    // a full page of memory per allocation!
    const allocator = std.heap.page_allocator;

    // NOTE: don't use the page_allocator as a normal allocator! everytime we allocated with the page_allocator
    // we allocate anything from 512b up to 4Kb which is extremely inefficient, especially for small allocations
    // but it is a good fit as the backing allocator when we use the ArenaAllocator

    const iterations: usize = 100;
    const item_count: usize = 1_000;

    // start a times
    var timer = try std.time.Timer.start();

    // loop
    for (0..iterations) |_| {
        // create list
        var list = try List(usize).init(allocator, 13);
        errdefer list.deinit();

        // add items, allocate each loop
        for (0..item_count) |i| try list.append(i);

        // free allocated memory, once per item for non-arena list and only once for the arena
        list.deinit();
    }

    // get elapsed time in ms
    var took: f64 = @floatFromInt(timer.read());
    took /= std.time.ns_per_ms;

    print("took: {d:.2}ms\n", .{took});
}
