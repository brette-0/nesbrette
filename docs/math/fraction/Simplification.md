***
Simplification here has a stretched meaning, normally it's expressing a fraction where the remainder and divisor share no multiples, *however*, there is a concatenation issue to delve into here. Summing two 8 bit divisors has the potential to require a 16bit divisor. In this situation, we need to shift out lesser detail in order to keep all fractional information usable in its confines.

### `FUNCTION_FLAGS`

- d0 - do not concern with simplification, handle externally.
- d1 - do not concatenate, fractional information will have more detail
	(not recommended for serial division)
	