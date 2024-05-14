; NESBRETTE EXCLUDES LISTING
; TOGGLING THESE DEFINES VALUE TO NON-ZERO WILL REMOVE THESE ROUTINES FROM YOUR OUTPUT

.define EXCLUDE_SNES_POLL_FAST          0
.define EXCLUDE_SNES_POLL_FAST_SINGLE   0
.define EXCLUDE_UNSAFE_SET_FLAGS        1
.define EXCLUDE_DIVIDE                  0
.define EXCLUDE_ROOT                    0
.define EXCLUDE_HYPOTENUSE              0

; TABLES
.define EXCLUDE_SQUARE_TABLE            0
.define EXCLUDE_EXTENDED_SQUARE_TABLE   1

; MMC5
.define EXCLUDE_MMC5                    1
.define EXCLUDE_HYPOTENUSE_MMC5         0

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