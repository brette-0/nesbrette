
; register
ar   = 16
xr   = 32
yr   = 64

; cpu status
zf   = 1
cf   = 2
if   = 4
df   = 8
bf   = 16
; 
of   = 64
nf   = 128

; endian
little = 1
small  = little
big    = 2
large  = big

; memory address mode
imp     = 0
imm     = 1
zp      = 2
zpx     = 3
zpy     = 4
wabs    = 5
wabsx   = 6
wabsy   = 7
abst    = 8
absx    = 9
absy    = 10
inabsy  = 11
inabsx  = 12
inabs   = 13

; flag states
unset = 0
clear = unset
set = 1

; handy kw to resolve jsr->rts
return = 1

null = (1 << 30)    ; can be viewed as type negative typeless


.define isindexed(__mode__)\
    ((__mode__ = imp)       * 0) | \
    ((__mode__ = imm)       * 0) | \
    ((__mode__ = zp )       * 0) | \
    ((__mode__ = zpx)       * 1) | \
    ((__mode__ = zpy)       * 2) | \
    ((__mode__ = wabs)      * 0) | \
    ((__mode__ = wabsx)     * 1) | \
    ((__mode__ = wabsy)     * 2) | \
    ((__mode__ = abst)      * 0) | \
    ((__mode__ = absx)      * 1) | \
    ((__mode__ = absy)      * 2) | \
    ((__mode__ = inabsx)    * 1) | \
    ((__mode__ = inabsy)    * 2) | \
    ((__mode__ = inabs)     * 0)