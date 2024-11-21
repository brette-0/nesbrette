; global/header 

.enum 
    ; mappers
    header_mapper_nrom = 0
    header_mapper_mmc1 = 1
    header_mapper_uxrom = 2
    header_mapper_cnrom = 3
    header_mapper_mmc3 = 4
    header_mapper_mmc5 = 5
    header_mapper_axrom = 7
    header_mapper_mmc2 = 9
    header_mapper_mmc4 = 10
    header_mapper_color_dreams = 11
    header_mapper_cprom = 13
    header_mapper_vrc2 = 21 ; 22, 23, 25
    header_mapper_vrc4 = 21 ; 22, 23, 25
    header_mapper_vrc6 = 24 ; 26
    header_mapper_action53 = 28
    header_mapper_unrom512 = 30
    header_mapper_jycasic = 35; 90
    header_mapper_rambo = 64
    header_mapper_gxrom = 66
    header_mapper_fme7 = 69
    header_mapper_vrc3 = 73
    header_mapper_vrc1 = 75
    header_mapper_vrc7 = 85
    header_mapper_gtrom = 111
    header_mapper_tqrom = 119

    ; cpu timing
    header_timing_ntsc = 0
    header_timing_pal  = 1
    header_timing_multiple = 2
    header_timing_dendy = 3

    ; console type
    header_system_standard = 0
    header_system_vs       = 1
    header_system_playchoice = 2
    header_system_extended = 3

    ; console extended type
    header_system_extended_standard = 0
    header_system_extended_vs       = 1
    header_system_extended_playchoice = 2
    header_system_extended_standard_decimal = 3
    header_system_extended_standard_epsm = 4
    header_system_extended_standard_network = 12

    ; default expansion device
    header_expansion_none = 0
    header_expansion_controller = 1
    header_expansion_fourscore = 2
    header_expansion_fourplay = 3
    header_expansion_zapper = 8
    header_expansion_zappers = 9
    header_expansion_lightgun = $0a
    header_expansion_basicKB = $23
    header_expansion_suborKB = $26
    header_expansion_SuborKBM = $27
    header_expansion_SuborKBM24 = $28
    header_expansion_snesmouse = $29
    header_expansion_snescontroller = $2b
    header_expansion_con
.endenum

CONSTANTS_HEADER_MAPPER = header_mapper_nrom
CONSTANTS_HEADER_SUBMAPPER = 0      ; no submapper
CONSTANTS_HEADER_PRG_ROM_AMT = 1    ; 16kib
CONSTANTS_HEADER_CHR_ROM_AMT = 1    ; 8kib
CONSTANTS_HEADER_CPU_TIMING = header_timing_ntsc
CONSTANTS_HEADER_CONSOLE_TYPE = header_system_standard
CONSTANTS_HEADER_BATTERY = 0        ; no battery
CONSTANTS_HEADER_ALT_NT = 0         ; no alt NT
CONSTANTS_HEADER_TRAINER = 0        ; no trainer
CONSTANTS_HEADER_MISC_ROMS_AMT = 0  ; no misc roms
CONSTANTS_HEADER_VS_HW_TYPE = 0     ; type 0
CONSTANTS_HEADER_VS_PPU_TYPE = 0    ; type 0
CONSTANTS_HEADER_DEFAULT_EXPANSION_DEVICE = header_expansion_none
CONSTANTS_HEADER_EXTENDED_CONSOLE_TYPE = 0
CONSTANTS_HEADER_PRG_RAM_AMT = 0    ; no program RAM
CONSTANTS_HEADER_EEPROM_AMT = 0     ; no EEPROM
CONSTANTS_HEADER_CHR_RAM_AMT = 0    ; no character RAM
CONSTANTS_HEADER_CHR_NVRAM_AMT = 0  ; no non-volatile character RAM