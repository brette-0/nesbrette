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
    .define INCLUDE_FUNCTION_MATH_ADDITION_iptr         ; 00-01-00 ; Variable Width Addition with indirectly accessed arguments    ;
    .define INCLUDE_FUNCTION_MATH_ADDITION_optr         ; 00-02-00 ; Variable Width Addition with indirectly stored output         ;
    .define INCLUDE_FUNCTION_MATH_ADDITION_ioptr        ; 00-03-00 ; VWidth Addition with indirectly accessed/stored arguements    ;

        ; Subtraction
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION           ; 00-04-00 ; Variable Width Subtraction                                    ; 
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION_iptr      ; 00-05-00 ; Variable Width Subtraction                                    ; 
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION_optr      ; 00-06-00 ; Variable Width Subtraction                                    ;  
    .define INCLUDE_FUNCTION_MATH_SUBTRACTION_ioptr     ; 00-07-00 ; Variable Width Subtraction                                    ;

        ; Multipication
    