.macro abeq target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jeq target
    .else
        beq target
    .endif
    .endmacro
.macro abne target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jne target
    .else
        bne target
    .endif
    .endmacro
.macro abpl target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jpl target
    .else
        bpl target
    .endif
    .endmacro
.macro abmi target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jmi target
    .else
        bmi target
    .endif
    .endmacro
.macro abcc target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jcc target
    .else
        bcc target
    .endif
    .endmacro
.macro abcs target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jcs target
    .else
        bcs target
    .endif
    .endmacro
.macro abvc target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jvc target
    .else
        bvs target
    .endif
    .endmacro
.macro abvs target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jvs target
    .else
        bvc target
    .endif
    .endmacro
.macro rne target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            beq @temp
                rts
            @temp:
        .else
            bne target
        .endif
    .else
        .local @temp
        beq @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rcs target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bcc @temp
                rts
            @temp:
        .else
            bcs target
        .endif
    .else
        .local @temp
        bcc @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rcc target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bcs @temp
                rts
            @temp:
        .else
            bcc target
        .endif
    .else
        .local @temp
        bcc @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rpl target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bmi @temp
                rts
            @temp:
        .else
            bpl target
        .endif
    .else
        .local @temp
        bmi @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rmi target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bpl @temp
                rts
            @temp:
        .else
            bmi target
        .endif
    .else
        .local @temp
        bpl @temp
            rts
        @temp:
    .endif

    .endmacro
.macro rvc target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bvs @temp
                rts
            @temp:
        .else
            bvc target
        .endif
    .else
        .local @temp
        bvs @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rvs target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bvc @temp
                rts
            @temp:
        .else
            bvc target
        .endif
    .else
        .local @temp
        bvc @temp
            rts
        @temp:
    .endif

    .endmacro