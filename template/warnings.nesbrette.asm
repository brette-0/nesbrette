; this is called when you call "div #imm" with a reciprocal table using elements with a width that is not a power of two - here it will use the multiplication registers to calculate the offset efficiently
; to suppress this, either disable the warning or refactor the table to use power of two element withds.
WARNINGS_MACRO_MMC5_DIV_EWPOT   = 1