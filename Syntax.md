***

### Standard [`ca65`]()
```
lda #$00		; immediate (imm)
lda $00			; Zero Page (zp)
lda $1234		; Absolute (abs)
lda $00, x		; Zero Page Indexed X (zpx)
lda $00, y		; Zero page Indexed Y (zpy)
lda $1234, x	; Absolute X (abx)
lda $1234, y			; Absolute Y (aby)
lda [$00, x]			; Indexed Indirect (inx)
lda [$00], y			; Indexed Indirect (iny)
jmp ($1234)				; Indirect (ind)
```
> `nesbrette` does not acknowledge `ins (foo, x)`, `ins (foo), y` or `ins (foo)` as valid indirect instructions and therefore the overloads *should not* be expected to satisfy it. Please instead use `ins [foo, x]`, `ins [foo], y` or `ins [foo]` for indirectness. 

### Integrated [`ca65hl`]()
```
lda foo[x]				; Zero Page / Absolute X (zpx / abx)
lda foo[y]				; Zero Page / Absolute Y (zpy / aby)

if (foo)				; conditional
	bar
endif

repeat					; do while
	foo
	bar
until (ash = fir)

while (foo : bar < ash)
	fir
	cob
endwhile				; C style while loops

for (foo, bar, ash)
	fir
	cob
next

switch foo				; switch case

	case bar
		ash
		break

	case fir
	case cob
		jar
		break

	case default
		bun
endswitch
```

> `nesbrette` may often make you pass features into a macro. In order to make this work with `ca65hl` you will *need* to pass your conditional headers inside curly braces to prevent `ca65` from treating your code as an erroneous array full of syntax errors.
### The library `nesbrette`
```
ins !foo				; perform erroneous action
ins ##foo				; access location at first ram mirror
ld r, foo				; load register with value
st r, foo				; compare register with value
cp r, foo				; store register to location
in r					; increment register
de r					; decrement register
ta r					; transfer a to register
tx r					; transfer x to register
ty r					; transfer y to register
t r, r					; transfer register to register

ins r					; instruction with register
bit #imm				; bit check immediate
jsr [ind]				; indirect call

ins u2: foo			; type cast
ins +foo, -bar			; declare signature determinism
```

> The syntax grammar is seen above, but the added instructions, functions and programming practices ***required*** to use `nesbrette` can be found in [the docs]().