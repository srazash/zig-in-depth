const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // POINTERS
    // single item pointer to a constant
    const a: u8 = 100;
    const a_ptr = &a; // `&` is the 'address of' operator which returns a pointer
    // we dereference a pointer (access the value it points to) with `.*`
    //a_ptr.* += 1; <- this causes an error, we cannot assign new values to a constant
    print("a_ptr address -> {}\na_ptr value -> {}\ntype of a_ptr -> {}\n", .{ a_ptr, a_ptr.*, @TypeOf(a_ptr) });

    // single item pointer to a variable
    var b: u8 = 100;
    const b_ptr = &b;
    b_ptr.* += 100; // we can assign new values because the underlying value is a variable
    print("b_ptr address -> {}\nb_ptr value -> {}\ntype of b_ptr -> {}\n", .{ b_ptr, b_ptr.*, @TypeOf(b_ptr) });

    // both pointers are constants and cannot be changed
    //a_ptr = &b; <- error: cannot assign to constant
    //b_ptr = &a; <- error: cannot assign to constant

    // but we can declare a pointer as a variable and change the address of what it points to
    var c_ptr = a_ptr;
    c_ptr = b_ptr;
    // NOTE: if we point from a var to a const, this will cause an error
    // as the pointer type is inferred from it's initial assignment
    // NOTE: even if a pointer is var, if the value it points to is a const we cannot change that value
    print("c_ptr address -> {}\nc_ptr value -> {}\ntype of c_ptr -> {}\n", .{ c_ptr, c_ptr.*, @TypeOf(c_ptr) });

    // multi item pointers
    var array = [_]u8{ 1, 2, 3, 4, 5, 6 }; // a standard array of u8 values
    var d_ptr: [*]u8 = &array; // [*]u8 <- multi item pointer for u8 values
    print("d_ptr[0] -> {}\ntype of d_ptr -> {}\n", .{ d_ptr[0], @TypeOf(d_ptr) });

    d_ptr[1] += 1; // we can access the index of array the pointer points to

    // we can use pointer arithmetic to increment or decrement the value it points to
    // this operates as an offset of the array's index
    d_ptr += 1;
    print("d_ptr[0]+1 -> {}\n", .{d_ptr[0]}); // we still access index 0, but where index 0 points to has been incremented
    d_ptr -= 1;
    print("d_ptr[0]-1 -> {}\n", .{d_ptr[0]}); // and decremented

    // pointer to array
    // a pointer to an array differs from a multi item pointer and functions more in line with a single item pointer
    const e_ptr = &array;
    print("e_ptr[0] -> {}\ntype of e_ptr -> {}\n", .{ e_ptr[0], @TypeOf(e_ptr) });

    e_ptr[1] -= 1; // we can still access the the array values by the index
    print("e_ptr[1] -> {}\n", .{e_ptr[1]});
    print("array[1] -> {}\n", .{array[1]});
    print("e_ptr.len -> {}\n", .{e_ptr.len});

    // sentinel terminated pointer
    array[3] = 0; // set array[3] to 0 to function as a sentinel terminator
    const f_ptr: [*:0]const u8 = array[0..3 :0]; // we create a pointer to a slice of the array (0..3, sentinel terminalted)
    print("f_ptr[1] -> {}\ntype of f_ptr -> {}\n", .{ f_ptr[1], @TypeOf(f_ptr) });

    // address as an integer
    const address = @intFromPtr(f_ptr);
    print("address -> {}\ntype of address -> {}\n", .{ address, @TypeOf(address) });

    // we can also get an address from an integer
    const g_ptr: [*:0]const u8 = @ptrFromInt(address);
    print("g_ptr[1] -> {}\ntype of g_ptr -> {}\n", .{ g_ptr[1], @TypeOf(g_ptr) });

    // C-style null pointer - optional pointer
    var h_ptr: ?*const usize = null;
    print("h_ptr -> {?}\ntype of h_ptr -> {}\n", .{ h_ptr, @TypeOf(h_ptr) });

    h_ptr = &address;
    print("h_ptr -> {?}\ntype of h_ptr -> {}\n", .{ h_ptr, @TypeOf(h_ptr) });

    // the size of an optional pointer is the sanme as a normal pointer
    print("h_ptr size -> {}\n*usize size -> {}\n", .{ @sizeOf(@TypeOf(h_ptr)), @sizeOf(*usize) });
}
