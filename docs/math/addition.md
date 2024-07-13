# `math::addition`
---

## Usage
All operations should be passed in the endianness selected, failure to do so will create corruptions when applying carry. Routines by default do not initialise params, cleaning params *will* always take longer and *should **never*** be done in CPU intensive environments *unless* an initialised output is **required**.

> After completion, carry will describe the result of adding the final (and largest) byte.

## Performance:
| Mode   | Big Endian | Little Endian | +Initialization |
|--------|------------|---------------|-----------------|
| Direct | 18W + 10   | 20W + 12      | 10W + 6         |
| iptr   | 19W + 10   | 21W + 12      | 10W + 6         |
| optr   | 19W + 10   | 21W + 12      | 11W + 14        |
| ioptr  | 21W + 10   | 23W + 12      | 11W + 14        |

> - `W` = Width, set by `FUNCTION_MATH_ADDITION_WIDTH`
> - These speeds are for page alligned code, where all values are stored in zero page where effective.

## Size:
| Mode   | Big Endian | Little Endian | +Initialization | +Absolute |
|--------|------------|---------------|-----------------|-----------|
| Direct | 12 bytes   | 15 bytes      | 9 bytes         | 4 bytes   |
| iptr   | 13 bytes   | 16 bytes      | 9 bytes         | 3 bytes   |
| optr   | 13 bytes   | 16 bytes      | 15 bytes        | 4 bytes   |
| ioptr  | 13 bytes   | 16 bytes      | 15 bytes        | 2 bytes   |

> Note that for obvious reasons this table will not be completely accurate for all situations.
>

Otherfunctions in the namespace:
- `math::addition::addition_iptr`
- `math::addition::addition_optr`
- `math::addition::addition_ioptr`
- `math::addition::subtraction`
- `math::addition::subtraction_iptr`
- `math::addition::subtraction_optr`
- `math::addition::subtraction_ioptr`
- `math::addition::multiplication_8`
- `math::addition::multiplication_16`
- `math::addition::multiplication`