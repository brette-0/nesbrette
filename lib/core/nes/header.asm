; TODO: Check for impossible cart elements (INCOMPATIBLE WITH MAPPERS)
; TODO: Add argument 'noshadow' for there being no shadow mappers generated AT ALL

.macro __header_build __prgrom__, __chrrom__, __mapper__, __system__, __altnt__, __trainer__, __battery__, __submapper__, __prgram__, __chrram__, __mirror__, __eeprom__, __cpu__, __vssystem__, __vsppu__, __extended__, __misc__, __expansion__, __chrnvram__
    .literal "NES", $1a
    
    .byte (prgrom & $ff)     ; byte 4 => prg rom atm 16KiB
    .byte (chrrom & $ff)     ; byte 5 => chr rom atm 8KiB

    ; byte 6 (flags)
    .byte (((__mapper__) << 4) & $ff) | (__altnt__ * 8) | (__trainer__ * 4) | (__battery__ * 2) | (__mirror__)

    ; byte 7 (flags)
    .byte (__mapper__ & $f0) | $08 | __system__

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
    .if __system__ = 1
        .byte __vsType__ | __vsppu__
    .elseif __system__ = 3
        .byte (__extended__)
    .endif

    ; byte 14 (misc roms)
    .byte __misc__

    ; byte 15 (default expansion device)
    .byte __expansion__
.endmacro
; https://www.nesdev.org/wiki/NES_2.0

