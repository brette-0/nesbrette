# Objective Syntax
***

## `idtable`
#### `laxi` - Load AX immediate
> Uses `idtable` to load an immediate value to both `a` and `x` simultaneously.
Note that while `lax #imm` does exist, it provides unstable results on hardware.
For this reason `laxi const` is the only reliable way to pull off this illegal behavior.

#### `tyx` - Transfer Y to X
> Uses `idtable` to `ldy idtable, x`

#### `txy` - Transfer X to Y
> Uses `idtable` to `ldx idtable, y`

#### `xmask` - Mask by X
> Masks `a` with value in `x`.  Different to `sax` which performs `addr = a & x`

#### `ymask` - Mask by y
> Masks `a` with value in `y`

#### `xset` - Set by X
> Sets bits of `a` with bits of `x`

#### `yset` - Set by Y
> Sets bits of `a` with bits of `y`

#### `xflip` - Flip by X
> Flips bits of `a` with bits of `x`

#### `yflip` - Flip by Y
> Flips bits of `a` with bits of `y`

#### `xcmp` - Compare to X
> Compares `a` to `x`

#### `ycmp` - Compare to Y
> Compares `a` to `y`

#### `xcpy` - Compare X to Y
> Compares `x` to `y`

#### `ycpx` - Compare Y to X
> Compares `y` to `x`

#### `acx` - Add X with carry
> Add `x` to `a` with carry

#### `acy` - Add Y with carry
> Add `y` to `a` with carry

#### `sbx` - Subtract X with Carry
> Sub `x` from `a` with carry

#### `sby` - Subtract Y with Carry
> Sub `y` from `a` with carry

#### `biti` - Bitcheck Immediate
> Bitwise checks `const arg`, could be used to quickly configure several registers.

#### `adx` - Increase X
> Transfers `x` to `a`, then masks `x` by `a`, then `x` decreases by negative of `const arg`. Arg must be less than 129.

#### `sdx` - Decrease X
> Transfers `x` to `a`, then masks `x` by `a`, then `x` decreases by `const arg`. Arg must be less than 128.

## Math

#### `add`
#### `sub`

## Bitwise
#### `lshift`
#### `rshift`
#### `lroll`
#### `rroll`

## Notes

- To perform an `lfsr` psuedo-random update call, use the instruction `sre` on your chosen address for as few as `5` cycles.