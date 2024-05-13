; NESBRETTE EXCLUDES LISTING
; TOGGLING THESE DEFINES VALUE TO NON-ZERO WILL REMOVE THESE ROUTINES FROM YOUR OUTPUT

.define EXCLUDE_SNES_POLL_FAST          0
.define EXCLUDE_SNES_POLL_FAST_SINGLE   0
.define EXCLUDE_UNSAFE_SET_FLAGS        1

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