.macro __header_expansion __kwarg__, __expansion__
    .if .xmatch(.right(1, __kwarg__), standard) || .xmatch(.right(1, __kwarg__), STANDARD)
        __expansion__ .set 1
    .elseif .xmatch(.right(1, __kwarg__), fourscore) || .xmatch(.right(1, __kwarg__), FOURSCORE)
        __expansion__ .set 2
    .elseif .xmatch(.right(1, __kwarg__), fourplay) || .xmatch(.right(1, __kwarg__), FOURPLAY)
        __expansion__ .set 3
    .elseif .xmatch(.right(1, __kwarg__), vs4016) || .xmatch(.right(1, __kwarg__), VS4016)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vs4017) || .xmatch(.right(1, __kwarg__), VS4017)
        __expansion__ .set 5
    .elseif .xmatch(.right(1, __kwarg__), vszapper) || .xmatch(.right(1, __kwarg__), VSZAPPER)
        __expansion__ .set 7
    .elseif .xmatch(.right(1, __kwarg__), zapper) || .xmatch(.right(1, __kwarg__), ZAPPER)
        __expansion__ .set 8
    .elseif .xmatch(.right(1, __kwarg__), zappers) || .xmatch(.right(1, __kwarg__), ZAPPERS)
        __expansion__ .set 9
    .elseif .xmatch(.right(1, __kwarg__), lightgun) || .xmatch(.right(1, __kwarg__), LIGHTGUN)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt32) || .xmatch(.right(1, __kwarg__), VT32)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt369) || .xmatch(.right(1, __kwarg__), VT369)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), umc) || .xmatch(.right(1, __kwarg__), UMC)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vs) || .xmatch(.right(1, __kwarg__), VS)
        __expansion__ .set 1
    .elseif .xmatch(.right(1, __kwarg__), pc10) || .xmatch(.right(1, __kwarg__), PC10) || .xmatch(.right(1, __kwarg__), playchoice10) || .xmatch(.right(1, __kwarg__), PLAYCHOICE10)
        __expansion__ .set 2
    .elseif .xmatch(.right(1, __kwarg__), decimal) || .xmatch(.right(1, __kwarg__), DECIMAL)
        __expansion__ .set 3
    .elseif .xmatch(.right(1, __kwarg__), epsm) || .xmatch(.right(1, __kwarg__), EPSM)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt01) || .xmatch(.right(1, __kwarg__), VT01)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt02) || .xmatch(.right(1, __kwarg__), VT02)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt03) || .xmatch(.right(1, __kwarg__), VT03)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt09) || .xmatch(.right(1, __kwarg__), VT09)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt32) || .xmatch(.right(1, __kwarg__), VT32)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt369) || .xmatch(.right(1, __kwarg__), VT369)
        __expansion__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), umc) || .xmatch(.right(1, __kwarg__), UMC)
        __expansion__ .set 4
        .elseif .xmatch(.right(1, __kwarg__), bandai_hypershot) || .xmatch(.right(1, __kwarg__), BANDAI_HYPERSHOT)
        __expansion__ .set $0A
    .elseif .xmatch(.right(1, __kwarg__), power_pad_a) || .xmatch(.right(1, __kwarg__), POWER_PAD_A)
        __expansion__ .set $0B
    .elseif .xmatch(.right(1, __kwarg__), power_pad_b) || .xmatch(.right(1, __kwarg__), POWER_PAD_B)
        __expansion__ .set $C
    .elseif .xmatch(.right(1, __kwarg__), family_trainer_a) || .xmatch(.right(1, __kwarg__), FAMILY_TRAINER_A)
        __expansion__ .set $0D
    .elseif .xmatch(.right(1, __kwarg__), family_trainer_b) || .xmatch(.right(1, __kwarg__), FAMILY_TRAINER_B)
        __expansion__ .set $0E
    .elseif .xmatch(.right(1, __kwarg__), arkanoid_vaus_nes) || .xmatch(.right(1, __kwarg__), ARKANOID_VAUS_NES)
        __expansion__ .set $0F
    .elseif .xmatch(.right(1, __kwarg__), arkanoid_vaus_famicom) || .xmatch(.right(1, __kwarg__), ARKANOID_VAUS_FAMICOM)
        __expansion__ .set $10
    .elseif .xmatch(.right(1, __kwarg__), two_vaus_plus_recorder) || .xmatch(.right(1, __kwarg__), TWO_VAUS_PLUS_RECORDER)
        __expansion__ .set $11
    .elseif .xmatch(.right(1, __kwarg__), konami_hypershot) || .xmatch(.right(1, __kwarg__), KONAMI_HYPERSHOT)
        __expansion__ .set $12
    .elseif .xmatch(.right(1, __kwarg__), coconuts_pachinko) || .xmatch(.right(1, __kwarg__), COCONUTS_PACHINKO)
        __expansion__ .set $13
    .elseif .xmatch(.right(1, __kwarg__), exciting_boxing) || .xmatch(.right(1, __kwarg__), EXCITING_BOXING)
        __expansion__ .set $14
    .elseif .xmatch(.right(1, __kwarg__), jissen_mahjong) || .xmatch(.right(1, __kwarg__), JISSEN_MAHJONG)
        __expansion__ .set $15
    .elseif .xmatch(.right(1, __kwarg__), party_tap) || .xmatch(.right(1, __kwarg__), PARTY_TAP)
        __expansion__ .set $16
    .elseif .xmatch(.right(1, __kwarg__), oeka_kids_tablet) || .xmatch(.right(1, __kwarg__), OEKA_KIDS_TABLET)
        __expansion__ .set $17
    .elseif .xmatch(.right(1, __kwarg__), sunsoft_barcode_battler) || .xmatch(.right(1, __kwarg__), SUNSOFT_BARCODE_BATTLER)
        __expansion__ .set $18
    .elseif .xmatch(.right(1, __kwarg__), miracle_piano) || .xmatch(.right(1, __kwarg__), MIRACLE_PIANO)
        __expansion__ .set $19
    .elseif .xmatch(.right(1, __kwarg__), pokkun_moguraa) || .xmatch(.right(1, __kwarg__), POKKUN_MOGURAA)
        __expansion__ .set $1A
    .elseif .xmatch(.right(1, __kwarg__), top_rider) || .xmatch(.right(1, __kwarg__), TOP_RIDER)
        __expansion__ .set $1B
    .elseif .xmatch(.right(1, __kwarg__), double_fisted) || .xmatch(.right(1, __kwarg__), DOUBLE_FISTED)
        __expansion__ .set $1C
    .elseif .xmatch(.right(1, __kwarg__), famicom_3d) || .xmatch(.right(1, __kwarg__), FAMICOM_3D)
        __expansion__ .set $1D
    .elseif .xmatch(.right(1, __kwarg__), doremikko) || .xmatch(.right(1, __kwarg__), DOREMIKKO)
        __expansion__ .set $1E
    .elseif .xmatch(.right(1, __kwarg__), rob_gyro) || .xmatch(.right(1, __kwarg__), ROB_GYRO)
        __expansion__ .set $1F
    .elseif .xmatch(.right(1, __kwarg__), famicom_recorder) || .xmatch(.right(1, __kwarg__), FAMICOM_RECORDER)
        __expansion__ .set $20
    .elseif .xmatch(.right(1, __kwarg__), ascii_turbo_file) || .xmatch(.right(1, __kwarg__), ASCII_TURBO_FILE)
        __expansion__ .set $21
    .elseif .xmatch(.right(1, __kwarg__), igs_storage_battle) || .xmatch(.right(1, __kwarg__), IGS_STORAGE_BATTLE)
        __expansion__ .set $22
    .elseif .xmatch(.right(1, __kwarg__), family_basic_keyboard) || .xmatch(.right(1, __kwarg__), FAMILY_BASIC_KEYBOARD)
        __expansion__ .set $23
    .elseif .xmatch(.right(1, __kwarg__), dongda_pec) || .xmatch(.right(1, __kwarg__), DONGDA_PEC)
        __expansion__ .set $24
    .elseif .xmatch(.right(1, __kwarg__), bit79) || .xmatch(.right(1, __kwarg__), BIT79)
        __expansion__ .set $25
    .elseif .xmatch(.right(1, __kwarg__), subor_keyboard) || .xmatch(.right(1, __kwarg__), SUBOR_KEYBOARD)
        __expansion__ .set $26
    .elseif .xmatch(.right(1, __kwarg__), subor_keyboard_mouse_8bit) || .xmatch(.right(1, __kwarg__), SUBOR_KEYBOARD_MOUSE_8BIT)
        __expansion__ .set $27
    .elseif .xmatch(.right(1, __kwarg__), subor_keyboard_mouse_24bit_4016) || .xmatch(.right(1, __kwarg__), SUBOR_KEYBOARD_MOUSE_24BIT_4016)
        __expansion__ .set $28
    .elseif .xmatch(.right(1, __kwarg__), snes_mouse) || .xmatch(.right(1, __kwarg__), SNES_MOUSE)
        __expansion__ .set $29
    .elseif .xmatch(.right(1, __kwarg__), multicart) || .xmatch(.right(1, __kwarg__), MULTICART)
        __expansion__ .set $2A
    .elseif .xmatch(.right(1, __kwarg__), two_snes_controllers) || .xmatch(.right(1, __kwarg__), TWO_SNES_CONTROLLERS)
        __expansion__ .set $2B
    .elseif .xmatch(.right(1, __kwarg__), racer_mate) || .xmatch(.right(1, __kwarg__), RACER_MATE)
        __expansion__ .set $2C
    .elseif .xmatch(.right(1, __kwarg__), uforce) || .xmatch(.right(1, __kwarg__), UFORCE)
        __expansion__ .set $2D
    .elseif .xmatch(.right(1, __kwarg__), rob_stack_up) || .xmatch(.right(1, __kwarg__), ROB_STACK_UP)
        __expansion__ .set $2E
    .elseif .xmatch(.right(1, __kwarg__), city_patrolman) || .xmatch(.right(1, __kwarg__), CITY_PATROLMAN)
        __expansion__ .set $2F
    .elseif .xmatch(.right(1, __kwarg__), sharp_c1) || .xmatch(.right(1, __kwarg__), SHARP_C1)
        __expansion__ .set $30
    .elseif .xmatch(.right(1, __kwarg__), swapped_controller) || .xmatch(.right(1, __kwarg__), SWAPPED_CONTROLLER)
        __expansion__ .set $31
    .elseif .xmatch(.right(1, __kwarg__), excalibur_sudoku) || .xmatch(.right(1, __kwarg__), EXCALIBUR_SUDOKU)
        __expansion__ .set $32
    .elseif .xmatch(.right(1, __kwarg__), abl_pinball) || .xmatch(.right(1, __kwarg__), ABL_PINBALL)
        __expansion__ .set $33
    .elseif .xmatch(.right(1, __kwarg__), golden_nugget) || .xmatch(.right(1, __kwarg__), GOLDEN_NUGGET)
        __expansion__ .set $34
    .elseif .xmatch(.right(1, __kwarg__), keda_keyboard) || .xmatch(.right(1, __kwarg__), KEDA_KEYBOARD)
        __expansion__ .set $35
    .elseif .xmatch(.right(1, __kwarg__), subor_keyboard_mouse_24bit_4017) || .xmatch(.right(1, __kwarg__), SUBOR_KEYBOARD_MOUSE_24BIT_4017)
        __expansion__ .set $36
    .elseif .xmatch(.right(1, __kwarg__), port_test) || .xmatch(.right(1, __kwarg__), PORT_TEST)
        __expansion__ .set $37
    .elseif .xmatch(.right(1, __kwarg__), bandai_multi_game) || .xmatch(.right(1, __kwarg__), BANDAI_MULTI_GAME)
        __expansion__ .set $38
    .elseif .xmatch(.right(1, __kwarg__), venom_tv_dance) || .xmatch(.right(1, __kwarg__), VENOM_TV_DANCE)
        __expansion__ .set $39
    .elseif .xmatch(.right(1, __kwarg__), lg_tv_remote) || .xmatch(.right(1, __kwarg__), LG_TV_REMOTE)
        __expansion__ .set $3A
    .elseif .xmatch(.right(1, __kwarg__), famicom_network) || .xmatch(.right(1, __kwarg__), FAMICOM_NETWORK)
        __expansion__ .set $3B
    .elseif .xmatch(.right(1, __kwarg__), king_fishing) || .xmatch(.right(1, __kwarg__), KING_FISHING)
        __expansion__ .set $3C
    .elseif .xmatch(.right(1, __kwarg__), croaky_karaoke) || .xmatch(.right(1, __kwarg__), CROAKY_KARAOKE)
        __expansion__ .set $3D
    .elseif .xmatch(.right(1, __kwarg__), kewang_keyboard) || .xmatch(.right(1, __kwarg__), KEWANG_KEYBOARD)
        __expansion__ .set $3E
    .elseif .xmatch(.right(1, __kwarg__), zecheng_keyboard) || .xmatch(.right(1, __kwarg__), ZECHENG_KEYBOARD)
        __expansion__ .set $3F
    .elseif .xmatch(.right(1, __kwarg__), subor_keyboard_ps2_mouse) || .xmatch(.right(1, __kwarg__), SUBOR_KEYBOARD_PS2_MOUSE)
        __expansion__ .set $40
    .else
        __expansion__ .set .right(1, __kwarg__)
    .endif
