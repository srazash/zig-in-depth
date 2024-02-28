const std = @import("std");

// memory sections or where are the bytes?

// these are stored in the global constant section of memory
const pi: f64 = 3.141592;
const greeting = "Howdy";

// this is stored in the global data section of memory
var count: usize = 0;
