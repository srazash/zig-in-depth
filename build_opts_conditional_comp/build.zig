const std = @import("std");

// BUILD OPTIONS AND CONDITIONAL COMPILATION

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{}); // the `target` option allows us to setup automatic cross compilation (default is the host platform)
    const optimize = b.standardOptimizeOption(.{}); // the `optimize` option lets us set the compiliation mode Safe/Fast/Small (default is debug)

    // we can add a command line option to `zig build` via the `-D` flag. here `-Dloop`
    const use_loop = b.option(bool, "loop", "use non-recursive fibonacci") orelse false;
    // type (bool), flag name (invokend on the command line), description
    // and we add `orelse false` so it defaults to false if the flag is not set, otherwise it would return null - `.option()` returns an optional

    // using `use_loop` above we can configure the build to use `fib_loop.zig` or `fib_recurse.zig`
    const fib_file: []const u8 = if (use_loop) "src/fib_loop.zig" else "src/fib_recurse.zig";
    const fibonacci = b.addModule("fibonacci", .{ .source_file = .{ .path = fib_file } }); // add the module using `fib_file`

    // now we pass this as an option into the build using `addOption()`
    const options = b.addOptions();
    options.addOption(bool, "use_loop", use_loop);

    // defaulr executable config
    const exe = b.addExecutable(.{
        .name = "build_opts_conditional_comp",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // add the options to our exe build, here we cann it "config"
    exe.addOptions("config", options);
    // add the fibonacci module to our exe build
    exe.addModule("fibonacci", fibonacci);

    b.installArtifact(exe); // generate or "install" the exe

    const run_cmd = b.addRunArtifact(exe); // add a run step (`zig build run`)

    run_cmd.step.dependOn(b.getInstallStep()); // ensure the run step "installs" the exe so it cna run

    // check for, and pass any arguments (passed in with `--`) to the exe
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // execute the run
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // default test config
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
