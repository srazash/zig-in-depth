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
    print("c_ptr address -> {}\nc_ptr value -> {}\ntype of c_ptr -> {}\n", .{ c_ptr, c_ptr.*, @TypeOf(c_ptr) });
}
