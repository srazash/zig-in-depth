# Working with C

We can build C programs using Zig's compiler:

```
zig cc math.c main.c -o math
```

We can also target specific platformarms using the `-target` argument:

```
zig cc math.c main.c -o math -target x86_64-linux-gnu
```

This will product a Linux binary, no matter what platform we are currently working on.

Further to simply invoking a C compiler from Zig, we can also use Zig's build system to work with C projects and build code.

The following changes were made to the `build.zig` file to enable us to build or run the C code using Zig's build system (`zig build` or `zig buld run`):

```
const exe = b.addExecutable(.{
    .name = "working_with_c",
    .root_source_file = .{ .path = "src/main.c" }, // POINTING TO MAIN.C!
    .target = target,
    .optimize = optimize,
});

exe.addCSourceFiles(&.{"src/math.c"}, &.{}); // POINTS TO ADDITIONAL C FILES NEEDED
exe.addIncludePath(.{ .path = "src" }); // POINTS TO C HEADER FILES
exe.linkLibC(); // REQUIRED FOR BUILDING C IF THE STANDARD C LIBRARY IS USED (STDIO.H)
```