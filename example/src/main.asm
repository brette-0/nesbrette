.define libroot     "../../modules/"
.define templates   "../templates/"

.scope code

.define template .concat(templates, "global/")
.include .concat(templates, "global/includes.asm")

___libinclude___
.undefine template

.segment "HEADER"
insert_header

.segment "CODE"

Addr1 = $300
Addr2 = $308

typeas Addr1, bu32
typeas Addr2, bi8


TempArray:
    .byte $01, $23, $00, $00

reset:
    clc
    LSSByte u32: TempArray
    sta $310
    @hang:
        jmp @hang

.endscope

.segment "VECTORS"
    .addr $0000
    .addr code::reset
    .addr $0000