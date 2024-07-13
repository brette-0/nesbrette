; FUNCTION

; ID key:
        ; Module - Routine - Component


; MATH    : Module 00
; INPUT   : Module 01
; STRING  : Module 02
; LOGIC   : Module 03
; SPRITE  : Module 04
; PHYSICS : Module 05


            ; Name                                      ; ID       ; Desc                                                          ; Dependencies
    ; MATH
        ; Addition
    .define INCLUDE_FUNCTION_MATH_ADDITION              ; 00-00-00 ; Variable Width Addition                                       ;
        .define INCLUDE_FMA_ADDITION_INIT               ; 00-00-01 ; initialises args for VWidth Addition                          ;
    .define INCLUDE_FUNCTION_MATH_ADDITION_iptr         ; 00-01-00 ; Variable Width Addition with indirectly accessed arguments    ;
        .define INCLUDE_FMA_iptr_ADDITION_INIT          ; 00-01-01 ; initialises args for iptr VWidth Addition                     ;
    .define INCLUDE_FUNCTION_MATH_ADDITION_optr         ; 00-02-00 ; Variable Width Addition with indirectly stored output         ;
        .define INCLUDE_FMA_ADDITION_optr_INIT          ; 00-02-01 ; initialises args for optr VWidth Addition                     ;
    .define INCLUDE_FUNCTION_MATH_ADDITION_ioptr        ; 00-03-00 ; VWidth Addition with indirectly accessed/stored arguements    ;
        .define INCLUDE_FMA_ADDITION_ioptr_INIT         ; 00-03-01 ; initialises args for ioptr VWidth Addition                    ;

        ; Subtraction
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION           ; 00-04-00 ; Variable Width Subtraction                                    ;
        .define INCLUDE_FUNCTION_FMS_INIT               ; 00-04-01 ; initialises args for VWidth Subtraction                       ; 
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION_iptr      ; 00-05-00 ; Variable Width Subtraction                                    ;
        .define INCLUDE_FUNCTION_FMS_iptr_INIT          ; 00-05-01 ; initialises args for VWidth Subtraction                       ; 
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION_optr      ; 00-06-00 ; Variable Width Subtraction                                    ;
        .define INCLUDE_FUNCTION_FMS_optr_INIT          ; 00-06-01 ; initialises args for VWidth Subtraction                       ;  
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION_ioptr     ; 00-07-00 ; Variable Width Subtraction                                    ;
        .define INCLUDE_FUNCTION_FMS_ioptr_INIT         ; 00-07-01 ; initialises args for VWidth Subtraction                       ;

        ; Multipication
    