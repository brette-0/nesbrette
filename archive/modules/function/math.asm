.ifndef INCLUDED_TABLES
    .warning "Page unalligned Tables add extra cycles, consider including tables.asm first!"
.endif

.if EXCLUDE_MULTIPLY = 0
    .include "./math/multiply.asm"
.endif

.if (MAPPER = 5) .and (.not EXCLUDE_DIVIDE_8)
    .include "./math/divide_8.asm"
.endif