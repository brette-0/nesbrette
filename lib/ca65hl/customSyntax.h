; --------------------------------------------------------------------------------------------
; https://mit-license.org/
; Copyright © 2022 Julian Terrell big.JT@protonmail.com
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
; documentation files (the “Software”), to deal in the Software without restriction, including without limitation 
; the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
; and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above 
; copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
; TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
; THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
; CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
; DEALINGS IN THE SOFTWARE.

; --------------------------------------------------------------------------------------------
; File: customSyntax.h
;
; --------------------------------------------------------------------------------------------
; Allow custom control over instructions, but still use ca65 built in functions to evaluate
; the instructions. This was a part of ca65hl, and the custom syntax only worked with ca65hl macros, but
; it has been separated into this file and will work everywhere by using the ca65 feature:
;
; .feature ubiquitous_idents
;
; This feature allows instructions to be used as macro names. The macros will toggle .feature ubiquitous_idents
; to allow ca65 to process the instruction normally. Be careful to not declare your own macros with instruction
; names accidentally. ( This shouldn't be possible unless these macros are inadvertently undefined. )
;
; --------------------------------------------------------------------------------------------
; Two features offered with these macros:
;
; 1) More than one instruction or macro per line separated by ':'
;
;   In this case, commas cannot be used with instructions or macros. If a comma is desired, use a single 
;   instruction. Macros cannot start a multi-instruction line.
;
; 2) The instruction macros will process their operands through the ___arraySyntax macro that allows
; an alternative syntax with array like indexing with constant expressions and the x or y registers.
;
;   Example:
; > lda foo[ 4 ] ; becomes: lda foo + 4
;
;   As well, the index can contain 'x' or 'y', to indicate to use the 6502's
;   indexed addressing modes.
;
;   Example:
; > lda foo[ 4 + x ] ; becomes: lda foo + 4, x
;
;   The index can be anywhere in the expression:
;
;   Example:
; > lda [ y - 4 ]foo
;
; The macro will allow any combination of constant values with either a Y or X included, but the index register
; must be first in the square brackets, or the index register must be preceded by a plus (+). The macro then converts 
; it to standard syntax and passes it to ca65 to assemble the instruction as normal.

.ifndef ::_CUSTOM_SYNTAX_H
::_CUSTOM_SYNTAX_H = 1

.feature ubiquitous_idents +    ; allow overloading mnemonics

.scope CUSTOM_SYNTAX
    JMP_INSTRUCTION_COUNTER     .set 0  ; count
    OUTPUT_CUSTOM_SYNTAX        .set 0
    RTS_FOUND                   .set 0
.endscope

; RTS tracking is for future use
.macro customSyntaxCountRTS
    CUSTOM_SYNTAX::RTS_FOUND .set 0
.endmacro

.define customSyntaxFoundRTS () (CUSTOM_SYNTAX::RTS_FOUND)

.macro customSyntax_Output opt1
    .if .xmatch( opt1, on )
        CUSTOM_SYNTAX::OUTPUT_CUSTOM_SYNTAX .set 1
    .elseif .xmatch( opt1, off )
        CUSTOM_SYNTAX::OUTPUT_CUSTOM_SYNTAX .set 0
    .else
        .error "Invalid option. Should be: 'on' or 'off'."
    .endif
.endmacro
; --------------------------------------------------------------------------------------------
; Function: ___findToken param, tok, position
;
; Parameters:
;
;   param - Token list to search through.
;   tok - Token to find.
;   position - Passed identifier to store found position in.
;              Should be initialized to zero to search the entire token list.
;
; Note:
; It won't find the token in the very first (0) position!
; This macro is defined elsewhere, so check if defined first.

.if !.definedmacro( ___findToken )
.macro ___findToken param, tok, position
    .repeat .tcount( {param} ), c
        .if .xmatch( {.mid(c, 1, {param}) }, {tok})
            .if !position ; do not remove this check
                position .set c
                .exitmacro
            .endif
        .endif
    .endrepeat
.endmacro
.endif

