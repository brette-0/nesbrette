# `nesbrette`
---
The Nintendo Entertainment System is a historic console, it's 'aesthetic' used as the prototype of modern 'pixel games' and it's memorable shell used to captivate an archaic world of gaming. While most video game players have moved on many times to successor consoles, the NES/Famicom isn't friendless. With the development of Flashcarts and Emulators, a dedicated community of enthusiasts who have taken the console apart to work it like it has never been worked before.

When you write for a console like the NES, you write as for few other consoles. The NES' design demands the developer become aware with of it's hardware to a personal level. With this familiarity, many great things within the NES development world has been born - similarly, some used modern hardware as a means to super-enable the NES beyond its typical capacity.

However most of the great things within the world of NESDev do not come from modifying the console, apart from enabling expansion audio on non-Japanese systems or enabling writing on the Famicom Disk System (FDS), most of the world of improvements comes from software.

#### Famistudio

Famistudio is a both a DAW composing tool desgined for many OS', it's also an audio driver supporting exports from the DAW to use with the main three NES assembly languages. Famistudio supports (as of writing this) Sunsoft 5B, VRC6, VRC7, Namco 163, MMC5, FDS and EPSM. EPSM is a special thing, as it's not a *real* NES audio chip but rather an external chip which uses an unused expansion slot on the NES. The 'EPSM' chip has been produced by a small company known as Muramasa Entertainment - their stocks typically drained quickly due to how sought after this chip is. 

#### *Libraries?*

The NES has libraries like any other programmable hardware does, although you might speculate that much of it is copyrighted or lost to time. The LibUltra microcode for the Nintendo 64 was concern enough when used in James Lambert's faithful recreation of the Valve game 'Portal' for the Nintendo 64 so much that Vale themselves forbid James to continue development. Unfortunately the damage had been done so migrating to LibDragon (the open source equivalent) was not an option.

The NES has libraries, `neslib` being the most common of all. But libraries are an interesting thing in this context. With C, you might include a library with the preprocessor and increase the amount of dynamically linked libraries associated with your binary, or you might statically compile creating a larger output but each equally executable on your modern hardware.

The NES does not, by default, come with an Operating System and therefore may only have it's games statically compiled or statically assembled. Due to this, inclusion of libraries comes a dramatic cost on Program ROM. When developing in C, libraries are crucial for providing elementary functionality in order to maintain C-like standard lexis when programming.

#### So what does `nesbrette` do better?

`nesbrette` does not include anything left unused, any table or procedure will demand to be included via a separate configuration. Should it be that said element is missing, `nesbrette` validation will provide you a detailed exception describing the asset you need, and where in docs you can find more information.

`nesbrette` uses cleverly designed macros to handle calling logic, deciding then and there if an `inline` solution is more optimal with optional overrides as macro parameters with pre-designed enums for ease of use. `nesbrette` uses an immense amount of lexical hierarchy manipulation and preprocessor features to ensure no truly wasted cycles are produced.

`nesbrette` has it's own table generation code configurable by JSON file which is then processed by a Python script, the script allows total configuration of the table value's such as what banks they enter, their name's (with defaults) as well as the amount of items, the width of each items and any optional optimisations.

`nesbrette` documents everything, every feature implemented is configured by default at your ease - but should an issue arise, or you wish to squeeze every drop of optimisation from the library the documentations will describe the limitations, capacity and speediest route out. In fact, some features have optional tables designed to speed up the code at cost of more Program ROM.

`nesbrette` has `types`, `null` and over `50` `synthetic` `instructions` that allow for code to be concise while remaining performant. `nesbrette` practically has it's own syntax attempting to scrape even more from higher level languages than `ca65` could offer alone. `nesbrette` doesn't expose `procedure` bodies to be called, but allows all call handling to be performed with extensive `macro` and `define` logic to crunch every optimisation.
#### How do I use it?

`nesbrette` is currently in metamorphosis and isn't ready for use.