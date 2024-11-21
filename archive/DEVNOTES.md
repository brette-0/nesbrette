***

#### `alpha-1728504682`
> I've implemented the untested `add` and `sub` functions as macros. The choice for this is to remove the manual calling which will look clean, reduce the amount of visible call instructions in the editor and help with learning a new library.
> 
> The macro is recursive, and in `ca65` that's not a clean thing to do : the way `ca65` allows a dynamic quantity of arguments to a macro is due to "unfolding" the "defined" macro until all arguments have been "shifted".
> 
> Since there is no guarantee that the user will align each optional argument they use with where it *could* be interpreted (defeating the purpose of our non-assembled *inline* recursion) we can only interpret the value's as isolated `bytecode`.
> 
> Said `bytecode` is defined with an `enum` which unfortunately will always have global precedence. This means these key-phrases we use but be a universal standard throughout all features that could benefit from this word. (research max `ca65` `int` length/ OS dependency?)
> 
> **Here's where things get a little hairy**
> 
> For each optional argument exists a 'default case' for when an 'optional override' is not present or impossible. This 'default case' may be constant if `CONSTANTS_MATH_ADD_WIDTH` is defined. We simply cannot assume that all games that *could* benefit from our library within requirement or preference would perform *enough* V-Width calculations to warrant fetching it from ROM.
> 
> However if disabled, the macro will attempt to load the address specified at `ADDRESSES_MATH_ADD_WIDTH` which *must* be defined even if each case of `add` specified width. This is because the source file that contains the addition body also contains a header called `__add_xxptr_fetch_width` which will not check if library addresses are defined.
> 
> **Talk about the calling**
> 
> During the 'calling phase' of the macro, we check the value of `inline` and `bitwidth` which are determined from the `inline` `enum` or specifying `u16`, `u24`, `u32`, `u64` etc..
> (shift flag args before size reads and change logic to reflect - allows greater sizes than `u64`)
> 
> If `bitwidth` is specified then we skip 'default case' for operation width by overwriting the general purpose register prior to calling. Please note that function abide scoped lexis and thus stale labels will yield problematic results - it is unwise to store multiple entries of `nesbrette` within the same root lexical node due to context pathfinding and table fragmentation.
> 
> If `inline` is specified then the body will be included after width has either been specified or accessed via 'default case' - since `inline` won't be defined during the include phase within a child of lexical root node or the lexical root node itself the entire function would be included *if specified*
> 
> `inline` removes the calling process, that's *literally* it - if an `inline` needs to use `absolute` addressing for *whatever* reason then the `absolute` argument can be used (only when `inline`).
> Moreover, use of `CONFIG_MODULES_MATH_FORCE_ABSOLUTE` can make the input use a mirror of all RAM addresses should target's happen to lie in `ZP`.
> 
> The reasoning behind 'force absolute' is to allow *faster* `ioptr` functionality with use of `SMC`. *Naturally* `SMC` is `RAM` expensive and the `ROM` stored copy goes unused so it ends up being a 'waste' of `ROM`. By calling `inject_add adder_ptr` with the pointer of the 'adder', you can modify what *address* is supplied to the 'output'. Adding a pointer change for the output seemed excessive, good practice can negate a need for that.
> 
> **No Endian Site**
> 
> If you wish to use something other than `little endian` on the NES, then by modifying `CONFIG_MODULES_MATH_BIG_ENDIAN` to equal `1` or by specifying `big` as an optional argument the math can change which digit it treats as higher value in sequence. (`little endian` is faster by `2o(N)` cycles)
> 
> Note that arguments *always* override global configuration.
> 
> **Let's just Unroll**
> 
> I am not excited for this one. *Unrolling loops* - it's limited to fixed width mad and takes up more `ROM` granted it's significantly beneficial on `CPU`. I'm not *wholly* against this but it's questionable use in relationship to the conundrum "How extensive is math here, should I refactor instead". Regardless, it comes in `included` and `inline` and I would not *bother* using this for `vptr` or `ioptr`. Utility? Little.
> 
> **`ioptr` vs `vptr` vs `noptr`**
> 
> `noptr` is no pointers used, just *direct* memory access. `vptr` is `SMC` on copied out `noptr` benefiting from `ioptr`'s versatility with `noptr`'s speed at the cost of significant `RAM` consumption. `ioptr` uses `indirect indexed` memory address mode and therefore is incredibly slow but can perform math from anywhere in CPU to another space in CPU without re-inclusion being necessary.
> 
> **All for an add function?**
> 
> Yes, but it's an `add` function that can detect/decide if accesses are pointers, their size (type), if they are `inline` or not, if they should be speed benefited by being `unrolled` and what `endian` they use. Furthermore it adds safety measures for `SMC` reach with possible security for `RAM` code alignment? (perchance?)
> 
> All in all were it shipped with `cc65` they would feel the urge to re-include the `inline` keyword.
> 
> **Variable Width Safety**
> 
> If you preserve the original width, reduce the width you can safely reduce wasted cycles if you are sure the `adder` will be thinner than the potential output. Misuse of V-Width could lead into overflows, if used alongside with `vptr` functions you earn yourself an `ACE` vulnerability. 
> To specify detailed `bitwidth` perform `(u64 + u32)` , don't specify them both with `u64, u32` or you will hit an error!


#### `alpha-`1728616905
> **idtable/rtable use**
> Adding use of 'idtables' unlocked a variety of new macro's with low speed. Such as `neg` which effectively completes `reg = -reg` with some limitations and other less useful things such as `iisc` which uses `vptr` method to get `indirect` addressing for `isc` the illegal instruction completing `inc` followed by `sbc`. 
> 
> The sheer idea of someone creating a `vptr` function for something like `iisc` is amusing considering the cost of branching and returning. These features will be scrapped as long as I can think of a rule that decides they are inappropriate. *However*, if a system depended on *requests* to modify memory *then* these *could* be useful. But that's a very specific condition I highly doubt will be fulfilled.
> 
> I decide that `phx` and `phy` will not get support for these reasons :
> - Good nesdevers can go without
> - `stx` and `sty` both have `zp` Addressing modes.
> - Stack is precious.
> - `zp` is precious
> - if `zp` isn't used, `a` is clobbered despite the 'opcodes' stating `x` and `y`.
>   
>  But I happily added `tyx` and `txy` as it's just absolute indexed. Is it slower than transferring between general purpose registers and `a`? Yes, but it's no faster or smaller to pass through `a` first and is certainly faster than storing `zp` and fetching. Simply put, a better programmer than I may *somehow* avoid wanting to shift values between general purpose registers but I have found myself in too many a case where it has been useful.
>  
>  None of the bitwise operations need be explained, `sax` completes the job of `xmask` but requires a write target - if the value need not be preserved simply using `sax zp` with a wasted temp address is sufficient.
>  
>  `laxi` must be used over `lax #imm` because `lax #imm` is undefined, while emulators may yield the developer intended result - this is a hardware inaccuracy, different `2a03` models yield different results in varying degrees of chaos but consistent in it's erroneous.