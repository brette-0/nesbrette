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