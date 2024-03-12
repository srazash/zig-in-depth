pub fn Request(comptime timeout: usize) type {
    return struct {
        method: enum { get, post, put, delete },
        path: []const u8,
        body: ?[]const u8,
        timeout: usize = timeout,

        const Self = @This();

        // we can also use `usingnamespace` for conditional compilation
        // here we have a comptime evaluated if statement that checks if our
        // timeout is greater than 0 for any Request types we initialise
        // if it is then that instance of the Request type will have access
        // to the `getTimeout()` function, if not then it doesnt
        pub usingnamespace if (timeout > 0)
            struct {
                pub fn getTimeout(self: Self) usize {
                    return self.timeout;
                }
            }
        else
            struct {};
    };
}
