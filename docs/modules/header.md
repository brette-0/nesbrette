# `modules::header`
---
###### Hardware Manipulation | `6502` | NES Only
In NESDev, a header is either eight or sixteen bytes describing the cartridge hardware through a series of flags and encoded numbers. The Header is crucial for all emulators, solutions outside of headers may use a hashing solution and a stored database. *However*, for typical functionality a Header is always required.

In order to create a header with `nesbrette`, ensure that:

- Your entrypoint sourcefile has a `includes.nesbrette.asm` file
- Your `nesbrette` include script has `header` enabled.
- Your entrypoint sourcefile has a `constants.nesbrette.asm` file
- Your `nesbrette` constants scripts is configured to match your needs

Then before you include a single assemblable byte, perform
```
insert_header
```

Ideal usage of the `header` module would look like this:
```
.include "engine/global/includes.asm"
.include "code/boot/constants_nesbrette.asm"

insert_header

; include other scripts
```