.endmacro

.macro __header_extended __kwarg__, __extended__
    .if .xmatch(.right(1, __kwarg__), standard) || .xmatch(.right(1, __kwarg__), STANDARD)
        .define LIBCORE_EXTENDED standard
        __extended__ .set 0
    .elseif .xmatch(.right(1, __kwarg__), vs) || .xmatch(.right(1, __kwarg__), VS)
        .define LIBCORE_EXTENDED vs
        __extended__ .set 1
    .elseif .xmatch(.right(1, __kwarg__), pc10) || .xmatch(.right(1, __kwarg__), PC10) || .xmatch(.right(1, __kwarg__), playchoice10) || .xmatch(.right(1, __kwarg__), PLAYCHOICE10)
        .define LIBCORE_EXTENDED pc10
        __extended__ .set 2
    .elseif .xmatch(.right(1, __kwarg__), decimal) || .xmatch(.right(1, __kwarg__), DECIMAL)
        .define LIBCORE_EXTENDED decimal
        __extended__ .set 3
    .elseif .xmatch(.right(1, __kwarg__), epsm) || .xmatch(.right(1, __kwarg__), EPSM)
        .define LIBCORE_EXTENDED epsm
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt01) || .xmatch(.right(1, __kwarg__), VT01)
        .define LIBCORE_EXTENDED vt01
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt02) || .xmatch(.right(1, __kwarg__), VT02)
        .define LIBCORE_EXTENDED vt02
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt03) || .xmatch(.right(1, __kwarg__), VT03)
        .define LIBCORE_EXTENDED vt03
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt09) || .xmatch(.right(1, __kwarg__), VT09)
        .define LIBCORE_EXTENDED vt09
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt32) || .xmatch(.right(1, __kwarg__), VT32)
        .define LIBCORE_EXTENDED vt32
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), vt369) || .xmatch(.right(1, __kwarg__), VT369)
        .define LIBCORE_EXTENDED vt369
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), umc) || .xmatch(.right(1, __kwarg__), UMC)
        .define LIBCORE_EXTENDED umc
        __extended__ .set 4
    .elseif .xmatch(.right(1, __kwarg__), fns) || .xmatch(.right(1, __kwarg__), FNS)
        .define LIBCORE_EXTENDED fns
        __extended__ .set 4
    .else
        .define LIBCORE_EXTENDED standard
        __extended__ .set .right(1, __kwarg__)
    .endif
