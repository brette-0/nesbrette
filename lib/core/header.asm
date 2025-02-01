.macro __header_build __prgrom__, __chrrom__, __mapper__, __Type__, __altnt__, __trainer__, __battery__, __submapper__, __prgram__, __chrram__, __mirror__, __eeprom__, __cpu__, __vsType__, __vsppu__, __extended__, __misc__, __expansion__, __chrnvram__
    .literal "NES", $1a
    
    .byte (prgrom & $ff)     ; byte 4 => prg rom atm 16KiB
    .byte (chrrom & $ff)     ; byte 5 => chr rom atm 8KiB

    ; byte 6 (flags)
    .byte (((__mapper__) << 4) & $ff) | (__altnt__ * 8) | (__trainer__ * 4) | (__battery__ * 2) | (__mirror__)

    ; byte 7 (flags)
    .byte (__mapper__ & $f0) | $08 | __Type__

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
    .if __Type__ = 1
        .byte __vsType__ | __vsppu__
    .elseif __Type__ = 3
        .byte (__extended__)
    .endif

    ; byte 14 (misc roms)
    .byte __misc__

    ; byte 15 (default expansion device)
    .byte __expansion__
.endmacro
; https://www.nesdev.org/wiki/NES_2.0

.macro __header_paramset __paramx__, __prgrom__, __chrrom__, __mapper__, __Type__, __altnt__, __trainer__, __battery__, __submapper__, __prgram__, __chrram__, __mirror__, __eeprom__, __cpu__, __vsType__, __vsppu__, __extended__, __misc__, __expansion__, __chrnvram__
    .if .left(1, __paramx__) = e_prgrom
        prgrom .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_chrrom
        chrrom .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_mapper
        mapper .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_Type
        Type .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_altnt
        altnt .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_trainer
        trainer .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_battery
        battery .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_submapper
        submapper .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_prgram
        prgram .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_chrram
        chrram .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_mirror
        mirror .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_eeprom
        eeprom .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_cpu
        cpu .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_vsppu
        vsppu .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_extended
        extended .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_misc
        misc .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_expansion
        expansion .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = e_chrnvram
        chrnvram .set .right(1, __paramx__)
    .elseif .left(1, __paramx__) = null
    .else
        .fatal "Header Key Word Argument not recognized : Please refer to TODO: DOCS LINK HERE"
    .endif
.endmacro

.macro header __param0__, __param1__, __param2__, __param3__, __param4__, __param5__, __param6__, __param7__, __param8__, __param9__, __param10__, __param11__, __param12__, __param13__, __param14__, __param15__, __param16__, __param17__
;    .local __paramc__, prgrom, chrrom, mapper, Type, altnt, trainer, battery, mirror, submapper, chrram, cpu, vsType, vsppu, misc, expansion, prgram, eeprom, chrnvram, extended

    ; scope confined enums
    e_prgrom      = 0
    e_chrrom      = 1 
    e_mapper      = 2
    e_Type        = 3
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
    e_vsType      = 14
    e_vsppu       = 15
    e_extended    = 16
    e_misc        = 17
    e_expansion   = 18
    end           = 19

    null = (1 << 31)    ; TODO: Move this out of header

    ; build params
    prgrom      .set null
    chrrom      .set null
    mapper      .set null
    Type        .set null
    altnt       .set null
    trainer     .set null
    battery     .set null
    mirror      .set null
    submapper   .set null
    cpu         .set null
    vsType      .set null
    vsppu       .set null
    misc        .set null
    expansion   .set null
    prgram      .set null
    eeprom      .set null
    chrram      .set null
    chrnvram    .set null
    prgrom      .set null
    extended    .set null
    
    ; kwargs
    param0      .set null
    param1      .set null
    param2      .set null
    param3      .set null
    param4      .set null
    param5      .set null
    param6      .set null
    param7      .set null
    param8      .set null
    param9      .set null
    param10     .set null
    param11     .set null
    param12     .set null
    param13     .set null
    param14     .set null
    param15     .set null
    param16     .set null
    param17     .set null

    .ifblank __param0__
        param0 .set null
    .else
        param0 .set __param0__
    .endif

    .ifblank __param1__
        param1 .set null
    .else
        param1 .set __param1__
    .endif

    .ifblank __param2__
        param2 .set null
    .else
        param2 .set __param2__
    .endif

    .ifblank __param3__
        param3 .set null
    .else
        param3 .set __param3__
    .endif

    .ifblank __param4__
        param4 .set null
    .else
        param4 .set __param4__
    .endif

    .ifblank __param5__
        param5 .set null
    .else
        param5 .set __param5__
    .endif

    .ifblank __param6__
        param6 .set null
    .else
        param6 .set __param6__
    .endif

    .ifblank __param7__
        param7 .set null
    .else
        param7 .set __param7__
    .endif

    .ifblank __param8__
        param8 .set null
    .else
        param8 .set __param8__
    .endif

    .ifblank __param9__
        param9 .set null
    .else
        param9 .set __param9__
    .endif

    .ifblank __param10__
        param10 .set null
    .else
        param10 .set __param10__
    .endif

    .ifblank __param11__
        param11 .set null
    .else
        param11 .set __param11__
    .endif

    .ifblank __param12__
        param12 .set null
    .else
        param12 .set __param12__
    .endif

    .ifblank __param13__
        param13 .set null
    .else
        param13 .set __param13__
    .endif

    .ifblank __param14__
        param14 .set null
    .else
        param14 .set __param14__
    .endif

    .ifblank __param15__
        param15 .set null
    .else
        param15 .set __param15__
    .endif

    .ifblank __param16__
        param16 .set null
    .else
        param16 .set __param16__
    .endif

    .ifblank __param17__
        param17 .set null
    .else
        param17 .set __param17__
    .endif

    
    __header_paramset param0,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param1,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param2,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param3,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param4,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param5,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param6,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param7,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param8,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param9,  prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param10, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param11, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param12, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param13, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param14, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param15, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param16, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
    __header_paramset param17, prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram

    null_coalset prgrom,    1   ; 1x16KiB Mirrored
    null_coalset chrrom,    0   ; No CHR ROM
    null_coalset mapper,    0   ; NROM
    null_coalset Type,      0   ; Standard NES/Famicom
    null_coalset altnt,     0   ; no alt member
    null_coalset trainer,   0   ; if you enable this, it's likely a mistake
    null_coalset battery,   0   ; no battery (thats literally a crime yo)
    null_coalset submapper, 0   ; in total honesty I dont even know what this means
    null_coalset prgram,    0   ; no PRG RAM 
    null_coalset chrram,    0   ; no CHR RAM
    null_coalset mirror,    0   ; Vertical Mirror
    null_coalset eeprom,    0   ; no EEPROM
    null_coalset chrnvram,  0   ; no chrnvRAM
    null_coalset cpu,       0   ; NTSC
    null_coalset vsType,    0   ; 
    null_coalset vsppu,     0   ;
    null_coalset misc,      0   ; no misc rom
    null_coalset extended,  0   ; no extension
    null_coalset expansion, 0   ; no expansion device


    __header_build prgrom, chrrom, mapper, Type, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vsType, vsppu, extended, misc, expansion, chrnvram
.endmacro