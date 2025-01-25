***
###### Advanced Syntax | `6502` | Any Hardware

The 'synthetic instructions' below are for atypical but useful cases for some of the stack interacting instructions.

### `ldstat` - Load CPU Status
###### `7c 2b`
```
.macro ldstat
    php
    pla
.endmacro
```
Loads `STAT` (CPU Status Flags) into accumulator.

### `ststat` - Store CPU Status
###### `7c 2b`
```
.macro ldstat
    pha
    plp
.endmacro
```
Stores accumulator into `STAT` (CPU Status Flags).
### `callback` - Register Callback
###### `10c 6b`
```
.macro callback __addr__
    lda #<__addr__
    pha
    lda #>__addr__
    pha
.endmacro
```
Stores an address into stack for the next return.
### `lds` - Load Stack
###### `6c 3b`
```
.macro lds __reg__
    tsx
    .if .xmatch(__reg__, y)
        ldy $0100, x
    .else
        lda $0100, x
    .endif
.endmacro
```
Loads the current result of `pla` into either accumulator or the Y register.
### `sts` - Store Stack
###### `6c 3b`
```
.macro sts __reg__
    tsx
    .if .xmatch(__reg__, y)
        sty $0100, x
    .else
        sta $0100, x
    .endif
.endmacro
```
Stores either the  accumulator or the Y register into the stack at `SP` (Stack Pointer).


