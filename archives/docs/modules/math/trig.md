# `trig`
---
###### Advanced Math | `6502` | Any Hardware

Sine, Cosine, Tangent, Cotangent, Secant and Cosecant are the six trigonometric functions which can easily be obtained with `nesbrette`. By using the table maker to create either a Sine or Cosine table, the user can perform any of these six functions. 

It should be noted that only `sin` and `cos` can be used without implementing the division module, with the division module you can calculate `tan` with `sin` and `cos`, and `csc`, `sec` and `cot` with reciprocal math. In terms of performance here they are below:

1. `sin` or `cos`
2. `cos` or `sin`
3. `csc` or `sec`
4. `sec` or `csc`
5. `tan`
6. `cot`

Or, should you include **both** a Sine and a Cosine table, the first four macros will be equally performant to its pair. The reason why you can choose to have either Sine or Cosine be faster, is merely if you choose to include said table and rather allow the other side to be calculated from the fetch.

In truth, what actually happens is the index is modified by either `$40` or `$80` acting as either `pi/2r` or `3pi/2r` in a `256` degree circle.
