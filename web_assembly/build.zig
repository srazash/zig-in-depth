const std = @import("std");

pub fn build(b: *std.Build) void {
    // here we define our shared library
    // setting it's target to freestanding wasm32
    // and setting it to optimise to ReleaseSmall
    const lib = b.addSharedLibrary(.{
        .name = "wasmstr",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = .{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        },
        .optimize = .ReleaseSmall,
    });

    // export our function names so they are available to JS
    lib.export_symbol_names = &.{ "alloc", "free", "add", "sub", "zlog" };

    // generate our lib file
    b.installArtifact(lib);
}
