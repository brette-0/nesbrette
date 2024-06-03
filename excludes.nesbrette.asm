; NESBRETTE EXCLUDES LISTING
; TOGGLING THESE DEFINES VALUE TO NON-ZERO WILL REMOVE THESE ROUTINES FROM YOUR OUTPUT

.define EXCLUDE_SNES_POLL_FAST          1
.define EXCLUDE_SNES_POLL_FAST_SINGLE   1
.define EXCLUDE_UNSAFE_SET_FLAGS        1

.define EXCLUDE_2A03_DIVIDE             1
    ; 2A03_Feature_Enables
    .define DIVIDE_FAST_POWER_OF_TWO    RELEASE
    .define CHECK_FOR_ZERODIVISIONERROR RELEASE
        ; Zero_Division Handler
        .define BREAK_ON_ZERODIVISIONERROR  !RELEASE
    .define CHECK_FOR_DIVISOR_ONE       0

.define EXCLUDE_ROOT                    0
.define EXCLUDE_HYPOTENUSE              0
.define EXCLUDE_MULTIPLY_8              1
.define EXCLUDE_MULTIPLY_16             0
.define EXCLUDE_ASIN_FRAC               1

; TABLES
.define EXCLUDE_SQUARE_TABLE            0
.define EXCLUDE_EXTENDED_SQUARE_TABLE   1
.define EXCLUDE_ASIN_TABLE              1
.define EXCLUDE_INVERSE_TABLE           !(MAPPER = 5)

; MMC5
.define EXCLUDE_HYPOTENUSE_MMC5         1
.define EXCLUDE_MMC5_DIVIDE             0

; RAYCASTING
.define EXCLUDE_RAYCAST_CALCULATE       1
.define EXCLUDE_THETA_COEFFICIENT       1

; TODO - add routine copy macros
;   .macro pull_snes_poll_fast
;       ; body
;       .endmacro
;   ----------------------------
; Application:
;   .proc snes_poll_fast
;       pull_snes_poll_fast
;       .endproc
;   ----------------------------
; Effect:   nesbretter routines can be defined dynamically.


; TODO - change ifs to warn if disabled instead of not being used
; TODO - add procedure alias overides