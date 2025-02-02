`Instruction Reference`
-----------------------


| Opcode  | Name                            | Purpose                                                                         | Speed      | Size      | Module                      |
| ------- | ------------------------------- | ------------------------------------------------------------------------------- | ---------- | --------- | --------------------------- |
| `inr`   | Increment Register              | Increments specified Register                                                   | `2` cycles | `2` bytes | `libcore.gpr`               |
| `der`   | Decrement Register              | Decrements specified Register                                                   |            |           | `libcore.gpr`               |
| `tar`   | Transfer A to Register          | Transfers A to Specified Register                                               |            |           | `libcore.gpr`               |
| `txr`   | Transfer X to Register          | Transfers X to Specified Register                                               |            |           | `libcore.gpr`               |
| `txy`   | Transfer Y to Register          | Transfers Y to Specified Register                                               |            |           | `libcore.gpr`               |
| `tra`   | Transfer Register to A          | Transfers specified Register to A                                               |            |           | `libcore.gpr`               |
| `trx`   | Transfer Register to X          | Transfers specified Register to X                                               |            |           | `libcore.gpr`               |
| `try`   | Transfer Register to Y          | Transfers specified Register to Y                                               |            |           | `libcore.gpr`               |
| `trr`   | Transfer Register to Register   | Transfers Specified Register to Specified Register                              |            |           | `libcore.gpr`               |
| `ldr`   | Load Register with Mode         | Load specified Register with specific memory address mode.                      |            |           | `libcore.gpr`               |
| `str`   | Store Register with Mode        | Load specified memory with specific memory address mode and specified Register. |            |           | `libcore.gpr`               |
| `sbr`   | Subtract Register with Carry    | Subtract with Carry by Specified Register                                       |            |           | `libcore.gpr` `synth.i6502` |
| `orr`   | Bitset by Register              | Bitmask by Specified Register                                                   |            |           | `libcore.gpr` `synth.i6502` |
| `anr`   | Bitmask by Register             | Bitset by Specified Register                                                    |            |           | `libcore.gpr` `synth.i6502` |
| `xor`   | Bitflip by Register             | Bitflip by Specified Register                                                   |            |           | `libcore.gpr` `synth.i6502` |
| `cpr`   | Compare by Register by Register | Compare Specified Register by Specified Register                                |            |           | `libcore.gpr`               |
| `sasl`  | Signed Arithmetic Shift Left    | Shift Left and preserve signature                                               |            |           | `synth.s6502`               |
| `slsr`  | Signed Logical Shift Right      | Shift Right and preserve signature                                              |            |           | `synth.s6502`               |
| `neg`   | Negative                        | Flips the Accumulators positivity.                                              |            |           | `synth.s6502`               |
| `ccf`   | Complement Carry                | Flips Carry.                                                                    |            |           | `synth.s6502`               |
| `iror`  | Inner Roll Right                | Roll bits right, disregarding Carry.                                            |            |           | `synth.s6502`               |
| `irol`  | Inner Roll Left                 | Roll bits left, disregarding Carry.                                             |            |           | `synth.s6502`               |
| `labs`  | Load Always Absolute A          | Load A from RAM Mirror                                                          |            |           | `synth.s6502`               |
| `lybs`  | Load Always Absolute X          | Load X from RAM Mirror                                                          |            |           | `synth.s6502`               |
| `lxbs`  | Load Always Absolute Y          | Load Y from RAM Mirror                                                          |            |           | `synth.s6502`               |
| `laxbs` | Load Always Absolute AX         | Load AX from RAM Mirror                                                         |            |           | `synth.s6502`               |
| `lrbs`  | Load Always Absolute Register   | Load Specified Register from RAM Mirror                                         |            |           | `synth.s6502x`              |
| `sabs`  | Store Always Absolute A         | Store A into RAM Mirror                                                         |            |           | `synth.s6502`               |
| `sxbs`  | Store Always Absolute X         | Store X into RAM Mirror                                                         |            |           | `synth.s6502`               |
| `sybs`  | Store Always Absolute Y         | Store Y into RAM Mirror                                                         |            |           | `synth.s6502`               |
| `srbs`  | Store Always Absolute Register  | Store Specified Register into RAM Mirror                                        |            |           | `synth.s6502`               |
| `adx`   | Add X with Carry                |                                                                                 |            |           | `synth.i6502`               |
| `ady`   | Add Y with Carry                |                                                                                 |            |           | `synth.i6502`               |
| `adr`   | Add Register with Carry         |                                                                                 |            |           | `synth.i6502`               |
| `sbx`   | Subtract X with Carry           |                                                                                 |            |           | `synth.i6502`               |
| `sby`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `sbr`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `anx`   | Bitmask X                       |                                                                                 |            |           | `synth.i6502`               |
| `any`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `anx`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `anr`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `orx`   | Bitset X                        |                                                                                 |            |           | `synth.i6502`               |
| `ory`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `orr`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `eox`   | Bitflip X                       |                                                                                 |            |           | `synth.i6502`               |
| `eoy`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `xor`   |                                 |                                                                                 |            |           | `synth.i6502`               |
| `cmpx`  | Compare A, X                    |                                                                                 |            |           | `synth.i6502`               |
| `cmpy`  | Compare A, y                    |                                                                                 |            |           | `synth.i6502`               |
| `xcpy`  | Compare X, Y                    |                                                                                 |            |           | `synth.i6502`               |
| `ycpx`  | Compare Y, X                    |                                                                                 |            |           | `synth.i6502`               |
| `laxi`  | Load A \| X \| Y                |                                                                                 |            |           | `synth.i6502x`              |
| `tyxa`  | Transfer Y to X \| A            |                                                                                 |            |           | `synth.i6502x`              |
| `biti`  | Bitcheck Constant               |                                                                                 |            |           | `synth.i6502`               |
| `sev`   | Set Overflow                    |                                                                                 |            |           | `synth.i6502`               |
| `lds`   | Load Stack                      |                                                                                 |            |           | `synth.stack`               |
| `sts`   | Store Stack                     |                                                                                 |            |           | `synth.stack`               |
| `cps`   | Compare Stack                   |                                                                                 |            |           | `synth.stack`               |
| `ldz`   | Load Zero                       |                                                                                 |            |           | `mem.flush`                 |
| `stz`   | Store Zero                      |                                                                                 |            |           | `mem.flush`                 |
| `add`   | Add                             |                                                                                 |            |           | `math.addition`             |
| `sub`   | Subtract                        |                                                                                 |            |           | `math.addition`             |
| `cmult` | Constant Multiply               |                                                                                 |            |           | `math.cmult`                |
| `mult`  | Multiply                        |                                                                                 |            |           | `math.mult`                 |
| `cdiv`  | Constant Divise                 |                                                                                 |            |           | `math.cdiv`                 |
| `div`   | Divise                          |                                                                                 |            |           | `math.div`                  |
| `sin`   | SineOf                          |                                                                                 |            |           | `math.trig`                 |
| `cos`   | CosineOf                        |                                                                                 |            |           | `math.trig`                 |
| `tan`   | TangentOf                       |                                                                                 |            |           | `math.trig`                 |
| `asin`  | ArcsineOf                       |                                                                                 |            |           | `math.trig`                 |
| `acos`  | ArcosineOf                      |                                                                                 |            |           | `math.trig`                 |
| `atan`  | ArcTangentOf                    |                                                                                 |            |           | `math.trig`                 |
| `sct`   | SecantOf                        |                                                                                 |            |           | `math.trig`                 |
| `cot`   | CotangentOf                     |                                                                                 |            |           | `math.trig`                 |
| `csc`   | CosecantOf                      |                                                                                 |            |           | `math.trig`                 |
| `asct`  | AsecantOf                       |                                                                                 |            |           | `math.trig`                 |
| `acot`  | ArcotangentOf                   |                                                                                 |            |           | `math.trig`                 |
| `acsc`  | ArcosecantOf                    |                                                                                 |            |           | `math.trig`                 |
| `mssb`  | Most Significant Set Bit        |                                                                                 |            |           | `mem.mlussb`                |
| `msub`  | Most Significant Unset Bit      |                                                                                 |            |           | `mem.mlussb`                |
| `lssb`  | Least Significant Set Bit       |                                                                                 |            |           | `mem.mlussb`                |
| `lsub`  | Least Significant Unset Bit     |                                                                                 |            |           | `mem.mlussb`                |
Scrapped Instructions:

| Opcode | Name                         | Purpose | Speed | Size | Hardware |
| ------ | ---------------------------- | ------- | ----- | ---- | -------- |
| `ans`  | Add with Carry by Stack      |         |       |      |          |
| `sbs`  | Subtract with Carry by Stack |         |       |      |          |
| `ans`  | Bitmask by Stack             |         |       |      |          |
| `ors`  | Bitset by Stack              |         |       |      |          |
| `eos`  | Bitflip by Stack             |         |       |      |          |
| `lss`  | Left Shift Stack             |         |       |      |          |
| `rss`  | Right Shift Stack            |         |       |      |          |
| `rrs`  | Right Roll Stack             |         |       |      |          |
| `rls`  | Left Roll Stack              |         |       |      |          |
| `des`  | Decrement Stack              |         |       |      |          |
| `ins`  | Increment Stack              |         |       |      |          |
|        |                              |         |       |      |          |
|        |                              |         |       |      |          |
|        |                              |         |       |      |          |
|        |                              |         |       |      |          |
|        |                              |         |       |      |          |
|        |                              |         |       |      |          |
|        |                              |         |       |      |          |
|        |                              |         |       |      |          |

