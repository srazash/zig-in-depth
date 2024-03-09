// looping fibonacci sequence
pub fn fib(n: usize) usize {
    if (n < 2) return n; // base case

    var a: usize = 0;
    var b: usize = 1;
    var i: usize = 0;

    while (i < n) : (i += 1) {
        var tmp = a;
        a = b;
        b = tmp + b;
    }

    return a;
}