.endmacro

.macro __header_cpu __kwarg__, __cpu__
.if .xmatch(.right(1, __kwarg__), ntsc) || .xmatch(.right(1, __kwarg__), rp2c02) || .xmatch(.right(1, __kwarg__), NTSC) || .xmatch(.right(1, __kwarg__), RP2C02)
        .define LIBCORE_CPU ntsc
        __cpu__ .set 0
    .elseif .xmatch(.right(1, __kwarg__), pal) || .xmatch(.right(1, __kwarg__), rp2c07) || .xmatch(.right(1, __kwarg__), PAL) || .xmatch(.right(1, __kwarg__), RP2C07)
        .define LIBCORE_CPU pal
        __cpu__ .set 1
    .elseif .xmatch(.right(1, __kwarg__), dendy) || .xmatch(.right(1, __kwarg__), ua6538) || .xmatch(.right(1, __kwarg__), DENDY) || .xmatch(.right(1, __kwarg__), UA6538)
        .define LIBCORE_CPU dendy
        __cpu__ .set 2
    .elseif .xmatch(.right(1, __kwarg__), multi) || .xmatch(.right(1, __kwarg__), MULTI)
        .define LIBCORE_CPU multi
        __cpu__ .set 3
    .else
        .define LIBCORE_CPU ntsc
        __cpu__ .set .right(1, __kwarg__)
    .endif
.endmacro

.macro __header_system __kwarg__, __system__
.if .xmatch(.right(1, __kwarg__), standard) || .xmatch(.right(1, __kwarg__), STANDARD)
        .define LIBCORE_SYSTEM standard
        __system__ .set 0
    .elseif .xmatch(.right(1, __kwarg__), vs) || .xmatch(.right(1, __kwarg__), VS)
        .define LIBCORE_SYSTEM vs
        __system__ .set 1
    .elseif .xmatch(.right(1, __kwarg__), playchoice) || .xmatch(.right(1, __kwarg__), playchoice10) || .xmatch(.right(1, __kwarg__), pc10) || .xmatch(.right(1, __kwarg__), PLAYCHOICE) || .xmatch(.right(1, __kwarg__), PLAYCHOICE10) || .xmatch(.right(1, __kwarg__), PC10)
        .define LIBCORE_SYSTEM playchoice
        __system__ .set 2
    .elseif .xmatch(.right(1, __kwarg__), extended) || .xmatch(.right(1, __kwarg__), EXTENDED)
        .define LIBCORE_SYSTEM extended
        __system__ .set 3
    .else
        .define LIBCORE_SYSTEM standard
        __system__ .set .right(1, __kwarg__)
    .endif
