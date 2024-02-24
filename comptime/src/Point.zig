// Point becomes a function, take a parameter that is a type, and returns a type
// specifically we mark the parameter as `comptime` to ensure it is known at compile time
// because we return a type our function name starts with an uppercase letter
pub fn Point(comptime T: type) type {
    return struct {
        const Self = @This(); // const Point becomes const Self

        // our fields are now of type T
        x: T = 0,
        y: T = 0,

        // parameters are now of type T, and we return Self
        pub fn new(x: T, y: T) Self {
            return .{ .x = x, .y = y };
        }

        // parameters are now Self, and we return type T
        pub fn distance(self: Self, dst: Self) f64 { // change to f64 as `@sqrt` requires floats
            //const diffx = dst.x - self.x;
            //const diffy = dst.y - self.y;

            // we use a switch expression to check the type T and convert to a float
            // if T is an integer
            const diffx: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(dst.x - self.x),
                .Float => dst.x - self.x,
                else => @compileError("only floats or ints allowed"),
            };

            const diffy: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(dst.y - self.y),
                .Float => dst.y - self.y,
                else => @compileError("only floats or ints allowed"),
            };

            return @sqrt((diffx * diffx) + (diffy * diffy));
        }
    };
}
