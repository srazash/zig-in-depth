const std = @import("std");

// a basic linked list that uses the ArenaAllocator internally
pub fn List(comptime T: type) type {
    return struct {
        const Node = struct {
            // because we are using the ArenaAllocator we do not store the alocator in the Node struct
            data: T,
            next: ?*Node,

            fn init(allocator: std.mem.Allocator, data: T) !*Node {
                const ptr = try allocator.create(Node);
                ptr.data = data;
                ptr.next = null;

                return ptr;
            }

            // we have no deinit() method, again because we deinit the ArenaAllocator all at once
        };

        const Self = @This();

        arena: std.heap.ArenaAllocator, // ArenaAllocator instead of the standard allocator
        head: *Node,

        pub fn init(allocator: std.mem.Allocator, data: T) !Self {
            var list = Self{
                .arena = std.heap.ArenaAllocator.init(allocator),
                .head = undefined,
            };

            list.head = try Node.init(list.arena.allocator(), data);

            return list;
        }

        pub fn deinit(self: *Self) void {
            self.arena.deinit();
        }

        pub fn append(self: *Self, data: T) !void {
            var tail: *Node = self.head;
            while (tail.next) |ptr| tail = ptr;
            tail.next = try Node.init(self.arena.allocator(), data);
        }

        pub fn lookup(self: Self, data: T) bool {
            var current: ?*Node = self.head;

            return while (current) |node_ptr| {
                if (node_ptr.data == data) break true;
                current = node_ptr.next;
            } else false;
        }
    };
}
