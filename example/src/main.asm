.setcpu "6502x"

.feature c_comments
.feature force_range
.feature line_continuations
.feature string_escapes
.feature underline_in_numbers
.feature bracket_as_indirect

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

Addr1 = $0300
Addr2 = $0303

w_Addr1 = $03
w_Addr2 = $02

reset:
    add w_Addr1: Addr1, Addr2
    @hang:
        jmp @hang

.endscope


.segment "VECTORS"
    .addr $0000
    .addr code::reset
    .addr $0000