// recursive fibonacci sequence
pub fn fib(n: usize) usize {
    if (n < 2) return n; // base case
    return fib(n - 1) + fib(n - 2); // recurse case
}
