.feature c_comments

/*

    libcore.include

    contains:
        preproc directives
        macpack includes
        libroot
        __libinclude__
        __libroot__
        include
        includefrom

    dev:
        __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN

*/


/*

    TODO: Globally including procedures should have a warning circumstance
    TODO: All modules to have .ifndef=>def
    TODO: Modules to include depenancies (warn when doing so)
            AutomaticDependancyInclusionException level
*/

.setcpu "6502x"


.feature force_range            ; wiithout this so much would break
.feature line_continuations     ; without this the library would look terrible
.feature string_escapes         ; these are useful for bigger projects
.feature underline_in_numbers   ; there is no reason to disable this
.feature bracket_as_indirect    ; used to indicate indirect (duh)
.feature dollar_in_identifiers  ; used to indicate optional parameter
.feature ubiquitous_idents      ; enables the overloading

; sets libroot define path and includes libcore
.macro __libroot__ __path__, __sys$__
    .define libroot __path__

    .include .concat(libroot, "/core/report.asm")           ; configurable warnings
    .include .concat(libroot, "/core/register.asm")         ; register macro paramterisation
    .include .concat(libroot, "/core/synth.asm")            ; qol for dev time
    .include .concat(libroot, "/core/defines.asm")          ; defines
    .include .concat(libroot, "/core/memory.asm")           ; Preproc Label Management
    .include .concat(libroot, "/core/rules.asm")            ; Rule System for safe development
    .include .concat(libroot, "/core/typing.asm")           ; Variable Type System
    
    .ifblank __sys$__
        .include .concat(libroot, "/core/nes/header.asm")   ; Header and lib config
        .define LIBCORE_ROM NES
    .elseif .xmatch(__sys$__, nes)
        .define LIBCORE_ROM NES
        .include .concat(libroot, "/core/nes/header.asm")   ; Header and lib config
    .elseif .xmatch(__sys$__, fds)
        .define LIBCORE_ROM FDS
        .include .concat(libroot, "/core/fds/header.asm")   ; Header and lib config
    .endif

    .include .concat(libroot, "/core/table.asm")
    
    .include .concat(libroot, "/core/overload.asm")         ; overloaded instruction mnemonics
    .include .concat(libroot, "/ca65hl/ca65hl.h")

    ::FAST_RAM_START   .set $c0
    ::FAST_RAM_END     .set $100                            ; fast ram for small payloads

    ::ZP_START         .set $b0
    ::ZP_END           .set $c0                             ; ZP exclusive

    ::SLOW_RAM_START   .set $300
    ::SLOW_RAM_END     .set $320                            ; slow ram for functions, reasonable to be permanant

    
.endmacro

; error case: when you are trying to include something that doesn't exist from something that does
.macro __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN __feature__, __moduletok__
    .fatal .sprintf("UnrecognizedModuleException: %s is not a recognized module of %s!", __feature__, __moduletok__)
.endmacro

.macro include __token__
    .if     .xmatch(__token__, math)        ; include math
        ; include all math
    .elseif .xmatch(__token__, math_trig)   ; include math.trig
        ; check for trig tables define
        ; include trig features
    .elseif .xmatch(__token__, math_const)  ; include only constant math features
        ; include all math that doesn't call to assembled code body
    .elseif .xmatch(__token__, memory)      ; include memory
        ; include all memory
    .else
        .include .concat(libroot, __token__); raw include
    .endif

.endmacro

.macro includefrom __moduletok__, __feature__

    module  .set 0
    feature .set 0

    .if     .xmatch(__moduletok__, math)    ; include math
        module .set 0   ; math has id 0
    .elseif .xmatch(__moduletok__, memory)  ; include memory
        module .set 1   ; memory has id 1
    .elseif .xmatch(__moduletok__, synth)   ; include synth
        module .set 2   ; synth has id 12
    .else
        .fatal .sprintf("parent module '%s' not a recognized module!", __moduletok__)
    .endif

    .if     module = 0  ; math
        .if     .xmatch(__feature__, add)       ; (add, sub)
        .elseif .xmatch(__feature__, cmult)     ; (cmult)
        .elseif .xmatch(__feature__, mult)      ; (mult)
        .elseif .xmatch(__feature__, constdiv)  ; (cdiv)
        .elseif .xmatch(__feature__, div)       ; (div)
        .elseif .xmatch(__feature__, trig)      ; (trig)
        .else
            __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN __feature__, __moduletok__
        .endif
    .elseif module = 1  ; memory
        .if     .xmatch(__feature__, xsxb)      ; (mssb, lssb, msub, lsub, mssbyte, msubyte, lssbyte, lsubyte, MSSB, LSSB, MSUB, LSUB)
            .include .concat(libroot, "/memory/xsxb.asm")
        .elseif .xmatch(__feature__, shift)     ; (lshift, rshift)
            .include .concat(libroot, "/memory/shift.asm")
        .elseif .xmatch(__feature__, flush)     ; (stz, ldz) ?? stz --> flush (MAKE LDZ CORE?)
            .include .concat(libroot, "/memory/flush.asm")
        .elseif .xmatch(__feature__, memcpy)    ; (memcpy)(MAKE MEMCPY CORE?)
            .include .concat(libroot, "/memory/memcpy.asm")
        .elseif .xmatch(__feature__, compare)   ; (compare)
            .include .concat(libroot, "/memory/compare.asm")
;        .elseif .xmatch(__feature__, juggle)    ; (juggle) [ DEPRECATED ]
;            .include .concat(libroot, "/memory/juggle.asm")
        .else
            __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN __feature__, __moduletok__
        .endif
    .elseif module = 2  ; synth
        .if     .xmatch(__feature__, generic)
            .include .concat(libroot, "/synth/generic.asm")
        .elseif .xmatch(__feature__, idtable)
            .include .concat(libroot, "/synth/idtable.asm")
        .elseif .xmatch(__feature__, stack)
            .include .concat(libroot, "/synth/stack.asm")
        .else
            __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN __feature__, __moduletok__
        .endif
    .endif

.endmacro