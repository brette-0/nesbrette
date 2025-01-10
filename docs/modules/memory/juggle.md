# `juggle`
***

```
juggle array_collection
juggle array_collection, array_width_collection
```

`juggle` is called when you need to swap memory amount with pushing too much to stack. This process is the smallest form of the fastest way of performing this.


If all transfers are the same size, you only need to pass one value into the 'widths' collection.


#### Example Code:
```
MyRomArray1:  .byte "Array"
MyRomArray2:  .byte "Second"

MyRamArray1 = $300
MyRamArray2 = $308

SwapBuffer  = $0ff8

.repeat (MyRomArray2 - MyRomArray), iter


.proc swap_arrays
    juggle {MyRamArray1, MyRamArray2}, {\
        MyRamArray2   - MyRamArray1,    \
        MyRamArrayEnd - MyRamArray2,    \
    }
    rts
    .endproc
```