const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // START OF CODE GEN!
    // define an option to specify the fibonacci sequence end
    // this is passed to zig using the -D flag
    const fib_end = b.option([]const u8, "fib-end", "End of the Fibonacci sequence.") orelse "7";

    // compile the executable that will generate the Zig code
    const gen_exe = b.addExecutable(.{
        .name = "gen_exe",
        .root_source_file = .{ .path = "src/gen.zig" },
        .target = target,
        .optimize = optimize,
    });

    // run the code gen executable after compiling it
    const run_gen_exe = b.addRunArtifact(gen_exe);
    run_gen_exe.step.dependOn(&gen_exe.step);

    // create an argument to be passed to the code gen executable defining the output file to place the generated code into
    const output_file = run_gen_exe.addOutputFileArg("fib.zig");

    // pass the `fib-end` build arg to the code gen executable
    run_gen_exe.addArg(fib_end);

    // write the generated code to a file in the src directory
    const gen_write_files = b.addWriteFiles();
    gen_write_files.addCopyFileToSource(output_file, "src/fib.zig"); // END OF CODE GEN!

    const main_exe = b.addExecutable(.{
        .name = "code_gen",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // we add this line to tell the build system that main_exe cannot run without performing the code gen first
    main_exe.step.dependOn(&gen_write_files.step);

    b.installArtifact(main_exe);

    const run_cmd = b.addRunArtifact(main_exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
