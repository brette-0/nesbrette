.macro callback __addr__
    lda #>__addr__
    pha
    lda #<__addr__
    pha
.endmacro