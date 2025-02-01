.macro __header_build __prgrom__, __chrrom__, __mapper__, __type__, __altnt__, __trainer__, __battery__, __submapper__, __prgram__, __chrram__, __mirror__, __eeprom__, __cpu__, __vstype__, __vsppu__, __extended__, __misc__, __expansion__, __chrnvram__
    .literal "NES", $1a
    
    .byte (prgrom & $ff)     ; byte 4 => prg rom atm 16KiB
    .byte (chrrom & $ff)     ; byte 5 => chr rom atm 8KiB

    ; byte 6 (flags)
    .byte (((__mapper__) << 4) & $ff) | (__altnt__ * 8) | (__trainer__ * 4) | (__battery__ * 2) | (__mirror__)

    ; byte 7 (flags)
    .byte (__mapper__ & $f0) | $08 | __type__

    ; byte 8 (flags)
    .byte (__submapper__ << 4) | (__mapper__ >> 8)

    ; byte 9 (flags)
    .byte ((__chrrom__ >> 4) & $f0) | (__prgrom__ >> 8)
    
    ; byte 10 (cart prg ram sizes)
    .repeat 8, iter
        .ifdef prgramtamt_done
            .if (__prgram__ >> 6) & (1 << (8 - iter))
                prgramtamt_done = 8 - iter
            .endif
        .endif
    .endrepeat

    .repeat 8, iter
        .ifdef eepromamt_done
            .if (__eeprom__ >> 6) & (1 << (8 - iter))
                eepromamt_done = 8 - iter
            .endif
        .endif
    .endrepeat
    
    .ifndef eepromamt_done
        eepromamt_done = 0    ; made useless if no present value
    .endif

    .ifndef prgramtamt_done
        prgramtamt_done = 0
    .endif
    
    .byte (eepromamt_done << 4) | prgramtamt_done

    ; byte 11 (cart chr ram sizes)
    .repeat 8, iter
        .ifdef chrramamt_done
            .if (__chrram__ >> 6) & (1 << (8 - iter))
                chrramamt_done = 8 - iter
            .endif
        .endif
    .endrepeat

    .repeat 8, iter
        .ifdef chrnvramamt_done
            .if (__chrnvram__ >> 6) & (1 << (8 - iter))
                chrnvramamt_done = 8 - iter
            .endif
        .endif
    .endrepeat
    
    .ifndef chrnvramamt_done
        chrnvramamt_done = 0    ; made useless if no present value
    .endif

    .ifndef chrramamt_done
        chrramamt_done = 0
    .endif

    .byte (chrnvramamt_done << 4) | chrramamt_done

    ; byte 12 (cpu timing)
    .byte __cpu__

    ; byte 13 (special)
    .if __type__ = header_system_vs
        .byte __vstype__ | __vsppu__
    .elseif __type__ = header_system_extended
        .byte (__extended__)
    .endif

    ; byte 14 (misc roms)
    .byte __misc__

    ; byte 15 (default expansion device)
    .byte __expansion__
.endmacro
; https://www.nesdev.org/wiki/NES_2.0

.macro __header_paramset __paramx__, __prgrom__, __chrrom__, __mapper__, __type__, __altnt__, __trainer__, __battery__, __submapper__, __prgram__, __chrram__, __mirror__, __eeprom__, __cpu__, __vstype__, __vsppu__, __extended__, __misc__, __expansion__, __chrnvram__
    .if .left(1, __paramx__) .set e_prgrom
        prgrom .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_chrrom
        chrrom .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_mapper
        mapper .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_type
        type .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_altnt
        altnt .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_trainer
        trainer .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_battery
        battery .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_submapper
        submapper .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_prgram
        prgram .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_chrram
        chrram .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_mirror
        mirror .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_eeprom
        eeprom .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_cpu
        cpu .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_vsppu
        vsppu .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_extended
        extended .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_misc
        misc .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_expansion
        expansion .set .right(1, __paramx__)
    .else.if .left(1, __paramx__) .set e_chrnvram
        chrnvram .set .right(1, __paramx__)
    .else
        .fatal "Header Key Word Argument not recognized : Please refer to TODO: DOCS LINK HERE"
    .endif
