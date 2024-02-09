# Zig in Depth

Following Dude the Builder's excellent YouTube playlist: https://youtube.com/playlist?list=PLtB7CL7EG7pCw7Xy1SQC53Gl8pI7aDg9t&si=Yf_fIYX8HBskrC9Z

## Notes

- Targeting Zig's stable build, version 0.11
- Zig 0.11 and ZLS 0.11 are available via homebrew (Mac/Linux) and scoop (Windows)

```sh
brew install zig zls
scoop install zig zls
```

## Project Setup

1. create a new directory
2. run `zig init-exe` or `zig init-lib` in that directory to create an executable or library project
3. run `zig build` to build to the default `zig-out/bin` directory
4. run `zig build run` to build and run executable projects
5. run `zig build test` to run any tests
6. run `zig build` and various subcommands with the `--summary all` option to view the steps involved, this is useful for tests as a successful test generates no output by default

Unlike with an executable project, we're unable to run `zig build run` in a library project, but we can run `zig build` and `zig build test`, which perform the same functions as in an executable project