.endmacro

.macro __header_mapper __kwarg__, __mapper__
    .if .xmatch(.right(1, __kwarg__), nrom) || .xmatch(.right(1, __kwarg__), NROM)
        __mapper__ .set 0
        .define LIBCORE_MAPPER nrom
    .elseif .xmatch(.right(1, __kwarg__), mmc1) || .xmatch(.right(1, __kwarg__), MMC1)
        __mapper__ .set 1
        .define LIBCORE_MAPPER mmc1
    .elseif .xmatch(.right(1, __kwarg__), uxrom) || .xmatch(.right(1, __kwarg__), UXROM)
        __mapper__ .set 2
        .define LIBCORE_MAPPER uxrom
    .elseif .xmatch(.right(1, __kwarg__), cnrom) || .xmatch(.right(1, __kwarg__), CNROM)
        __mapper__ .set 3
        .define LIBCORE_MAPPER cnrom
    .elseif .xmatch(.right(1, __kwarg__), mmc3) || .xmatch(.right(1, __kwarg__), MMC3) || .xmatch(.right(1, __kwarg__), mmc6) || .xmatch(.right(1, __kwarg__), MMC6) || .xmatch(.right(1, __kwarg__), txrom) || .xmatch(.right(1, __kwarg__), TXROM)
        __mapper__ .set 4
        .define LIBCORE_MAPPER mmc3
    .elseif .xmatch(.right(1, __kwarg__), mmc5) || .xmatch(.right(1, __kwarg__), MMC5) || .xmatch(.right(1, __kwarg__), exrom) || .xmatch(.right(1, __kwarg__), EXROM)
        __mapper__ .set 5
        .define LIBCORE_MAPPER mmc5
    .elseif .xmatch(.right(1, __kwarg__), axrom) || .xmatch(.right(1, __kwarg__), AXROM)
        __mapper__ .set 7
        .define LIBCORE_MAPPER axrom
    .elseif .xmatch(.right(1, __kwarg__), mmc2) || .xmatch(.right(1, __kwarg__), MMC2) || .xmatch(.right(1, __kwarg__), pxrom) || .xmatch(.right(1, __kwarg__), PXROM)
        __mapper__ .set 9
        .define LIBCORE_MAPPER mmc2
    .elseif .xmatch(.right(1, __kwarg__), mmc4) || .xmatch(.right(1, __kwarg__), MMC4) || .xmatch(.right(1, __kwarg__), fxrom) || .xmatch(.right(1, __kwarg__), FXROM)
        __mapper__ .set 10
        .define LIBCORE_MAPPER mmc4
    .elseif .xmatch(.right(1, __kwarg__), colordreams) || .xmatch(.right(1, __kwarg__), COLORDREAMS)
        __mapper__ .set 11
        .define LIBCORE_MAPPER colordreams
    .elseif .xmatch(.right(1, __kwarg__), cprom) || .xmatch(.right(1, __kwarg__), CPROM)
        __mapper__ .set 13
        .define LIBCORE_MAPPER cprom
    .elseif .xmatch(.right(1, __kwarg__), n163) || .xmatch(.right(1, __kwarg__), N163)
        __mapper__ .set 19
        .define LIBCORE_MAPPER n163
    .elseif .xmatch(.right(1, __kwarg__), vrc4) || .xmatch(.right(1, __kwarg__), VRC4)
        __mapper__ .set 21
        .define LIBCORE_MAPPER vrc4
    .elseif .xmatch(.right(1, __kwarg__), vrc6) || .xmatch(.right(1, __kwarg__), VRC6)
        __mapper__ .set 24
        .define LIBCORE_MAPPER vrc6
    .elseif .xmatch(.right(1, __kwarg__), bnrom) || .xmatch(.right(1, __kwarg__), BNROM)
        __mapper__ .set 34
        .define LIBCORE_MAPPER bnrom
    .elseif .xmatch(.right(1, __kwarg__), gxrom) || .xmatch(.right(1, __kwarg__), GXROM)
        __mapper__ .set 66
        .define LIBCORE_MAPPER gxrom
    .elseif .xmatch(.right(1, __kwarg__), afterburner) || .xmatch(.right(1, __kwarg__), AFTERBURNER)
        __mapper__ .set 68
        .define LIBCORE_MAPPER afterburner
    .elseif .xmatch(.right(1, __kwarg__), fme7) || .xmatch(.right(1, __kwarg__), FME7) || .xmatch(.right(1, __kwarg__), s5b) || .xmatch(.right(1, __kwarg__), S5B)
        __mapper__ .set 69
        .define LIBCORE_MAPPER fme7
    .elseif .xmatch(.right(1, __kwarg__), camerica) || .xmatch(.right(1, __kwarg__), CAMERICA)
        __mapper__ .set 71
        .define LIBCORE_MAPPER camerica
    .elseif .xmatch(.right(1, __kwarg__), vrc3) || .xmatch(.right(1, __kwarg__), VRC3)
        __mapper__ .set 73
        .define LIBCORE_MAPPER vrc3
    .elseif .xmatch(.right(1, __kwarg__), piratemmc3) || .xmatch(.right(1, __kwarg__), PIRATEMMC3)
        __mapper__ .set 74
        .define LIBCORE_MAPPER piratemmc3
    .elseif .xmatch(.right(1, __kwarg__), vrc1) || .xmatch(.right(1, __kwarg__), VRC1)
        __mapper__ .set 75
        .define LIBCORE_MAPPER vrc1
    .elseif .xmatch(.right(1, __kwarg__), n109) || .xmatch(.right(1, __kwarg__), N109)
        __mapper__ .set 76
        .define LIBCORE_MAPPER n109
    .elseif .xmatch(.right(1, __kwarg__), nina03) || .xmatch(.right(1, __kwarg__), NINA03)
        __mapper__ .set 79
        .define LIBCORE_MAPPER nina03
    .elseif .xmatch(.right(1, __kwarg__), vrc7) || .xmatch(.right(1, __kwarg__), VRC7)
        __mapper__ .set 85
        .define LIBCORE_MAPPER vrc7
    .elseif .xmatch(.right(1, __kwarg__), jf13) || .xmatch(.right(1, __kwarg__), JF13)
        __mapper__ .set 86
        .define LIBCORE_MAPPER jf13
    .elseif .xmatch(.right(1, __kwarg__), senjou) || .xmatch(.right(1, __kwarg__), SENJOU)
        __mapper__ .set 94
        .define LIBCORE_MAPPER senjou
    .elseif .xmatch(.right(1, __kwarg__), event) || .xmatch(.right(1, __kwarg__), EVENT)
        __mapper__ .set 105
        .define LIBCORE_MAPPER event
    .elseif .xmatch(.right(1, __kwarg__), piratenina03) || .xmatch(.right(1, __kwarg__), PIRATENINA03)
        __mapper__ .set 113
        .define LIBCORE_MAPPER piratenina03
    .elseif .xmatch(.right(1, __kwarg__), txsrom) || .xmatch(.right(1, __kwarg__), TXSROM)
        __mapper__ .set 118
        .define LIBCORE_MAPPER txsrom
    .elseif .xmatch(.right(1, __kwarg__), tqrom) || .xmatch(.right(1, __kwarg__), TQROM)
        __mapper__ .set 119
        .define LIBCORE_MAPPER tqrom
    .elseif .xmatch(.right(1, __kwarg__), eprom24c01) || .xmatch(.right(1, __kwarg__), EPROM24C01)
        __mapper__ .set 159
        .define LIBCORE_MAPPER eprom24c01
    .elseif .xmatch(.right(1, __kwarg__), subor) || .xmatch(.right(1, __kwarg__), SUBOR)
        __mapper__ .set 166
        .define LIBCORE_MAPPER subor
    .elseif .xmatch(.right(1, __kwarg__), climber) || .xmatch(.right(1, __kwarg__), CLIMBER)
        __mapper__ .set 180
        .define LIBCORE_MAPPER climber
    .elseif .xmatch(.right(1, __kwarg__), cnromprot) || .xmatch(.right(1, __kwarg__), CNROMPROT)
        __mapper__ .set 185
        .define LIBCORE_MAPPER cnromprot
    .elseif .xmatch(.right(1, __kwarg__), piratemmc3b) || .xmatch(.right(1, __kwarg__), PIRATEMMC3B)
        __mapper__ .set 192
        .define LIBCORE_MAPPER piratemmc3b
    .elseif .xmatch(.right(1, __kwarg__), dxrom) || .xmatch(.right(1, __kwarg__), DXROM)
        __mapper__ .set 206
        .define LIBCORE_MAPPER dxrom
    .elseif .xmatch(.right(1, __kwarg__), n175) || .xmatch(.right(1, __kwarg__), N175)
        __mapper__ .set 210
        .define LIBCORE_MAPPER n175
    .elseif .xmatch(.right(1, __kwarg__), action52) || .xmatch(.right(1, __kwarg__), ACTION52)
        __mapper__ .set 228
        .define LIBCORE_MAPPER action52
    .else
        .define LIBCORE_MAPPER nrom         ; we have no clue
        __mapper__ .set .right(1, __kwarg__)
    .endif
