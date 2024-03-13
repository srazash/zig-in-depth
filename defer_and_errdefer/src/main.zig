const std = @import("std");
const Allocator = std.mem.Allocator;

// DEFER AND ERRDEFER

// a linked list stored on the heap
const List = struct {
    const Node = struct {
        data: u8,
        next: ?*Node,

        fn create(allocator: Allocator, data: u8) !*Node {
            // here we don't use `defer`/`errdefer` as no errors can occur after allocation
            var self = try allocator.create(Node);
            self.data = data;
            self.next = null;
            return self;
        }

        fn deinit(self: *Node, allocator: Allocator) void {
            if (self.next) |node_ptr| {
                node_ptr.deinit(allocator);
                allocator.destroy(node_ptr);
            }
        }
    };

    allocator: Allocator,
    head: *Node,
    tail: *Node,

    fn init(allocator: Allocator, data: u8) !List {
        // again, we don't use `defer`/`errdefer` as no errors can occur after allocation
        var self = List{
            .allocator = allocator,
            .head = try Node.create(allocator, data),
            .tail = undefined,
        };
        self.tail = self.head;
        return self;
    }

    fn initListWithSlice(allocator: Allocator, slice: []const u8) !List {
        var self = try List.init(allocator, slice[0]);
        // here an error may occur when we try `append()` so we `errdefer` a `deinit()`
        errdefer self.deinit(); // this is only executed if we exit scope returning an error

        for (slice[1..]) |data| try self.append(data);
        return self;
    }

    fn deinit(self: *List) void {
        self.head.deinit(self.allocator);
        self.allocator.destroy(self.head);
    }

    fn append(self: *List, data: u8) !void {
        self.tail.next = try Node.create(self.allocator, data);
        self.tail = self.tail.next.?;
    }

    fn contains(self: List, data: u8) bool {
        var current: ?*Node = self.head;

        return while (current) |node_ptr| {
            if (node_ptr.data == data) break true;
            current = node_ptr.next;
        } else false;
    }

    fn print(self: List) void {
        var current: ?*Node = self.head;
        var i: usize = 0;

        while (current) |node_ptr| : (i += 1) {
            std.debug.print("[{}]: {} -> ", .{ i, node_ptr.data });
            current = node_ptr.next;
        }
        std.debug.print("END\n", .{});
    }
};

pub fn main() !void {
    // NOTE: end of scope here is when the main() function exits
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit(); // defer a deinit, which will occur when we reach the end of scope
    const allocator = gpa.allocator();

    var list = try List.initListWithSlice(allocator, &.{ 13, 42, 33 });
    defer list.deinit(); // defer a deinit, which will occur when we reach the end of scope

    try list.append(99);

    std.debug.print("found 42? -> {}\n", .{list.contains(42)});
    std.debug.print("found 99? -> {}\n", .{list.contains(99)});
    std.debug.print("found 100? -> {}\n", .{list.contains(100)});

    std.debug.print("\n", .{}); // new line

    list.print();

    std.debug.print("\n", .{}); // new line

    // NOTE: defers are called in reverse order, so the first defer listed executes last
    defer std.debug.print("defer 3rd\n", .{});
    if (true) {
        // this defer will execute when the if statement exists scope
        // NOTE: defers are scoped to the block `{...}` they are contained in, not the function!
        defer std.debug.print("defer 1st\n", .{});
    }
    defer std.debug.print("defer 2nd\n", .{});

    // here we use an `errdefer` which will only execute if an error is returned
    errdefer |err| std.debug.print("!!! errdefer: error {} !!!\n", .{err}); // here we capture the error and print it
    //return error.Bang; // <- artificially invoke the errdefer
}
