const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // compile to native target as a debug release by default
    const exe = b.addExecutable(.{
        .name = "cross_comp",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    // handles `zig build run`
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // cross compile to Linux x86_64 musl abi
    // release safe optimisation
    const exe_linux_musl = b.addExecutable(.{
        .name = "main_linux_musl",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = .{
            .cpu_arch = .x86_64,
            .os_tag = .linux,
            .abi = .musl,
        },
        .optimize = .ReleaseSafe,
    });
    b.installArtifact(exe_linux_musl);

    // cross compile to Windows x86_64 gnu abi
    // release small optimisation
    const exe_windows_gnu = b.addExecutable(.{
        .name = "main_windows_gnu",
        .root_source_file = .{ .path = "src/main.c" }, // build a C file
        .target = .{
            .cpu_arch = .x86_64,
            .os_tag = .windows,
            .abi = .gnu,
        },
        .optimize = .ReleaseSmall,
    });
    exe_windows_gnu.linkLibC(); // link libc
    b.installArtifact(exe_windows_gnu);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
