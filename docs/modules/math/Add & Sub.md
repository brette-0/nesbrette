***
###### Math | `6502` | Any Hardware
###### Type Deduced:
```
; type deduced
clc
adc Output, Modifier

sec
sbc Output, Modifier
```
###### Type Specified (simple)
```
; type specified (simple)
clc
adc bu32:Output, i16: Modifier

sec
sbc bu32:Output, i16: Modifier
```
###### Type Specified (dynamic)
```
; type specified (dynamic)
clc
adc (OutType):Output, (ModType):Modifier

sec
sbc (OutType):Output, (Modtype):Modifier
```

The `add` function simply performs iterated addition and *will not* modify carry on entry, this is to allow sequential `add` calling. The parameters may be differing in endianness and signature, the output is speed optimised (unrolled). When using a signed modifier, ensure that the difference in type sizes is less than two or you will incur a 'borrow logic' penalty. While a difference of one does incur a small penalty, it's negligible due to it's logic-less nature.