.endmacro

.macro __header_paramset __paramx__, __prgrom__, __chrrom__, __mapper__, __system__, __altnt__, __trainer__, __battery__, __submapper__, __prgram__, __chrram__, __mirror__, __eeprom__, __cpu__, __vsType__, __vsppu__, __extended__, __misc__, __expansion__, __chrnvram__
    .if .xmatch(.left(1, __paramx__), prgrom)
        prgrom .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), chrrom)
        chrrom .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), mapper)
        __header_mapper __paramx__, __mapper__
    .elseif .xmatch(.left(1, __paramx__), system)
        __header_system  __paramx__, __system__
    .elseif .xmatch(.left(1, __paramx__), altnt)
        altnt .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), trainer)
        trainer .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), battery)
        battery .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), submapper)
        submapper .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), prgram)
        prgram .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), chrram)
        chrram .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), mirror)
        mirror .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), eeprom)
        eeprom .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), cpu)
        __header_cpu __paramx__, __cpu__
    .elseif .xmatch(.left(1, __paramx___, __vsType__)
        __vsType__ __kwarg__, __extended__
    .elseif .xmatch(.left(1, __paramx__), vsppu)
        vsppu .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), extended )
        extended .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), misc)
        misc .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), expansion)
        __header_expansion __paramx__, __expansion__
    .elseif .xmatch(.left(1, __paramx__), chrnvram)
        chrnvram .set .right(1, __paramx__)
    .elseif .xmatch(.left(1, __paramx__), noshadow)
        .define noshadow
    .else
        .fatal "Header Key Word Argument not recognized : Please refer to TODO: DOCS LINK HERE"
    .endif
