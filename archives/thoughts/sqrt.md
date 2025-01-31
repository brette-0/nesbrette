# Detailed Square Root Approximate
***

There is no way to calculate a square root, however, within our limited scope there may be a way to calculate the detail after taking the integer root as a response. As it stands, the fastest way to calculate this information on a weak CPU system is with precomputed (precalculated) data in a table known as a 'Look-Up Table' (LUT). A basic approach might look something like:

```c

const unsigned char Squares[] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225};

unsigned char sqrt(unsigned char square){
    unsigned char sqrt = 0;
    for (; sqrt < 16 && Squares[sqrt] <= square; sqrt++){ }
    return sqrt;
}
```

This soltion only fits an application in which a truncated response is of passable quality in all circumstances.