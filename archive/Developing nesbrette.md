***

```
; comments above functions with explanation, functions always use directives
.proc header
	; describe params here, register pipelines etc...

	rts
	.endproc	; endproc always ends with rts

; comments all lower case, starting on tab align, first character after space

; global values to be defined CATEGORY_SUBCATEGORY_SUBCATEGORY_DESCRIPTOR
; local values to be defined at legible developer discretion

; all rudimentary functions to be paired with macro
; all arguementitive function macros to use recursive arguement polling
; maximum utility provided for all tools
; zero clutter tolerance
; optimised for speed above size, unless configured otherwise (arguments)
```

On a commit, the developer is requested to describe the purpose behind their choices and describe the process of developing, sharing notes if possible.

Modules (or executable code) should be stored in `nesbrete/modules/` under a module name. Creating a module is acceptable but if contents are low may be offloaded into an existing module.

Routines should always belong to an appropriate module, square rooting - for example - belongs in the `math` module due to it's inherent mathematical utility.

Modification of the `nesbrette` engine : include management, definition management etc... will undergo a heavy evaluation process - it is less preferable that these are interacted with without communication with the `nesbrette` owners.

Tests must be conducted in the form
```
Tested Object Name - Passing/Failed/Underperforming/Depreciated

Cycle Count Formula:
 Byte Count Formula:

Optimisations:
	Circumstancial
	Toggleable
	Size vs speed

Big O

Related Code

Visualisations:
```

### Rules

- All code must function completely on authentic hardware. Use of
	- Expansion Audio Mod
	- Expansion Device
	- Controller Feature
	Does not count as inauthentic hardware. All `ECT` specific modules *must* depend on an `ECT` constant value using the `iNES2` module.
- Code cannot be designed in a way that condones bad practice
- Code must be as configurable as *beneficially* possible
- No code configuration may include unintentionally wasted cycles or bytes.
- All constants to be provided an Alias
- Code must target `2a03-6502x-ca65`


#### Code style


```
.if bool
	; body
	.endif

.if
	; large
	; body
.endif
; same for macro

.proc function_name

	local = GLOBAL_NAME		; use local aliases for clarity
	sta local				; lowercase opcodes
	sta local + 3, x		; spaces between operators
	
	.endproc				; priority shift earns tab
	;leak
.proc __notcalled
	pha
		lda #$20
		sta $2000			; stack wrapped code earns tab
	pla
	rts
	.endproc

CATEGORY_SUBCAT_SUBCAT_GLOBAL_NAME	; globals to be capitalized
; comments to be a tab away from last character, lower case + space

; nesbrette uses cstyle comments, forced range, underline in numbers
```