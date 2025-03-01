; safe : Complex CPU Access rule enforcer

; move to libcore/qol.asm
.macro contains __element__, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, _37, _38, _39, _40, _41, _42, _43, _44, _45, _46, _47, _48, _49, _50, _51, _52, _53, _54, _55, _56, _57, _58, _59, _60, _61, _62, _63, _64, _65, _66, _67, _68, _69, _70, _71, _72, _73, _74, _75, _76, _77, _78, _79, _80, _81, _82, _83, _84, _85, _86, _87, _88, _89, _90, _91, _92, _93, _94, _95, _96, _97, _98, _99
    .ifblank _0
        .exitmacro
    .else
        .if .xmatch(_0, __element__)
            __element__ .set null
            .exitmacro
        .else
            contains __element__, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, _37, _38, _39, _40, _41, _42, _43, _44, _45, _46, _47, _48, _49, _50, _51, _52, _53, _54, _55, _56, _57, _58, _59, _60, _61, _62, _63, _64, _65, _66, _67, _68, _69, _70, _71, _72, _73, _74, _75, _76, _77, _78, _79, _80, _81, _82, _83, _84, _85, _86, _87, _88, _89, _90, _91, _92, _93, _94, _95, _96, _97, _98, _99 
        .endif
    .endif
.endmacro

.macro __ld__pre __reg__, __operand__, __index__
    .local resp

    resp .set __operand__
    __safescan resp LIBCORE_STRICT_WRITEONLY
    
    .if is_null resp
        .fatal "Writing to Strict Write-Only CPU is forbidden, its likely that you are using the wrong label"
    .endif

    .if !.xmatch(.left(1, __operand__), !)
        resp .set __operand__
        __safescan resp LIBCORE_WRITEONLY

        .if is_null resp
            .ifdef PROFILE_WriteOnlyROMRead
                deferror worm PROFILE_WriteOnlyROMRead
            .else
                deferror worm error
            .endif
            report worm, .sprintf("Writing to ROM is forbidden, perhaps use  ld%s !%s", .string(__reg__), .string(__operand__))
        .endif
    .endif
    
    .if (!.blank(__index__)) && (.hibyte(__operand__) = $1f) && (.lobyte(__operand__) <> $00)
        ; if tar 1f01 <= i < 4000
    .endif
.endmacro

/*
    Access Mask:
        ins $100        ; [optional] block access to stack (unless overruled)
        ins !$100       ; overruled access to stack

    Read Mask:
        ldr PPUCTRL
        ldr PPUMASK
        ldr PPUOPENBUS
        ldr PPUSCROLL
        ldr OAMADDR
        ldr OAMDATA
        ldr PPUADDR     ; will NOT generate shadow
        ldr PPUDATA     ; will generate shadow

        ldr PPUREGS, x  ; dummy read risk

        ldr APUREGS     ; safe
        ldr OPENBUS     ; block
        ldr !OPENBUS    ; overruled access to $4000-$6000

    Write Mask:
    str PPUSTAT         ; strictly forbidden
    str PPUOPENBUS      ; allowed
    str !PPUSTAT        ; error

    $4000 is inaccessible as Mapper defines
    $6000 is inacesssible as Mapepr defines
    
    ROM is writeable as Mapper Defines

    ; GENERATE SEPERATE RULES FOR INDEXING as Mapper Defines
    new access:
        ins [ptr]

    TODO: make rules modifiable with macro

*/

.macro modsafe __feature__, __kwarg0__, __kwarg1__, __kwarg2__

.endmacro