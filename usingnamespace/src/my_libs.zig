// this allows us to present our various libraries as a unified namespace
// here we present everthing included in `math.zig` and `person.zig`
// as though the are a parts of `my_libs.zig` which we can `@import()` as a
// single statement back in `main.zig`
pub usingnamespace @import("math.zig");
pub usingnamespace @import("http.zig");
pub usingnamespace @import("person.zig");

// NOTE: our these are marked as `pub` and are exported!
