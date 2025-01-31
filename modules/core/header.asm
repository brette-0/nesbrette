.macro insert_header
    .literal "NES", $1a
    
    .byte (CONSTANTS_HEADER_PRG_ROM_AMT & $ff)     ; byte 4 => prg rom atm 16KiB
    .byte (CONSTANTS_HEADER_CHR_ROM_AMT & $ff)     ; byte 5 => chr rom atm 8KiB

    ; byte 6 (flags)
    .byte (((CONSTANTS_HEADER_MAPPER) << 4) & $ff) | (CONSTANTS_HEADER_ALT_NT * 8) | (CONSTANTS_HEADER_TRAINER * 4) | (CONSTANTS_HEADER_BATTERY * 2) | (CONSTANTS_HEADER_MIRRORING)

    ; byte 7 (flags)
    .byte (CONSTANTS_HEADER_MAPPER & $f0) | $08 | CONSTANTS_HEADER_CONSOLE_TYPE

    ; byte 8 (flags)
    .byte (CONSTANTS_HEADER_SUBMAPPER << 4) | (CONSTANTS_HEADER_MAPPER >> 8)

    ; byte 9 (flags)
    .byte ((CONSTANTS_HEADER_CHR_ROM_AMT >> 4) & $f0) | (CONSTANTS_HEADER_PRG_ROM_AMT >> 8)
    
    ; byte 10 (cart prg ram sizes)
    .repeat 8, iter
        .ifdef prgramtamt_done
            .if (CONSTANTS_HEADER_PRG_RAM_AMT >> 6) & (1 << (8 - iter))
                prgramtamt_done = 8 - iter
            .endif
        .endif
    .endrepeat

    .repeat 8, iter
        .ifdef eepromamt_done
            .if (CONSTANTS_HEADER_EEPROM_AMT >> 6) & (1 << (8 - iter))
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
            .if (CONSTANTS_HEADER_CHR_RAM_AMT >> 6) & (1 << (8 - iter))
                chrramamt_done = 8 - iter
            .endif
        .endif
    .endrepeat

    .repeat 8, iter
        .ifdef chrnvramamt_done
            .if (CONSTANTS_HEADER_CHR_NVRAM_AMT >> 6) & (1 << (8 - iter))
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
    .byte CONSTANTS_HEADER_CPU_TIMING

    ; byte 13 (special)
    .if CONSTANTS_HEADER_CONSOLE_TYPE = header_system_vs
        .byte (CONSTANTS_HEADER_VS_HW_TYPE << 4) | CONSTANTS_HEADER_VS_PPU_TYPE
    .elseif CONSTANTS_HEADER_CONSOLE_TYPE = header_system_extended
        .byte (CONSTANTS_HEADER_EXTENDED_CONSOLE_TYPE)
    .endif

    ; byte 14 (misc roms)
    .byte CONSTANTS_HEADER_MISC_ROMS_AMT

    ; byte 15 (default expansion device)
    .byte CONSTANTS_HEADER_DEFAULT_EXPANSION_DEVICE
.endmacro
; https://www.nesdev.org/wiki/NES_2.0