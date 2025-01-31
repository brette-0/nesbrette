> Warnings acting like Fatal or Error on user specification (like a Pedantic Mode)
> Warnings for (memory + width) page overlaps (likely intentional, *however* if not; potentially catastrophic)
> Warning Disabled / Pedantic Warnings as arguments for macros (more useful than it sounds)
> Auto-Dependency system (Don't specify includes, use features to activate includes?)
>   Note : if library becomes expansive, users could loose track of PRG/CPU from recklessly adding features




## Engine

### `FALLBACK`

> `FALLBACK` is the Engine module to solve Fatal Errors, this should be done in *few* cases. A `FALLBACK` will always be mathematically inaccurate or of poor logic/method relative to the macro's desired 'meaningful case'


### `PEDANTIC`
> `PEDANTIC` is the Engine module that will treat warnings as fatals, disregarding `FALLBACK` entirely. `PEDANTIC` is enabled per script/macro that has an *option* for it. 


## Modules

### `MATH`

#### `CDIV`
> `cdiv` found at `math/cdiv.asm` is constant division. Should have an A and an address mode.


#### `mult`
> `mult` found at `math/mult.asm` is a callable V-Width multiplication function supporting a variety of address modes. Values passed are treated as `byte[]` and fine or fractional values must be transposed accordingly.

#### `div`
> `div` found at `math/div.asm` is a callable V-Width division function supporting a variety of address modes. Values passed are treated as `byte[]` and fine or fractional values must be transposed accordingly.

#### `FRACTION`

#### type `frac`
> Certain macros will have an optional type parameter, if handed `frac` then the data will be read as `frac` 

```cpp
struct frac {
	quotient;
	remainder;
}
```

> It is expected that the reference to the `divisor` is remembered in implementation.

- Addition Function
- Subtraction Function
- Multiplication Function 
- Division Function
