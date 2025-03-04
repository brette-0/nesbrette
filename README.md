# `nesbrette`
---

`nesbrette` is a highly engineered `ca65` library intended to give the 'standard library' content, quality and comprehensiveness as modern languages. Using `ca65hl`, `nesbrette` adds to the syntax of Assembly on the NES with instruction overloads, automatic ram allocation, dependancy layers, call handlers, rich synthetics and many macros that have been carefully designed to produce minimal output with minimal time.

## Type system

```
Score = $300
typeas Score, u32
typeas Bonus, u16


.proc giveBonus
    clc
    add Bonus, Score

    bcc NoOverflow
    flush Score, $ff

    NoOverFlow:
    rts
.endproc
```

Here you can see *Type Deduction* at play, this sytem allows users to type features out without needing to specify the conditions of the code. The code is optimised to handle differences in array length.

```
Score = $300
typeas Health, u32
typeas Modifier, i16


.proc DamagePlayer
    clc
    add Health, Modifier
    rts
.endproc
```

In this situation we arrive at *Signed Types* which are more important with `nesbrette` as without treating an array as a signed integer of a higher bitwidth signature has little meaning on the NES with just a byte register width.

Regading the type system, the user may also prefix their instructions to create a re-interpret cast like so:
```
Score = $300
typeas Health, u32
typeas Modifier, i16


.proc DamagePlayer
    clc
    add u24: Health, Modifier
    rts
.endproc
```

## Memory Safety

Immitating C, we have a few functions all regarding the handling of memory:
```
malloc Health, 4, slow      ; fetch 4 bytes of slow ram (pseudo-stack)
memcpy Source, Target       ; copy memory from one location to another
rshift Source, 14           ; Array Shift
dealloc foo, 1, fast        ; dellocate temp ram
```
`nesbrette` uses an 'allocation' system that modfiies assembler variables to immitate Stack RAM in preprocessor as a means to safely, efficiently and tidily manage RAM without intense persistent user interaction. This layer of automation is what enables `nesbrette` to have such a clean syntax with minimal fuss and really is quite clever. Should the user wish to change the amount of RAM they have they may do something like:
```
FAST_RAM_BEGIN = 0
FAST_RAM_END   = 0  ; disable fast ram (all fast requests will point to zero)

ZP_START       = $10
ZP_END         = $20
                    ; give minimal ZP to nesbrette, forcing efficient library use
SLOW_RAM_START = $600
SLOW_RAM_END   = $800
                    ; give more slow ram memory and move it further into system RAM.
```

But that's not all in the name of safety, `nesbrette` overloads all instructions that have an operand to ensure that all erroneous writes are prevented by either a shadow register or an error. Since these rules may not always be accurate depending on niche of hardware, user modifications to the library or the developer simply wishes to follow through with questionable practice they may override said instruction. 

```
lda PPUCTRL     ; invalid will fail
lda !PPUTRL     ; overruled, will be allowed

sta PPUSTATUS   ; strictly forbidden
sta PPUOPENBUS  ; allowed

sta $100        ; forbidden
sta $8000       ; depends on hardware
```

## Synth Heavy

Synthetic Instructions are always slow compared to real instructions, *however*, they make the tedious simple and bring the user one step closer to higher level language experience.

### `idtable`
```
adc x       ; index register as parameter
tyx         ; new instructions
bit #imm    ; new memory address modes
```

### `stack`
```
callback    ; push an (address-1) onto stack
lds 2       ; load stack at SP + 2 into A
sts         ; store A to stack at SP 
```

### `generic`
```
jeq         ; jump on equal to
sex         ; sign extend
ccf         ; complement carry
```

## Table Generation

With any solution you store all that which should not be calculated and could not be calculated within a reasonable timeframe parallel to its context at the desired frequency. Because of this, we store pre-computed information into tables for our code to access. The NES is no different, *however*, how tables were generated used to be either by hand or by a script and manually included where needed. `nesbrette` goes further:

```
poly i              ; create page long table for y = x
poly i * i, 0, 16   ; create 16 byte long table for y = square(x)

poly i | expo 2, i, 0, 8
                    ; y = x | (x ** i)

poly (i | a) * 2, i, 0, 4, expo 2, i
                    ; a = 2 ** x
                    ; y = (i | a) * 2 ==> (i | 2 ** x) * 2

table id            ; idtable
table sin           ; sine table
```