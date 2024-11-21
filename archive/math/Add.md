***
###### *How deep could addition get?*

# `add`

```
add inline unrolled noptr u24
```

When performing addition in `nesbrette`, you **must** call it through the `macro` in order to maintain defined behaviour. The complexity of the `add` `macro` is not transferred into operation, it is merely a convenient way to parameterise simple addition. The `add` macro takes the following arguments:
- `inline` 
- `noptr` / `iptr` / `optr` / `ioptr`
- `u16` / `u32` / `u64`
- `big`

An `inline` call will re-include the assembly, please note that this is not the intended means to reduce bankswitching - instead we suggest simply scoping your includes for each bank. A call should only be `inline` where speed takes incredible priority over all other facets. Please note that excessive use of `inline` calls may incur wasted cycled through cross-page accesses.

Use of `noptr` will ensure that all reads/writes are fetched with `absolute` addressing, please note that using `zp` addresses *are* supported and do offer a speed bonus, but incur an overflow risk if width parameter is passed erroneously potentially leading to software breaking results.

Use of `iptr` will ensure all reads are fetched using `indirect indexed`, whereas all writes are performed using `absolute`. Use of `optr` will ensure all reads are fetched using `absolute` but all writes will use `indirect indexed`. Use of `ioptr` will ensure all reads and writes use `indirect indexed`.

When width is left unspecified, the macro will call a "get width" function that fetches the either constant or variable width before leaking into the main addition process. Please note that the function itself is *always* V-Width, simply the 'default' width can be changed if set to an address in place of a constant.

Use of `big` will enable "big endian" mode, in order to track index changes when scaling each byte. It should be noted that this introduces a new complexity in which optimisation freaks will need to concern themselves over. `inline big` operations will perform a logical compare each time unless `unroll` is set, this differs from non-`inline` calls in which if a `bitwidth` is specified - that bit will be specified *before* call and written to `ADDRESSES_ADD_WIDTH`.  All in all, little endian is faster and smaller.
# `add_vptr_retarget_out`

`add_vpr_retarget_out add_vptr player_score`

This function accepts a target where the `add_noptr` is stored in `RAM` and the target address to write to the `output` bytes in said `SMC` stored `add_noptr` procedure.

# `add_vptr_retarget_mod`

`add_vpr_retarget_out add_vptr time_left`

This function accepts a target where the `add_noptr` is stored in `RAM` and the target address to write to the `adder` bytes in said `SMC` stored `add_noptr` procedure.

- Do not modify `nesbrette` addresses if stored in `SMC` before calling `SMC` modification macros.
- Do not attempt to use `vptr` behaviour if target resembles an `unrolled` process.
- Ensure the target `RAM` address is `__add_noptr_body`. (see [here]())
