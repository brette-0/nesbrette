; NESBRETTE ADDRESS LISTING
; MODIFYING THESE WILL CHANGE WHERE NESBRETTE ROUTINES TARGET

; FUNCTION_DIVIDE
.define FUNCTION_DIVIDE_NUMERATOR   $07 ; ZP 1 byte
.define FUNCTION_DIVIDE_DENOMINATOR $08 ; ZP 1 byte
.define FUNCTION_DIVIDE_TEMP        $11 ; ZP 1 byte

; FUNCTION_ROOT
.define FUNCTION_ROOT_ROOT          $02 ; ZP 1 byte
.define FUNCTION_ROOT_REM           $03 ; ZP 1 byte
.define FUNCTION_ROOT_IN_HIGH       $00 ; ZP 1 byte
.define FUNCTION_ROOT_IN_LOW        $01 ; ZP 1 byte

; FUNCTION_HYPOTENUSES
.define FUNCTION_HYPOTENUSE_A       $06 ; ZP 1 byte
.define FUNCTION_HYPOTENUSE_O       FUNCTION_HYPOTENUSE_A + 1 ; ZP 1 byte

; RAYCAST_CALCULATE
.define RAYCAST_A_COARSE            $09 ; ZP 1 byte
.define RAYCAST_A_FINE              $0a ; ZP 1 byte
.define RAYCAST_O_COARSE            $0b ; ZP 1 byte
.define RAYCAST_O_FINE              $0c ; ZP 1 byte

; FUNCITON_MULITPLY
.define FUNCTION_MULTIPLY_FIRST     $0d ; ZP 1 byte
.define FUNCTION_MULTIPLY_OUT_HIGH  $0e ; ZP 1 byte

; FUNCTION_ASIN_DECIMAL
.define ASIN_DECIMAL_NUMERATOR      $0f ; ZP 1 byte
.define ASIN_DECIMAL_DENOMINATOR    $10 ; ZP 1 byte

; RAYCAST
.if USE_FIXED_INTERVAL = 0
    .define RAYCAST_INTERVAL_ADDR   $13 ; ZP 1 byte     ;; this address should be read from, instead of lda #RAYCAST_FIXED_INTERVAL if USE_FIXED_INTERVAL is disabled
    .define RAYCAST_TEMP            $12 ; ZP 1 byte
.endif