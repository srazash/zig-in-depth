const std = @import("std");

// memory sections or where are the bytes?

// these are stored in the global constant section of memory
// these ar comptime know values
const pi: f64 = 3.141592653589793;
const greeting = "Howdy";

// this is stored in the global data section of memory
// the size of this variable is known at comptime, so even though it is a
// variable the required amount of memory can be set aside
var count: usize = 0;

fn locals() u8 {
    // all of these local variable are gone once the nfunction returns or
    // exits, they are on the STACK FRAME
    var a: u8 = 1;
    var b: u8 = 2;
    var result: u8 = a + b;

    // since it is a primitive type, result is returned as a copy
    return result;
}

fn invalidPtr() *u8 {
    // `x` is on the stack
    var x: u8 = 100;
    // we return a pointer but because x` is gone once the function returns
    // we are returning an invalid pointer
    return &x;
}

fn anotherInvalidPtr() []u8 {
    var array: [5]u8 = .{ 'H', 'e', 'l', 'l', 'o' };

    // NOTE: a slice is a pointer!
    var s = array[1..];

    // returning `s` will cause an error as we are rturning a DANGLING POINTER
    // after we return s, `array` will be gone and our slice will be pointing
    // at nothing
    return s;
}

// the way we solve the problem of data being removed when it leaves the stack
// is to place what we need on the HEAP

fn validPtr(allocator: std.mem.Allocator) allocator.Error![]u8 {
    // we pass in an allocator as a parameter, and we return either an
    // allocator error or a u8 slice (which is a pointer)

    var array: [5]u8 = .{ 'H', 'e', 'l', 'l', 'o' }; // sam array as above

    const s = try allocator.alloc(u8, 5); // allocate memory on the heap

    //std.mem.copy(u8, s, array); // std.mem.copy deprecated!
    @memcpy(s, &array); // copy the array to the heap

    // return a pointer to our copy of the array in the heap, the copy on the
    // heap will outlive anything in the stackframe and will persist until we
    // specifically free that memory, the caller is responsible for freeing it
    return s;
}

const Foo = struct {
    s: []u8,

    // when a type needs to initialise resources such as allocating memory
    // it is typically done using an `init()` function

    // return error union with pointer to a Foo
    fn init(allocator: std.mem.Allocator, s: []const u8) !*Foo {
        // we use `create()` ro allocate a single item on the heap
        // which returns a pointer
        const foo_ptr = try allocator.create(Foo);

        // errdefer a `destroy()` to free the memory in the event of an error
        errdefer allocator.destroy(foo_ptr);

        // `alloc()` allocates memory on the heap and return a slice
        foo_ptr.s = try allocator.alloc(u8, s.len);

        // copy s to foo_ptr.s
        @memcpy(foo_ptr.s, s);

        return foo_ptr;
    }

    // when a type needs to clean up created/allocated resources this is
    // done with a `deinit()` method
    fn deinit(self: *Foo, allocator: std.mem.Allocator) void {
        // `free()` the allocated memory
        allocator.free(self.s);

        // `destroy()` our pointer
        allocator.destroy(self);
    }
};

test "Foo" {
    const allocator = std.testing.allocator;
    var foo = try Foo.init(allocator, greeting);
    defer foo.deinit(allocator);

    try std.testing.expectEqualStrings(greeting, foo.s);
}