.endmacro

.macro header __param0__, __param1__, __param2__, __param3__, __param4__, __param5__, __param6__, __param7__, __param8__, __param9__, __param10__, __param11__, __param12__, __param13__, __param14__, __param15__, __param16__, __param17__, __param18__
    ; scope confined enums
    e_prgrom      = 0
    e_chrrom      = 1 
    e_mapper      = 2
    e_system      = 3
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

    ; build params
    prgrom      .set null
    chrrom      .set null
    mapper      .set null
    system      .set null
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
    chrram      .set null
    chrnvram    .set null
    extended    .set null

    .ifnblank __param0__
        __header_paramset __param0__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param1__
        __header_paramset __param1__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param2__
        __header_paramset __param2__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param3__
        __header_paramset __param3__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param4__
        __header_paramset __param4__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param5__
        __header_paramset __param5__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param6__
        __header_paramset __param6__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param7__
        __header_paramset __param7__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param8__
        __header_paramset __param8__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param9__
        __header_paramset __param9__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param10__
        __header_paramset __param10__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param11__
        __header_paramset __param11__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param12__
        __header_paramset __param12__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param13__
        __header_paramset __param13__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param14__
        __header_paramset __param14__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param15__
        __header_paramset __param15__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param15__
        __header_paramset __param15__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param17__
        __header_paramset __param17__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    .ifnblank __param18__
        __header_paramset __param18__, prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
    .endif

    null_coalset prgrom,    1   ; 1x16KiB Mirrored
    null_coalset chrrom,    0   ; No CHR ROM
    null_coalset mapper,    0   ; NROM
    null_coalset system,    0   ; Standard NES/Famicom
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
    null_coalset vstype,    0   ; 
    null_coalset vsppu,     0   ;
    null_coalset misc,      0   ; no misc rom
    null_coalset extended,  0   ; no extension
    null_coalset expansion, 0   ; no expansion device
    
    ::LIBCORE_PRGROM        = prgrom
    ::LIBCORE_CHRROM        = chrrom
    ::LIBCORE_MAPPER_NUM    = mapper
    ::LIBCORE_SYSTEM_NUM    = system
    ::LIBCORE_ALTNT         = altnt
    ::LIBCORE_TRAINER       = trainer
    ::LIBCORE_BATTERY       = battery
    ::LIBCORE_MIRROR        = mirror
    ::LIBCORE_SUBMAPPER     = submapper
    ::LIBCORE_CPU_NUM       = system
    ::LIBCORE_VSTYPE        = vstype
    ::LIBCORE_VSPPU         = vsppu
    ::LIBCORE_MISC          = misc
    ::LIBCORE_EXPANSION_NUM = expansion
    ::LIBCORE_PRGRAM        = prgram
    ::LIBCORE_EEPROM        = eeprom
    ::LIBCORE_CHRRAM        = chrram
    ::LIBCORE_CHRNVRAM      = chrnvram
    ::LIBCORE_EXTENDED_NUM  = extended

    ; THE STRAT IT AS FOLLOWS:
    ; VARIABLES FOR INDIVIDUAL DEFINES TO EVALUTE
    ; WE CAN THEN COMPARE TOKENS INDIVIDUALLY WITHOUT DEFINE REPLACE
    ; TODO: Do this for mappers

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


    .define LIBCORE_READONLY         
    .define LIBCORE_WRITEONLY                   PPUCTRL, PPUMASK, PPUSCROLL, OAMADDR, OAMDATA, OAMDMA, PPUADDR, PPUDATA
    .define LIBCORE_STRICT_READONLY             PPUSTAT, PPUSTATUS, IODATA, IODATA2, IODAT1, IODAT2
    .define LIBCORE_STRICT_WRITEONLY            PPUOPENBUS, IOSTROBE, FRAMECTRL
    .define LIBCORE_WRITEONLYSHADOWACCESS       
    .define LIBCORE_READONLYSHADOWACCESS

    .ifndef noshadow
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

    .if     .xmatch(LIBCORE_MAPPER, nrom) || .xmatch(LIBCORE_MAPPER, NROM)
        ; nrom
    .elseif .xmatch(LIBCORE_MAPPER, mmc1) || .xmatch(LIBCORE_MAPPER, MMC1)                              ; mmc1 uses shift register through writes to ROM
    .elseif .xmatch(LIBCORE_MAPPER, uxrom) || .xmatch(LIBCORE_MAPPER, UXROM)
        ; uxrom                              ; uxrom uses writes to ROM
    .elseif .xmatch(LIBCORE_MAPPER, cnrom) || .xmatch(LIBCORE_MAPPER, CNROM)
        ; cnrom                             ; cnrom uses writes to what normally is prgram area
    .elseif .xmatch(LIBCORE_MAPPER, mmc3) || .xmatch(LIBCORE_MAPPER, MMC3) || .xmatch(LIBCORE_MAPPER, mmc6) || .xmatch(LIBCORE_MAPPER, MMC6) || .xmatch(LIBCORE_MAPPER, txrom) || .xmatch(LIBCORE_MAPPER, TXROM)
        ; mmc3, mmc6, txrom
    .elseif .xmatch(LIBCORE_MAPPER, mmc5) || .xmatch(LIBCORE_MAPPER, MMC5) || .xmatch(LIBCORE_MAPPER, exrom) || .xmatch(LIBCORE_MAPPER, EXROM)
        ; mmc5, exrom
    .elseif .xmatch(LIBCORE_MAPPER, axrom) || .xmatch(LIBCORE_MAPPER, AXROM)
        ; axrom
    .elseif .xmatch(LIBCORE_MAPPER, mmc2) || .xmatch(LIBCORE_MAPPER, MMC2) || .xmatch(LIBCORE_MAPPER, pxrom) || .xmatch(LIBCORE_MAPPER, PXROM)
        ; mmc2, pxrom
    .elseif .xmatch(LIBCORE_MAPPER, mmc4) || .xmatch(LIBCORE_MAPPER, MMC4) || .xmatch(LIBCORE_MAPPER, fxrom) || .xmatch(LIBCORE_MAPPER, FXROM)
        ; mmc4, fxrom
    .elseif .xmatch(LIBCORE_MAPPER, cprom) || .xmatch(LIBCORE_MAPPER, CPROM)
        ; cprom
    .elseif .xmatch(LIBCORE_MAPPER, n163) || .xmatch(LIBCORE_MAPPER, N163)
        ; n163
    .elseif .xmatch(LIBCORE_MAPPER, vrc4) || .xmatch(LIBCORE_MAPPER, VRC4)
        ; vrc4
    .elseif .xmatch(LIBCORE_MAPPER, vrc6) || .xmatch(LIBCORE_MAPPER, VRC6)
        ; vrc6
    .elseif .xmatch(LIBCORE_MAPPER, bnrom) || .xmatch(LIBCORE_MAPPER, BNROM)
        ; bnrom
    .elseif .xmatch(LIBCORE_MAPPER, gxrom) || .xmatch(LIBCORE_MAPPER, GXROM)
        ; gxrom
    .elseif .xmatch(LIBCORE_MAPPER, fme7) || .xmatch(LIBCORE_MAPPER, FME7) || .xmatch(LIBCORE_MAPPER, s5b) || .xmatch(LIBCORE_MAPPER, S5B)
        ; fme7, s5b
    .elseif .xmatch(LIBCORE_MAPPER, vrc3) || .xmatch(LIBCORE_MAPPER, VRC3)
        ; vrc3
    .elseif .xmatch(LIBCORE_MAPPER, vrc1) || .xmatch(LIBCORE_MAPPER, VRC1)
        ; vrc1
    .elseif .xmatch(LIBCORE_MAPPER, vrc7) || .xmatch(LIBCORE_MAPPER, VRC7)
        ; vrc7
    .elseif .xmatch(LIBCORE_MAPPER, txsrom) || .xmatch(LIBCORE_MAPPER, TXSROM)
        ; txsrom
    .elseif .xmatch(LIBCORE_MAPPER, tqrom) || .xmatch(LIBCORE_MAPPER, TQROM)
        ; tqrom
    .elseif .xmatch(LIBCORE_MAPPER, cnromprot) || .xmatch(LIBCORE_MAPPER, CNROMPROT)
        ; cnromprot
    .elseif .xmatch(LIBCORE_MAPPER, dxrom) || .xmatch(LIBCORE_MAPPER, DXROM)
        ; dxrom
    .elseif .xmatch(LIBCORE_MAPPER, action52) || .xmatch(LIBCORE_MAPPER, ACTION52)
        ; action52
    .else
        .fatal
    .endif

    ; TODO: Based on Mapper, setup Mapper Defines
    ;       Enables warnings for certain regs
    __header_build prgrom, chrrom, mapper, system, altnt, trainer, battery, submapper, prgram, chrram, mirror, eeprom, cpu, vssystem, vsppu, extended, misc, expansion, chrnvram
.endmacro

.define is_prgram8000 (__mapper__) \
    (__mapper__ = 1)  || \ 
    (__mapper__ = 5)  || \ 
    (__mapper__ = 69)