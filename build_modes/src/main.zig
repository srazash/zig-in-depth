const std = @import("std");

const List = @import("list.zig").List;

pub fn main() !void {
    // BUILD MODES

    // default build mode is debug mode, it lacks any compilation optimisations
    // so it is quick, but will product larger, slower binaries containing all
    // debug info needed for debugging

    // `zig build` <- produces a debug build by default (1.2M)
    // `zig build -Doptimize=ReleaseSafe` <- produces a release build with safety checks enabled and optimisations (272K), faster and smaller but lacks debug info
    // `zig build -Doptimize=ReleaseFast` <- produces the most optimised binary possible, which is the fastest but compilation takes time (187K), safety checks are gone
    // `zig build -Doptimize=ReleaseSmall` <- produces the smallest binary possible, again takes time to compile (73K), all safety checks are gone

    // using the GPA
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.print("GPA result: {}\n", .{gpa.deinit()});
    var logging_alloc = std.heap.loggingAllocator(gpa.allocator());
    const allocator = logging_alloc.allocator();

    var list = try List(u8).init(allocator, 50);
    defer list.deinit();
    try list.append(100);
    try list.append(200);

    std.log.info("log.info {?}", .{list.lookup(100)});
    std.debug.print("debug.print {?}\n", .{list.lookup(101)});
}