.endmacro

.macro header __param0__, __param1__, __param2__, __param3__, __param4__, __param5__, __param6__, __param7__, __param8__, __param9__, __param10__, __param11__, __param12__, __param13__, __param14__, __param15__, __param16__, __param17__
    .local __paramc__, prgrom, chrrom, mapper, type, altnt, trainer, battery, mirror, submapper, chrram, cpu, vstype, vsppu, misc, expansion, prgram, eeprom, chrnvram, extended

    .if 1
        e_prgrom      = 0
        e_chrrom      = 1 
        e_mapper      = 2
        e_type        = 3
        e_altnt       = 4
        e_trainer     = 5
        e_battery     = 6
        e_submapper   = 7
        e_prgram      = 8
        e_chrram      = 9
        e_mirror      = 10
        e_eeprom      = 11
        e_chrnvram    = 12
        e_cpu         = 13
        e_vstype      = 14
        e_vsppu       = 15
        e_extended    = 16
        e_misc        = 17
        e_expansion   = 18
        end           = 19

        prgrom      .set null
        chrrom      .set null
        mapper      .set null
        type        .set null
        altnt       .set null
        trainer     .set null
        battery     .set null
        mirror      .set null
        submapper   .set null
        cpu         .set null
        vstype      .set null
        vsppu       .set null
        misc        .set null
        expansion   .set null
        prgram      .set null
        eeprom      .set null
        chrnvram    .set null
        prgrom      .set null
        extended    .set null
        
        .ifndef __param0__
            __param0__ = null
        .endif

        .ifndef __param1__
            __param1__ = null
        .endif

        .ifndef __param2__
            __param2__ = null
        .endif

        .ifndef __param3__
            __param3__ = null
        .endif

        .ifndef __param4__
            __param4__ = null
        .endif

        .ifndef __param5__
            __param5__ = null
        .endif

        .ifndef __param6__
            __param6__ = null
        .endif

        .ifndef __param7__
            __param7__ = null
        .endif

        .ifndef __param8__
            __param8__ = null
        .endif

        .ifndef __param9__
            __param9__ = null
        .endif

        .ifndef __param10__
            __param10__ = null
        .endif

        .ifndef __param11__
            __param11__ = null
        .endif

        .ifndef __param12__
            __param12__ = null
        .endif

        .ifndef __param13__
            __param13__ = null
        .endif

        .ifndef __param14__
            __param14__ = null
        .endif

        .ifndef __param15__
            __param15__ = null
        .endif

        .ifndef __param16__
            __param16__ = null
        .endif

        .ifndef __param17__
            __param17__ = null
        .endif

        .ifndef __param18__
            __param18__ = null
        .endif
    .endif
    
    __header_paramset param0,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param1,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param2,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param3,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param4,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param5,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param6,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param7,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param8,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param9,  prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param10, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param11, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param12, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param13, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param14, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param15, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param16, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param17, prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram

    null_coalset prgrom,    1   ; 1x16KiB Mirrored
    null_coalset chrrom,    0   ; No CHR ROM
    null_coalset mapper,    0   ; NROM
    null_coalset type,      0   ; Standard NES/Famicom
    null_coalset altnt,     0   ; no alt member
    null_coalset trainer,   0   ; if you enable this, it's likely a mistake
    null_coalset battery,   0   ; no battery (thats literally a crime yo)
    null_coalset submapper, 0   ; in total honesty I dont even know what this means
    null_coalset prgram,    0   ; no PRG RAM 
    null_coalset chrram,    0   ; no CHR RAM
    null_coalset mirror,    0   ; Vertical Mirror
    null_coalset eeprom,    0   ; no EEPROM
    null_coalset chrnvram   0   ; no chrnvRAM
    null_coalset cpu,       0   ; NTSC
    null_coalset vstype,    0   ; 
    null_coalset vsppu,     0   ;
    null_coalset misc,      0   ; no misc rom
    null_coalset extended,  0   ; no extension
    null_coalset expansion, 0   ; no expansion device


    __header_build prgrom, chrrom, mapper, type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vstype, vsppu, extended, misc, expansion, chrnvram
.endmacro