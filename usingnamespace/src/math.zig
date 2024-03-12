const std = @import("std");

pub fn add(a: u8, b: u8) u8 {
    return a +% b;
}

pub fn sub(a: u8, b: u8) u8 {
    return a -% b;
}

pub fn mult(a: u8, b: u8) u8 {
    return a *% b;
}

pub fn div(a: u8, b: u8) u8 {
    std.debug.assert(b != 0);
    return a / b;
}
