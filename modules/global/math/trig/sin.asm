; untested

.macro sin
    .ifdef SIN_TABLE
        .if (.ifdef(COS_TABLE)) .and (WARNINGS_MATH_TRIG_DUAL_TABLE)
            .warning "Both Sine and Cosine tables are defined, unless speed is crucial remove one for more space"
        .endif

        temp = ADDRESSES_MATH_TRIG_SIN_TEMP

        sta temp
        and #$3f        ; A holds the incalculable element
        bit temp        ; N = negative, V = Horizontal Mirror

        clc
        bpl @no_set
            sec
        
        @no_set:        ; here we are sign extending with carry
        
        tax
        lda SIN_TABLE, x

        bvc @no_mirror
            eor #$ff

        @no_mirror:
    .elseif .ifdef(COS_TABLE)
        clc
        adc #$40
        cos
    .else
        .fatal "Cannot compute sine without sine or cosine table"
    .endif
    .exitmacro