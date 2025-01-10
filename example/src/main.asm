.setcpu "6502x"

.define libroot     "../../modules/"
.define templates   "../templates/"

.define template .concat(templates, "global/")
.include .concat(templates, "global/includes.asm")

___libinclude___
.undefine template

.segment "HEADER"
insert_header

.segment "CODE"
.scope code
reset:
    @hang:
        jmp @hang

.endscope


.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000