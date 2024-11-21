# Multiplication
***

After some experimenting, I found the fastest way to calculate multiplication was to use a combination of rolling and bitsetting in an O(n) procedure. In which the multiplier is split per binary digit by rolling right, modifying carry to flag the need to bitset. When I first wrote this for `8 bit` multiplication there was little complexity, but scaling into being vWidth incurred some complexited without unrolling.

> In theory by swapping `ioptr` `out` and `mod` per calculation you will on average experience a reduction on iterations. This is merely due to a light association between size and bit complexity scaling with growing values. However, performing checks would incur it's own slowdown, assuming the widths of the parameters are inversible with their current values.