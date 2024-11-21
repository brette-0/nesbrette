# Addition/Subtraction
***

The basis of much math, the `6502` affords the NES the `adc` instruction, useful for adding two values together with the ability to 'carry' a digit over for calculations that span multiple bytes. When developing the `add` macro for `nesbrette::math` I explored a multitude of configuration: big endian, unrolled, SMC and indirect indexed. From my findings I found that using fixed pointers is relatively *useless* considering the copy process to satisfy the procedure arguements would *consistently* introduce `~30%` slowdown over simply recalling a prepared Addition process.

Use of `vptr` yielded similar slowdown with copy-out process arguement retargeting, not to mention RAM consumption generally is worse than ROM consumption. `ioptr` seemed to be the final way this could be useful - but I felt dissatisfied. The iterated counter, check and branch was a crucial slowdown amongst calling/returning and therefore `add_ioptr` was removed.

Consequentially of the above, `add` is purely a macro now that cannot be rolled. Due to it being rolled there is no speed disadvantage by choice of endian. Raw addresses are the first two arguements needed to be passed in, there are no more 'Vwidth' operations here.

Usage:
```
add output modifier [size] [endian]
```

Speed : `10s cycles`
Size : `6s bytes`