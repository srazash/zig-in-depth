const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // STRINGS
    // string literals are const pointers to sentinel terminaled arrays
    // the sentinel is 0, this is known as the null character in C
    // the array's bytes are included as part of the generated binary
    const hello = "Hello";
    print("type of \"hello\" -> {}\n", .{@TypeOf(hello)}); // *const [5:0]u8

    print("\n", .{});

    // when we need a more general type for working with strings we can use
    // a slice of bytes, either const `[]const u8` or not `[]u8`
    printString("Hello Ryan!"); // <- this function coerces the argument into a `[]const u8`

    print("\n", .{});

    // Zig has a minimal set of escape sequences
    // tab, escaped double quote, escaped single quote, hexidecimal byte value (65 = 'A')
    // hexidecimal UTF-8 symbol (5a = 'Z'), backslash, new line, carriage return
    print("escapes -> \t \" \' \x41 \u{5a} \\ \n \r", .{});

    print("\n", .{});

    // we can access a string character by it's index, this returns a single byte
    // prints the numberic code (decimal), ASCII character, UTF-8 character
    print("hello[4] -> {0} {0c} {0u}\n", .{hello[4]}); // 111 o o

    print("\n", .{});

    // all Zig source code is UTF-8 encoded but strings can contain non-UTF-8 symbols
    // by using the \x escape sequence
    var hello_again: []const u8 = "H\xe9llo"; // \xe9 = 'é' as an ASCII character

    // NOTE: a non-UTF-8 character will likely not render correctly in a modern terminal!
    // some terminals offer the option to switch encoding, try switching betwen ASCII and Unicode/UTF-8 encoding

    print("hello_again -> {s}, len: {}\n", .{ hello_again, hello_again.len }); // hello_again -> H?llo, len: 5
    // the ASCII character uses 1 byte

    hello_again = "H\u{e9}llo"; // \u{e9} = 'é' as a UTF-8 character

    print("hello_again -> {s}, len: {}\n", .{ hello_again, hello_again.len }); // hello_again -> Héllo, len: 6
    // the UTF-8 character uses 2 bytes

    print("\n", .{});

    // multiline literals are defined by '\\' for each line, this diffrentiates it from comments
    // escape sequences are ignored when used in a multiline string
    const multiline =
        \\ ______      _     _    _
        \\ | ___ \    | |   | |  | |
        \\ | |_/ /__ _| |_  | |  | | __ _ _ __ ___
        \\ |    // _` | __| | |/\| |/ _` | '__/ __|
        \\ | |\ \ (_| | |_  \  /\  / (_| | |  \__ \
        \\ \_| \_\__,_|\__|  \/  \/ \__,_|_|  |___/
    ;

    print("{s}\n", .{multiline});

    print("\n", .{});

    // Zig has no `char` type, we define UTF-8 code point literals using `''` single quotes
    const ziguana = '🦎';
    // we can use u21 as the type for UTF-8 code points
    const bolt: u21 = '⚡';

    print("{u} ZIG! {u}\n", .{ ziguana, bolt });
    print("type of ziguana -> {}\n", .{@TypeOf(ziguana)});
    print("type of bolt -> {}\n", .{@TypeOf(bolt)});

    print("\n", .{});

    // std.unicode provides functions for handling unicode text
    print("Is \"H\xe8llo\" valid UTF-8? -> {}\n", .{std.unicode.utf8ValidateSlice("H\xe8llo")});

    // and likewise std.ascii provides functions for workin with ASCII text
    print("'A' is uppercase? -> {}\n", .{std.ascii.isUpper('A')});

    print("\n", .{});
}

fn printString(s: []const u8) void {
    print("{s}\n", .{s});
}
