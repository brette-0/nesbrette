# `nesbrette`
---

#### Libraries for the NES

Unlike modern hardware, games of the time couldn't be dynamically linked due to the nature of hardware. Because games had to be statically compiled the less libraries used the smaller the output would be and conditionally cheaper. At any rate it serves no purpose to waste time or resources on features that will not be used, equally it serves no purpose to re-design that which isn't unique. Thus the function of a library is to contain useful information to reliably assist development. The easist way to approach this is to simply include a big file full of all the usable code.

*Unfortunately that simply isn't good enough.*

While it takes *alot* of time to devise, a truly technical library can meet incrediblie standards if put together with inspiration. ``nesbrette`` prefers to use macros and therefore leans to being incredibly small, a complement alongside the main goal of being of unimprovable speed while maintaining a classy, tidy syntax. ``nesbrette`` uses an automatic include system that ensures safe inclusion of depenencies confined to scope and reports this information during assemble time for developer debugging.

Furthermore, ``nesbrette`` uses a custom '`include`' and `'includefrom`' keywords that uses 'module names' instead of filepaths for ease of use. ``nesbrette`` is designed for the experienced `6502` developer and comes with technical documentation that describes the error cases, parameter requirements, speed formulas, size formulas and performance metrics where applicable. ``nesbrette`` is not affiliated with its depenancies but does promote them as software.

``nesbrette`` is not just a QOL library with some well written code, it's inventive with it's comprehensive and clever header creation macro, variable typing, register parameterisation, preprocessor optimised macros, overloading, macro call handlers and abundance of synthetic instructions that perform tasks from the well-known to typically unthought abiding the safety precautions researched from reputable sites that document the ``6502``.

To begin:
```
.include "../../lib/core/include.asm"

__libroot__ "../../lib"
global:

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom


reset:
    lda #$00
    sta PPUCTRL
    sta PPUMASK

loop:
    jmp loop

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000


.out .sprintf("Completed Build Task with %d additional dependancies", ::dependancies)
```