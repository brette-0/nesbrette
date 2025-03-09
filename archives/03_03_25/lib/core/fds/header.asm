; completely untested


.macro header __disks__, __shadow$__
    .byte "FDS", $1a, __disks__
    .res 11, $00

    PPUCTRL = $2000
    PPUMASK = $2001
    PPUSTAT = $2002
    OAMADDR = $2003
    OAMDATA = $2004

    PPUSCROLL = $2005

    PPUADDR = $2006
    PPUDATA = $2007

    OAMDMA  = $4017

    PPUOPENBUS = $2002
        ; block reads always
        ; always allow writes
    PPUSTATUS  = $2002

    TIMERIRQLo      = $4020
    TIMERIRQHi      = $4021
    TIMERIRQCtrl    = $4022
    MASTERIOENABLE  = $4023
    WRITEDATA       = $4024
    FDSCTRL         = $4025
    EXTERNCONNECT   = $4026
    DISKSTATUS      = $4027

    DISKSTAT        = $4030
    READDATA        = $4030
    DRIVESTAT       = $4031


    .define LIBCORE_READONLY                    DISKSTAT, READDATA, DRIVESTAT
    .define LIBCORE_WRITEONLY                   PPUCTRL, PPUMASK, PPUSCROLL, OAMADDR, OAMDATA, OAMDMA, PPUADDR, PPUDATA, TIMERIRQLo, TIMERIRQHi, TIMERIRQCtrl, MASTERIOENABLE, WRITEDATA, FDSCTRL, EXTERNCONNECT
    .define LIBCORE_STRICT_READONLY             PPUSTAT, PPUSTATUS, IODATA, IODATA2, IODAT1, IODAT2
    .define LIBCORE_STRICT_WRITEONLY            PPUOPENBUS, IOSTROBE, FRAMECTRL
    .define LIBCORE_WRITEONLYSHADOWACCESS       
    .define LIBCORE_READONLYSHADOWACCESS

    .ifndef __shadow$__
        shadow = 0
    .else
        shadow = __shadow$__
    .endif

    .if shadow
        .undefine LIBCORE_WRITEONLYSHADOWACCESS
        .undefine LIBCORE_READONLYSHADOWACCESS
        
        .define LIBCORE_WRITEONLYSHADOWACCESS   PPUCTRL, PPUMASK, PPUDATA, FRAMECTRL
        .define LIBCORE_READONLYSHADOWACCESS    ; review read only regs

        shadow PPUCTRL,   SPPUCTRL
        shadow PPUMASK,   SPPUMASK
        shadow PPUDATA,   SPPUDATA
        shadow FRAMECTRL, SFRAMECTRL
    .else
        .undefine noshadow
    .endif
.endif