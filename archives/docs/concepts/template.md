# Templates
***

###### What are they?
Template in `nesbrette` are folders containing the following files in the following order:
```
constants.asm       ; declares constants for non-variable operations
addresses.asm       ; declares ram address for variables
tables.asm          ; declares the tables for functions
includes.asm        ; declares what scripts to include
```

> The reason it is done in this order is so that addresses may change depending on constant values and script lengths doesn't displace tables opening them up to a page overlap.

Templates are stored in any folder as long their relative position is described with `nesbrette::point(path)`.
They are used to control what scopes store what functions and data, this may useful if certain functions are only required by a certain bank of code.

In order to open up ROM writing library methods, call `nesbrette::open(path)` to include a `nesbrette` Template in the current scope. 

> In order to use `nesbrette::open` ensure that you first execute `nesbrette::lib` pointing to a valid `nesbrette` library root. 