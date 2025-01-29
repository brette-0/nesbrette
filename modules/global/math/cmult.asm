/*

    Constant Multiply
        - Signature Inclusive
        - Endian Inclusive
        - acc/mem mode
        - possible optimisations (complexity table, dedicated heuristic table)

*/


.macro __cmult__mem__body __t_out__, __w_out__, __l_out__, __mult__

.endmacro

.macro __cmult__acc__body __mult__

.endmacro

.macro exclude_types __origin__, __array__, __msg__
    .repeat .tcount(__array__), iter
        .if __origin__ = (index __array__, iter)
            .fatal __msg__
        .endif
    .endrepeat
.endif

.macro passthrough_types __origin__, __array__, __msg__
    .local temp

    temp .set 0
    .repeat .tcount(__array__), iter
        .if __origin__ = (index __array__, iter)
            temp .set 1
        .endif
    .endrepeat

    .if !temp
        .fatal __msg__
    .endif 
.endif

.macro handlewarning __error__, __msg__
    .if isfatal(__error__)
        .fatal __msg__
    .elseif iserror(__error__)
        .error __msg__
    .elseif iswarning(__error__)
        .warning __msg__
    .elseif isout(__error__)
        .out __msg__
    .else
        .fatal .sprintf("Condition : %s - Has undefined report level, please adjust.", __error__)
    .endif
.endmacro

; cmult 2       ; implied syntax
; cmult imp: 2  ; specified implied mode
; cmult ar: 2   ; specifying use of a
.macro cmult __param0__, __param1__, __eml__, __aemt__, __hpo__
    ; eml  -> exhaustive multiplier level
    ; aemt -> Accumolator exhaustive multiplier threshold
    ; hpo  -> handle potential overflow
        ; allowed: none, break, limit 

    .local t_out, w_out, l_out, mode, t_mult, eml, aemt, hpo

    .ifblank __eml__
        __eml__ = null 
    .endif

    .ifblank __aemt__
        __aemt__ = null 
    .endif

    .ifblank __hpo__
        __hpo__  = null 
    .endif

    

    ; if no override specified, set warning level for exhausitve multiplier to template config
    eml  = null_coalesce(__eml__,  exhuastive_multiplier)

    ; set threshold in which, during accumolator mode, we deem that we run the risk of overflow
    aemt = null_coalesce(__aemt__, accumolator_exhaustive_multiplier_threshold)

    ; cant use null coalescion : not an int
    .if is_null __hpo__
        hpo = handle_potential_overflow
    .else
        hpo = __hpo__
    .endif

    .ifblank __param1__
        .if .tcount(__param0__) > 1 ; typed/array
            t_mult .set 0
            detype __param0__, t_mult

            passthrough_types t_mult, {ar, imp}, \
                "Invalid Type indicator for implied constant multiply : Consider removing type indication or passing with ar/imp"

        .endif

        ; force ca65 into int validating
        
        l_mult = ilabel __param0__  ; works on the belief that ilabel doesn't require type indication presence

        .if l_mult > aemt && !isallowed(eml)
            handlewarning emt, "Multipler value will cause overflow or consistent upperlimit results"
        .endif


        .if !.xmatch(hpo, "none")

            cmp #aemt
            bcs @safe

            .if .xmatch(hpo, "break")
                ; break on evaluated overflow (should be used in DEBUG mode only)
                brk
            .elseif (signed t_mult)
                .if l_mult < 0
                    lda #$80    ; lowest unsigned number (before sign underflow)
                .else
                    lda #$7f    ; highest signed number (before sign overflow)
                .endif
            .else
                lda #$ff        ; only one result as multiplying u8 against negative is erroneous
            .endif

            @safe:
        .endif

        __cmult__acc__body l_mult   ; call accumolator 'implied' mode handler.
        .exitmacro
    .endif

    t_out .set 0
    detype __param0__, t_out
    w_out = typeval t_out
    
    l_out = ilabel __param1__
    t_mult .set 0
    detype __param1__, t_mult

    w_mult = (MSSB (abs l_mult)) >> 3   ; fake width (doesn't really consequent the output size)

    .if (w_mult >= w_out) && !isallowed(eml)
        handlewarning eml, "Multipler value will cause overflow or consistent upperlimit results"

        .if (signed t_out)
            __stz (eindex t_out: l_out, 0)
        .else
        .endif
    .endif

    passthrough_types t_mult, {ar, imp}, \
        "Invalid Type indicator for implied constant multiply : Consider removing type indication or passing with ar/imp"
    
    

    
.endmacro