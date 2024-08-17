***
The `ines2` module allows easy configuration of an `ines` header, normally you will include this once at the top of the programme, you may do it like so:
```
.include "static/macros/includes.asm"		; selective internal macro inclusion
.include "static/macros/macros.asm"	    	; include core macro engine



ines2_include_header
```

This macro can be accessed by including `static/macros/instructions/ines2`.
To configure your header, you may wish to make your own config file