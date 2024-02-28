const std = @import("std");
const print = std.debug.print;

// MEMORY MANAGEMENT

// basics of memory
// memory is broken down into three areas: stack, heap and static (or global)
// static is where compiled items are stored - such as strings or constants
// the stack is where variables within functions are stored while executing
// each function creates a new stack frame which pops after it is returns
// the heap is an area of memory which we need to allocate and free, any
// heap memory we have allocated will be available until we free it and isn't
// tied to function lifetimes like the stack is

pub fn main() !void {}
