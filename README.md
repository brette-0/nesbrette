# `nesbrette`
---

## What does `nesbrette` do?
`nesbrette` is a swiss army knife of NES/Famicom routines, macros and tables to increase speed and quality of NES Homebrew/ROMHack development. `nesbrette` uses selective including to remove all redundant routine reducing; reducing output size. But it doesn't stop there, `nesbrette` also doesn't natively include tables for the functions, but rather a `python` script that will generate the information with a normalized filesystem with the outputs natively accessible to a `ca65 assembler`.

## Extent of quality
`nesbrette` prefers *always* to reduce CPU intensity with reasonable attentiveness to output size. Each routine has been profilled with a simulated cycle count for (where feasible) every possible configuration and array of arguements. Routines will have an allocated area in memory (configurable in a `defines` file) which may be used to house either the information passed as an arguement or a pointer to it. 

> When disabling `FUNCTION_MATH_USES_OPTR` for any routine, you must preserve the output in a new area of memory or else your programme will behave unexpectedly.

Routines that contain the suffix `ptr` refer to routines that use an `indirect` addressing method and therefore are *slower* than those that use `direct` addressing. If a routine ends `iptr` that means the inputs *only* are indirectly accessed, if the routine ends `optr` that means *only* the ouput is indirectly constructed, and if the function alias ends in `ioptr` then this is the *slowest* variant that *indirectly* handles all arguements.

