; FUNCTION
    ; MATH
        ; Dynamic variant procedure ZP variables

        FUNCTION_MATH_ADDITION_ADDER        = $00
        FUNCTION_MATH_ADDITION_OUT          = $08   ; this number *should* be : Adder + maxWidth UNLESS using Dynamic Mode

        FUNCTION_MATH_SUBTRACTION_SUBBER    = $00
        FUNCTION_MATH_SUBTRACTION_OUT       = $08   ; this number *should* be : Adder + maxWidth UNLESS using Dynamic Mode

        FUNCTION_MATH_MULTIPLY_MULTIPLIER   = $00
        FUNCTION_MATH_MULTIPLY_TEMP         = $08   ; Width is 2 * MULTIPLICATION_WIDTH
        FUNCTION_MATH_MULTIPLY_MULT_TEMP    = $10   ; Width is MULTIPLICATION_WIDTH
        FUNCTION_MATH_MULTIPLY_OUTPUT       = $18   ; Width is MULTIPLICATION_WIDTH

        ; abs
        FUNCTION_MATH_ADDITION_WIDTH        = $300
        FUNCTION_MATH_SUBTRACTION_WIDTH     = $300
        FUNCTION_MATH_MULTIPLICATION_WIDTH  = $300
        FUNCTION_MATH_MULTIPLICATION_LAST   = $301