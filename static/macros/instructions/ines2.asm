.scope ines2
    .enum CONTOLE_TYPES
        NES     = 0
        Famicom = 0
        VS      = 1
        PC10    = 2
        ECT     = 3
    .endenum

    .enum REGIONS
        NTSC    = 0
        PAL     = 1
        MULT    = 2
        DENDY   = 3
    .endenum

    .enum VSTYPE
        NORMAL  = 0
        BASEBALL= 1
        BOXING  = 2
        XEVIOUS = 3
        CLIMBER = 4
        DUAL_SYS= 5
        DUAL_RBB= 6
    .endenum

    .enum VSPPU
        RP2C03B      = 0
        RP2C03G      = 1
        RP2C004_0001 = 2
        RP2C004_0002 = 3
        RP2C004_0003 = 4
        RP2C004_0004 = 5
        RC2C03B      = 6
        RC2C03C      = 7
        RC2C05_01    = 8
        RC2C05_02    = 9
        RC2C05_03    = 10
        RC2C05_04    = 11
        RC2C05_05    = 12
    .endenum

    .enum ECTYPES
        NES     = 0
        FC      = 0
        FAMICOM = FC
        DENDY   = 0
        VS      = 1
        PC10    = 2
        DECMODE = 3
        EPSM    = 4
        VT01    = 5
        VT02    = 6
        VT03    = 7
        VT09    = 8
        VT32    = 9
        VT369   = 10
        UMC     = 11
        NETWORK = 12
    .endenum

    .enum EXPANSION_DEVICE
        Unspecified = $00
        DPAD        = $01
        FOUR_SCORE  = $02
        SATELLITE   = FOUR_SCORE
        FOURPLAYER  = $03
        VSS_4016    = $04
        VSS_4017    = $05
        VS_ZAPPER   = $07
        ZAPPER      = $08
        ZAPPERS     = $09
        LIGHTGUN    = $0a
        POWERPAD_A  = $0b
        POWERPAD_B  = $0c
        TRAINER_A   = $0d
        TRAINER_B   = $0e
        VAUS_NES    = $0f
        VAUS_FC     = $10
        VAUS_RECORD = $11
        HYPERSHOT   = $12
        PACHINKO    = $13
        BOXING_BAG  = $14
        MAHJONG     = $15
        PARTY_TAP   = $16
        OEKA_TABLET = $17
        SS_BARCODE  = $18
        PIANO_KB    = $19
        MOGURAA     = $1a
        TOP_RIDER   = $1b
        DOUBLE_FIST = $1c
        F3D_SYSTEM  = $1d
        DOREMIKKO   = $1e
        ROB_GRYO    = $1f
        DATA_RECORD = $20
        ASCII_TURBO = $21
        IGS_STORAGE = $22
        BASIC_KB    = $23
        DONGDA_KB   = $24
        BIT79_KB    = $25
        SUBOR_KB    = $26
        SUBOR_KVM3x8= $27
        SUBOR_KVM24b= $28
        SNES_MOUSE  = $29
        MULTICART   = $2a
        DUAL_SNES   = $2b
        RACERMATE   = $2c
        UFORCE      = $2d
        ROB_STACKUP = $2e
        CP_LIGHTGUN = $2f
        CASSETTE    = $30
        DPAD_INVERT = $31
        SUDOKU_PAD  = $32
        ABL_PINBALL = $33
        GNC_BUTTONS = $34
        MISC_KB     = $35
        SUBORKVM4017= $36
        PORT_TEST   = $37
        BANDI_MG    = $38
        DANCE_MAT   = $39
        LGTV_REMOTE = $3a
        NET_CONTROL = $3b
        FISHING     = $3c
        KAROAKE     = $3d
    .endenum
.endscope

.macro header
    .byte "NES", $1a
    .byte (PRG_ROM_AMT & $ff)
    .byte (CHR_ROM_AMT & $ff)
    .byte ((Mapper & $0f) << 4) | (ALT_NT << 3) | (Trainer << 2) | (Battery << 1) | Mirroring
    .byte ((Mapper & $f0) << 4) | $0c | CONSOLE_TYPE
    .byte ((Mapper & $f00) >> 8)| (Submapper << 4)
    .byte ((CHR_ROM_AMT & $f00) >> 4) | ((PRG_ROM_AMT & $f00) >> 8)
    .byte (PRGNVRAM << 4) | PRGRAM
    .byte (CHRNVRAM << 4) | CHRRAM
    .if CONSOLE_TYPE = ines2::CONSOLE_TYPES::VS
        .byte (HW_TYPE << 4) | VS_PPU_TYPE
    .elseif CONSOLE_TYPE = ines::CONSOLE_TYPES::ECT
        .byte ECTYPE
    .else
        .byte REGION
    .endif
    .byte MISC_ROM
    .byte EXPANSION_DEVICE
    .endmacro