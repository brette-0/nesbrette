# GPR
***
###### Advanced Syntax | `6502` | Any Hardware

The 6502 provides three registers `A`, `X`, and `Y` for general purpose use. With these registers comes many instructions `lda`, `ldx`, `ldy`, `tax`, `tay` etc... and more often than not they are interchangeable in use. *However*, when writing optimal code we try to code with minimal 'value juggling' in order to reduce code time and size. While this can typically be done with some ease when solely working with code you have written, when using libraries the user may need to research the library - or realise the code debt they have built up instead.

The `GPR` instructions below use `enum` evaluation to create the necessary general purpose register interaction below. These functions exist to reduce the line count and to make the logic modular. These instructions are typically parameterised by the caller either through specified optional arguments or a default value sourced from the caller for the context.

| Mneumonic | Name                           | Performance | Purpose                                             |
| --------- | ------------------------------ | ----------- | --------------------------------------------------- |
| `inr`     | Increment Register             | `2c 1b`     | Increments the register specified.                  |
| `der`     | Decrement Register             | `2c 1b`     | Decrements the register specified.                  |
| `tar`     | Transfer A to Register         | `2c 1b`     | Transfers A to register specified.                  |
| `tyr`     | Transfer Y to Register         | `~3.5c ~2b` | Transfers Y to register specified.                  |
| `txr`     | Transfer X to Register         | `~3.5c ~2b` | Transfers X to register specified.                  |
| `tra`     | Transfer Register to A         | `2c 1b`     | Transfers specified register to A.                  |
| `try`     | Transfer Register to Y         | `~3.5c ~2b` | Transfers specified register to Y.                  |
| `trx`     | Transfer Register to X         | `~3.5c ~2b` | Transfers specified register to X.                  |
| `trr`     | Transfers Register to Register | `~2.1c ~1.3b` | Transfers specified register to specified register. |

> All `i6502` dependant synthetics use official `6502` instructions for legitimate operations, where not possible they use `i6502` solutions and *never* involve memory/stack.
