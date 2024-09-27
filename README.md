# `nesbrette`
---
## Use of libraries

If it's been done once well then why write it yourself, I present the idea of the library, but NES Development has little room for libraries. `32KiB` of immediately accessible `PRGROM` (outside of `RNBW`) means each byte is precious. Projects should *not* include *entire* libraries for many reasons such as :
- similar label usage
- fixed behaviour
- included unused
- bank fetching

Simply put, both speed and size is *always* a concern - this is where `nesbrette` excels.
`nesbrette` is a highly configurable library, only including what you *need* and making functions inline where it matters. `nesbrette` processes write only to configured RAM areas, allowing processes to write to areas of memory to the concern of the developer.

`nesbrette` aligns tables (where possible) to pages in order to reduce read speeds, offering highly precise and detailed tables to perform more complex operations. These tables come with access functions and generation scripts from `json` files.  By encapsulating `nesbrette` includes in declared scopes some code can be copied in many banks to prevent `PRG` window issues.

Speed, Size, Configuration written with good practice, tidy code.