; --------------------------------------------------------------------------------------------
; Function: ___arraySyntax instr, op, index
;
; Parameters:
;
;   instr - CPU instruction to output.
;   op - Operand for instruction.
;
;   Look for '[]' set and allow as an array, possibly with x or y indexed:
;
;   This macro will output the instruction in passed in instr but it will 
;   process the operand, allowing an index defined by square braces: '[]'.
;   In the square braces can be any constant expression, which will be 
;   extracted and added onto the end of the operand as in normal assembly.
;
;   Example:
; > lda foo[ 4 ] ; becomes: lda foo+4
;
;   As well, the index can contain 'x' or 'y', to indicate to use the 6502's
;   indexed addressing modes.
;
;   Example:
; > lda foo[ 4 + x ] ; becomes: lda foo+4, x

.macro ___arraySyntax instr, op, index

    ; nesbrette

    .local ptr

    ; ca65hl

    .local open
    .local close
    .local reg
    .local regPos
    .local REGX, REGY
    REGX = 1
    REGY = 2
    open    .set 0
    close   .set 0
    reg     .set 0
    regPos  .set 0
    
    ; Only use custom syntax if there was no comma
    ; if index was passed, treat as normal 6502 syntax and quit, since this syntax does not use commas
    .ifblank index
        ___findToken {op}, [, open
        ; also check if position 0 is valid for open, since ___findToken won't find the first position
        .if open || .xmatch ( .left(1, {op}), [ )
            ___findToken {op}, ], close
            .if close
                ; look for '[ x +' type pattern
                .if .xmatch( {.mid(open + 1, 1 ,{op})}, x)
                    reg .set REGX
                .elseif .xmatch( {.mid(open + 1, 1 ,{op})}, y)
                    reg .set REGY
                .endif
                .if reg
                    ; require a +/-, but allow '[y]' or '[x]' if nothing else: 
                    ; if only a 'y' or 'x', define the constant as nothing
                    .if open + 2 = close
                        .define _CONST 
                        ; next has to be a + or -, or it is an error
                    .elseif .xmatch( {.mid(open + 2, 1 ,{op})}, +)
                        .define _CONST + (.mid(open + 3, close - open - 3 ,{op}))
                    .elseif .xmatch( {.mid(open + 2, 1 ,{op})}, -)
                        .define _CONST - (.mid(open + 3, close - open - 3 ,{op}))
                    .else
                        .error "Expected: '+' or '-'"
                    .endif
                .else
                    ; No reg found yet. Check for '+x' anywhere in the brackets
                    ___findToken {op}, x, regPos
                    .if regPos && regPos < close
                        reg .set REGX
                    .else
                        ___findToken {op}, y, regPos
                        .if regPos && regPos < close
                            reg .set REGY
                        .endif
                    .endif
                    ; found a valid register? to the left must be a +
                    .if reg
                        .if !.xmatch( {.mid(regPos - 1, 1 ,{op})}, +) 
                            .error "Expected: '+' before x or y."
                        .endif
                        ; lda foo[ 3 + x - 5 ]
                        ;      0 1 2 3 4 5 6 7
                        .define _CONST + (.mid(open + 1, regPos - open - 2, {op}) .mid(regPos + 1, close - regPos - 1, {op}))
                    .else
                        ; no registers, constant is whatever is in the '[]'
                        .define _CONST + (.mid(open + 1, close - open - 1 ,{op}))
                    .endif
                .endif
            .else
                .error "Expected: ']'"
            .endif
        .else
            ; no '[]'
            ; set value to make the expression below for .mid() become .tcount() only
            open .set .tcount({op})
            .define _CONST
        .endif
    
        ; anything after the '[]' pair? this allows index to be anywhere in the expression, rather than only at the end
        .if close && .tcount({op}) > close + 1
            .define _AFTER () .mid(close + 1, .tcount({op}) - close - 1 , {op})
        .else
            .define _AFTER
        .endif
        .if reg = REGX
            .define _OUT .left(1,instr) .mid(0, open, {op}) _AFTER _CONST, x
        .elseif reg = REGY
            .define _OUT .left(1,instr) .mid(0, open, {op}) _AFTER _CONST, y
        .else                                                                 
            .define _OUT .left(1,instr) .mid(0, open, {op}) _AFTER _CONST
        .endif
        .undefine _CONST
        .undefine _AFTER
    .else
        ; normal instruction syntax
        .define _OUT instr op, index
    .endif
    ; --------------------------------------------------------------------------------------------
    ; Output instruction:
    .feature ubiquitous_idents -    ; allow normal instruction table look ups
    .if .xmatch(instr, lax)
        .ifdef INCLUDES_SYNTH_OVERLOAD
            __lax op, index
        .else
            _OUT
        .endif
    .elseif .xmatch(instr, jmp)
        .ifnblank index
            .if .xmatch(index, x)
                ; jmp abs, x
                
                malloc ptr, 2
                
                pha
                clc
                txa
                adc #.lobyte(op)
                sta ptr
                and #$00
                rol
                adc #.hibyte(op)
                sta ptr + 1
                pla

                jmp [ptr]

                dealloc ptr, 2


            .elseif .xmatch(index, y)
                ; jmp abs, y

                malloc ptr, 2
                
                pha
                clc
                tya
                adc #.lobyte(op)
                sta ptr
                and #$00
                rol
                adc #.hibyte(op)
                sta ptr + 1
                pla

                jmp [ptr]

                dealloc ptr, 2
            .else
                _OUT
            .endif
        .else   ; TODO: add jmp foo[y|x] support
            _OUT
        .endif
    .elseif .xmatch(instr, jsr)
        .ifnblank index
            .if .xmatch(index, x)
                ; jsr abs, x
                
                malloc ptr, 2
                mallco temp, 1

                sta temp
                callback exit
                
                clc
                txa
                adc #.lobyte(op)
                sta ptr
                and #$00
                rol
                adc #.hibyte(op)
                sta ptr + 1

                jmp [ptr]
                exit:

                dealloc temp, 1
                dealloc ptr, 2


            .elseif .xmatch(index, y)
                ; jsr abs, y

                malloc ptr, 2
                
                clc
                tya
                adc #.lobyte(op)
                sta ptr
                and #$00
                rol
                adc #.hibyte(op)
                sta ptr + 1

                jmp [ptr]

                dealloc ptr, 2
            .else
                _OUT
            .endif
        .else   ; TODO: add jmp foo[y|x] support
            _OUT
        .endif
    .else
        _OUT
    .endif                          ; output instruction as standard ca65 6502 syntax
    .feature ubiquitous_idents +    ; allow overloading mnemonics again
    ; --------------------------------------------------------------------------------------------
    .if CUSTOM_SYNTAX::OUTPUT_CUSTOM_SYNTAX 
        printTokenList {_OUT}
    .endif
    .undefine _OUT
.endmacro

; --------------------------------------------------------------------------------------------
; Function: ___EvalInstrList statement, index
;
; Parameters:
;
;   statement - on first call, will be a CPU mnemonic and operand. After could also be a macro name
;   index - indexed mode for the instruction - x or y
;
; This macro is called by the overloaded instruction macros and allows for one or more instructions
; per line, separated by a colon ':'. A macro cannot be first on the line when using a multiple instructions.
; It will send instructions to ___arraySyntax to support extended syntax as described in this file.

.macro ___EvalInstrList statement, index

    ; split macro calls at colons:
    .local colonPos
    colonPos .set 0
    ___findToken {statement}, :, colonPos
    .if colonPos
        .ifnblank index
            .error "Commas not supported for multiple instructions on one line."
            .fatal ""
        .endif
        ; split at colon, and exit:
        ___EvalInstrList .mid(0, colonPos, {statement})
        ___EvalInstrList .mid( colonPos + 1 , .tcount({statement}) - colonPos - 1, {statement} )
    .else
        ; no colon, output macros or instructions:

        ; turn of instructions as macros temporarily to allow .ismnemonic to match instructions:
        .local isInstruction
        .feature ubiquitous_idents -
        isInstruction = .ismnemonic(.left (1,{statement})) || .xmatch( .left (1,{statement}), adc) ; ca65 bug? .ismnemonic doesn't match 'adc'
        .feature ubiquitous_idents +

        ; if found an instruction, send it to ___arraySyntax to process any extended syntax, otherwise, let ca65 deal with it
        .if isInstruction
            
            ; For instruction jmp: Save addresses of jmp instructions. This is to allow an .assert that checks ELSE or ELSEIF 
            ; was not proceeded by a jmp instruction. If it was, ca65hl will suggest to use 'jmp' option with the ELSE/ELSEIF 
            ; macro that will suppress the macro's normal generation of a jmp instruction to skip to the ENDIF. If 'jmp' 
            ; option was used, it will verify that the usage is correct.
            .if .xmatch(.left (1,{statement}), jmp )
                .ifdef ::CA65HL_H
                    ::.ident( .sprintf( "LAST_JMP_INSTRUCTION_END_ADDRESS_%04X", CUSTOM_SYNTAX::JMP_INSTRUCTION_COUNTER)) = * + 3
                    CUSTOM_SYNTAX::JMP_INSTRUCTION_COUNTER .set CUSTOM_SYNTAX::JMP_INSTRUCTION_COUNTER + 1
                .endif
            .endif

            ; tracking rts for future use
            .if .xmatch(.left (1,{statement}), rts )
                CUSTOM_SYNTAX::RTS_FOUND .set 1
            .endif
            ___arraySyntax .left (1,{statement}), { .mid (1, .tcount({statement}) - 1, {statement} ) }, index
        .else
            statement
        .endif
    .endif
.endmacro

; --------------------------------------------------------------------------------------------
; Overload mnemonics to allow custom syntax for all instructions

.macro lda operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            lda [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList lda operand, index
.endmacro
.macro sta operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            sta [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList sta operand, index
.endmacro
.macro ldx operand, index
    ___EvalInstrList ldx operand, index
.endmacro
.macro stx operand, index
    ___EvalInstrList stx operand, index
.endmacro
.macro ldy operand, index
    ___EvalInstrList ldy operand, index
.endmacro
.macro sty operand, index
    ___EvalInstrList sty operand, index
.endmacro
.macro adc operand, index
    .local ptr

    .feature ubiquitous_idents -
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        adc TABLE_ID, x
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        adc TABLE_ID, y
    .endif
    .feature ubiquitous_idents +

    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            adc [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList adc operand, index
.endmacro
.macro and operand, index
    .local ptr

    .feature ubiquitous_idents -
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        and TABLE_ID, x
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        and TABLE_ID, y
    .endif
    .feature ubiquitous_idents +

    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            and [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList and operand, index
.endmacro
.macro asl operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            asl [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList asl operand, index
.endmacro
.macro cmp operand, index
    .feature ubiquitous_idents -
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        cmp TABLE_ID, x
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        cmp TABLE_ID, y
    .else
        ___EvalInstrList cmp operand, index
    .endif
    .feature ubiquitous_idents +
.endmacro
.macro dec operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            dec [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList dec operand, index
.endmacro
.macro eor operand, index
    .local ptr

    .feature ubiquitous_idents -
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        eor TABLE_ID, x
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        eor TABLE_ID, y
    .endif
    .feature ubiquitous_idents +

    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            eor [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList eor operand, index
.endmacro
.macro inc operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            inc [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList inc operand, index
.endmacro
.macro lsr operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            lsr [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList lsr operand, index
.endmacro
.macro ora operand, index
    .local ptr

    .feature ubiquitous_idents -
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        ora TABLE_ID, x
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        ora TABLE_ID, y
    .endif
    .feature ubiquitous_idents +

    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            ora [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList ora operand, index
.endmacro
.macro rol operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            rol [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList rol operand, index
.endmacro
.macro ror operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            ror [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList ror operand, index
.endmacro
.macro sbc operand, index
    .local ptr

    .feature ubiquitous_idents -
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        sbc TABLE_ID, x
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        sbc TABLE_ID, y
    .endif
    .feature ubiquitous_idents +

    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            sbc [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList sbc operand, index
.endmacro
.macro bit operand, index
    .feature ubiquitous_idents -
    .if     .xmatch(.left(1, operand), #)
        bit TABLE_ID + .right(.tcount(operand) - 1, operand)
    .else
        ___EvalInstrList and operand, index
    .endif
    .feature ubiquitous_idents +
.endmacro
.macro cpx operand, index
    ___EvalInstrList and operand, index
.endmacro
.macro cpy operand, index
    ___EvalInstrList and operand, index
.endmacro

; TODO: Make jmp foo[y|x] work
.macro jmp operand, index
    .local ptr

    .if .xmatch(.left(1, operand), [)
        .ifnblank index
            .if .xmatch(.right(1, index), ])
                ; jmp [zp, x]
                malloc ptr, 2

                pha
                lda .right(.tcount(operand)-1, operand), x
                sta ptr
                lda .right(.tcount(operand)-1, operand) + 1, x
                sta ptr
                pla

                jmp [ptr]
                
                dealloc ptr, 2
            .elseif .xmatch(index, y)
                ; jmp [zp], y
                malloc ptr, 2
                
                pha
                clc
                tya
                adc operand
                sta ptr
                and #$00
                rol
                adc operand + 1
                sta ptr + 1              
                pla
                jmp [ptr]

                dealloc ptr, 2
            .endif
        .else
            ; jmp [inabs]
            .feature ubiquitous_idents -
            
            jmp operand

            .feature ubiquitous_idents +
        .endif
    .else
        ; jmp foo[bar]
        ___EvalInstrList jmp operand, index
    .endif
.endmacro
.macro jsr operand, index
    .local ptr, temp

    .if .xmatch(.left(1, operand), [)
        .ifnblank index
            .if .xmatch(.right(1, index), ])
                ; jmp [zp, x]
                .feature ubiquitous_idents -
                malloc ptr, 2
                malloc temp, 1

                sta temp
                callback exit

                lda .right(.tcount(operand)-1, operand), x
                sta ptr
                lda .right(.tcount(operand)-1, operand) + 1, x
                sta ptr
            
                lda temp
                jmp [ptr]
                exit:
                
                dealloc temp, 1
                dealloc ptr, 2
                .feature ubiquitous_idents +
            .elseif .xmatch(index, y)
                ; jmp [zp], y
                .feature ubiquitous_idents -
                
                malloc ptr, 2
                malloc temp, 1

                sta temp

                callback exit
                
                clc
                tya
                adc .left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
                sta ptr
                and #$00
                rol
                adc .left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand)) + 1
                sta ptr + 1              
                lda temp

                jmp [ptr]
                exit:

                dealloc temp, 1
                dealloc ptr, 2

                .feature ubiquitous_idents +
            .endif
        .else
            ; jsr [inabs]
            .feature ubiquitous_idents -
            
            malloc temp, 1
            sta temp

            callback exit
            
            lda temp
            dealloc temp, 1
            jmp operand

            exit:
            .feature ubiquitous_idents +
        .endif
    .else
        ; jmp foo[bar]


        ___EvalInstrList jmp operand, index
    .endif
.endmacro
.macro nop operand, index
    ___EvalInstrList nop operand, index
.endmacro
.macro slo operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            slo [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList slo operand, index
.endmacro
.macro rla operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            rla [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList rla operand, index
.endmacro
.macro sre operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            sre [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList sre operand, index
.endmacro
.macro rra operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            rra [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList rra operand, index
.endmacro
.macro sax operand, index
    ___EvalInstrList sax operand, index
.endmacro
.macro lax operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            lax [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList lax operand, index
.endmacro
.macro dcp operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            dcp [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList dcp operand, index
.endmacro
.macro isc operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            isc [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList isc operand, index
.endmacro

.endif ; .ifndef ::_CUSTOM_SYNTAX_H
