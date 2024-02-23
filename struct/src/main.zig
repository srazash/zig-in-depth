const std = @import("std");
const print = @import("std").debug.print;

const Point2 = @import("Point.zig"); // import Point namespace from Point.zig as "Point2"

// STRUCTS

// define a simple struct
// struct name starts with a capital letter
const Point = struct {
    // we define fields, and we can set a default value
    x: f32,
    y: f32 = 0, // default value

    // namespaced functions
    // the first parameter is NOT of the struct type
    fn new(x: f32, y: f32) Point {
        // anonymous struct literal
        return .{ .x = x, .y = y };
    }

    // methods
    // the first parameter is of the struct type, and typically `self`, though this is merely
    // a good, idomatic naming convension and not a requirement of Zig
    fn distance(self: Point, dst: Point) f32 {
        const diffx = dst.x - self.x;
        const diffy = dst.y - self.y;
        return @sqrt(std.math.pow(f32, diffx, 2.0) + std.math.pow(f32, diffy, 2.0));
    }
};

// a struct can have declaration and no fields, in which case it functions as a namespace
// this is a good way of bundling related functions together
const Namespace = struct {
    const pi: f64 = 3.141592;
    var count: usize = 0;
};

pub fn main() !void {
    // anonymous struct literal, omitting `y` as it has a default value
    const a_point: Point2 = .{ .x = 0 }; // 0,0

    // we can also create a point using the namespaced function
    const b_point = Point2.new(1, 1); // 1,1

    // use method syntax
    print("distance from a_point to b_point -> {d:.1}\n", .{a_point.distance(b_point)}); // d:.1 <- decimal value, 1 decimal place

    // using namespaced function syntax
    print("distance from b_point to a_point -> {d:.1}\n", .{Point2.distance(b_point, a_point)});

    print("\n", .{});

    // a namespace strict with no fields has a size of 0
    print("size of Point -> {}\n", .{@sizeOf(Point2)}); // f32 = 4 bytes, Point (2 x f32 fields) = 8 bytes
    print("size of Namespace -> {}\n", .{@sizeOf(Namespace)}); // Namespace (0 x fields) = 0 bytes

    print("\n", .{});

    // @fieldParentPtr
    var c_point = Point2.new(0, 0);
    setYBasedOnX(&c_point.x, 42); // pass in the address of the x field
    print("c_point.y -> {d:.1}\n", .{c_point.y});

    print("\n", .{});

    // the `.` operator de-references a pointer to a struct automatically when accessing fields or methods
    const c_point_ptr = &c_point; // pointer to c_point
    print("c_point_ptr.y -> {d:.1}, c_point_ptr.*.y -> {d:.1}\n", .{ c_point_ptr.y, c_point_ptr.*.y });
}

// struct field order is determined by the compiler for optimal performance
// but we can still get a struct pointer from a given field pointer
fn setYBasedOnX(x: *f32, y: f32) void {
    // @fieldParentPtr returns a fields parent from a pointer to that field
    const point = @fieldParentPtr(Point2, "x", x);
    point.y = y;
}
