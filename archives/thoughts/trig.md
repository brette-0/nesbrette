Trigonometry on the NES is not alien, not all games used it and not all games could. But it isn't alien and has been done before.

Sine and Cosine values lie between `-1` and `1`, since most values are impossible to represent as perfect fractions (let alone within low detail), approximate results will be used.

Implementing an approximate is fun in some regards, if you attempt `sin(theta)` and the result isn't `1`, you understand the approximate is innacurate and therefore you might add a conditional to specify constant `1` where necessary. Should we specify the signature, we then have 7 bits of detail to express the fractional result.

However, calculating whether or not it should be a fraction is easy. If `theta` is above `pi` radians, then whatever value you encounter should be made negative. By this logic, if we track the value of theta we can store 8 bits of detail which earns us twice as much accuracy. If Theta is above `pi/2` radians we can mirror the index from the point of `pi/2` to obtain the same value the unmodified index would.

Assuming we use an `8` bit degree system, we can offer sign values with `8` bits of detail in `64` bytes. But can we do better?

A lot of processes that use trig use both sine and cosine, sometimes even others.
The thing is, `cos(theta + (3 * pi) / 2)` is the same as `sin(theta)` and therefore a cosine table would inevitably store the same data as a sine table.

The issue is, that was 100% a lie - because you cannot represent `3 * pi / 2` with total accuracy, but the question is - can we create an approximate solution accurate enough for the NES within the confines of the hardware?

This is an `i6502x` tolerant solutions in which we only wish to reduce the amount of table information.
Ideally, somehow we merge sine and cosine into a 'wave' table that get methods coudl fetch the data from.

Per index (or theta), we only need `6` bits - leaving two for whatever as long as they don't index the table (considering that would make the table larger).

Decreasing the resolution of the table doesn't help much either, plus it infringes of the quality of the data making it an inappropriate solution.

