`Instruction Reference`
-----------------------


| Opcode  | Name                             | Speed   | Size   | Module                       |     |
| ------- | -------------------------------- | ------- | ------ | ---------------------------- | --- |
| `inr`   | Increment R                      | `2c`    | `1b`   | `libcore.gpr`                |     |
| `der`   | Decrement R                      | `2c`    | `2b`   | `libcore.gpr`                |     |
| `tar`   | Transfer A to R                  | `2c`    | `1b`   | `libcore.gpr`                |     |
| `txr`   | Transfer X to R                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  |     |
| `txy`   | Transfer Y to R                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  |     |
| `tra`   | Transfer R to A                  | `2c`    | `1b`   | `libcore.gpr`                |     |
| `trx`   | Transfer R to X                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  |     |
| `try`   | Transfer R to Y                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  |     |
| `trr`   | Transfer R to R                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  |     |
| `ldr`   | Load R with Mode                 | `2-~6c` | `2-3b` | `libcore.gpr`                |     |
| `str`   | Store R with Mode                | `2-~6c` | `2-3b` | `libcore.gpr`                |     |
| `cpr`   | Compare R with Mode              | `2-~6c` | `2-3b` | `libcore.gpr`                |     |
| `cmpr`  | Compare A with R                 |         |        | `libcore.gpr` `synth.i6502`  |     |
| `cmpy`  | Compare A with Y                 |         |        | `synth.i502`                 |     |
| `cmpx`  | Compare A with X                 |         |        | `synth.i6502`                |     |
| `sasl`  | Signed Arithmetic Shift Left (A) |         |        | `synth.s6502`                |     |
| `sasl`  | Signed Logical Shift Right (Mem) |         |        | `synth.s6502`                |     |
| `slsr`  | Signed Logical Shift Right       |         |        | `synth.s6502`                |     |
| `neg`   | Negative                         |         |        | `synth.s6502`                |     |
| `ccf`   | Complement Carry                 |         |        | `synth.s6502`                |     |
| `iror`  | Inner Roll Right                 |         |        | `synth.s6502`                |     |
| `irol`  | Inner Roll Left                  |         |        | `synth.s6502`                |     |
| `labs`  | Load Always Absolute A           |         | `3b`   | `synth.s6502`                |     |
| `lybs`  | Load Always Absolute X           |         | `3b`   | `synth.s6502`                |     |
| `lxbs`  | Load Always Absolute Y           |         | `3b`   | `synth.s6502`                |     |
| `laxbs` | Load Always Absolute AX          |         | `3b`   | `synth.s6502`                |     |
| `lrbs`  | Load Always Absolute R           |         | `3b`   | `synth.s6502x` `libcore.gpr` |     |
| `sabs`  | Store Always Absolute A          |         |        | `synth.s6502`                |     |
| `sxbs`  | Store Always Absolute X          |         |        | `synth.s6502`                |     |
| `sybs`  | Store Always Absolute Y          |         |        | `synth.s6502`                |     |
| `srbs`  | Store Always Absolute R          |         |        | `synth.s6502` `libcore.gpr`  |     |
| `adx`   | Add X with Carry                 |         | `3b`   | `synth.i6502`                |     |
| `ady`   | Add Y with Carry                 |         | `3b`   | `synth.i6502`                |     |
| `adr`   | Add R with Carry                 |         | `3b`   | `synth.i6502`                |     |
| `sbx`   | Subtract X with Carry            |         | `3b`   | `synth.i6502`                |     |
| `sby`   | Subtract Y with Carry            |         | `3b`   | `synth.i6502`                |     |
| `sbr`   | Subtract R with Carry            |         | `3b`   | `synth.i6502` `libcore.gpr`  |     |
| `anx`   | Bitmask X                        |         | `3b`   | `synth.i6502`                |     |
| `any`   | Bitmask Y                        |         | `3b`   | `synth.i6502`                |     |
| `anr`   | Bitmask R                        |         | `3b`   | `synth.i6502` `libcore.gpr`  |     |
| `orx`   | Bitset X                         |         | `3b`   | `synth.i6502`                |     |
| `ory`   | Bitset Y                         |         | `3b`   | `synth.i6502`                |     |
| `orr`   | Bitset Regiter                   |         | `3b`   | `synth.i6502` `libcore.gpr`  |     |
| `eox`   | Bitflip X                        |         | `3b`   | `synth.i6502`                |     |
| `eoy`   | Bitflip Y                        |         | `3b`   | `synth.i6502`                |     |
| `xor`   | Bitflip R                        |         | `3b`   | `synth.i6502` `libcore.gpr`  |     |
| `cmpx`  | Compare A, X                     |         | `3b`   | `synth.i6502`                |     |
| `cmpy`  | Compare A, y                     |         | `3b`   | `synth.i6502`                |     |
| `cpr`   | Compare by R by R                |         | `3b`   | `libcore.gpr` `synth.i6502`  |     |
| `tyxa`  | Transfer Y to X \| A             |         |        | `synth.i6502x`               |     |
| `biti`  | Bitcheck Constant                |         |        | `synth.i6502`                |     |
| `bib`   | Bitcheck Branch                  |         |        | `synth.s6502`                |     |
| `sev`   | Set Overflow                     |         |        | `synth.i6502`                |     |
| `lds`   | Load Stack                       |         | `3b`   | `synth.stack`                |     |
| `sts`   | Store Stack                      |         |        | `synth.stack`                |     |
| `cps`   | Compare Stack                    |         |        | `synth.stack`                |     |
| `ldz`   | Load Zero                        |         | `2b`   | `mem.flush`                  |     |
| `stz`   | Store Zero                       |         |        | `mem.flush`                  |     |
| `add`   | Add                              |         |        | `math.addition`              |     |
| `sub`   | Subtract                         |         |        | `math.addition`              |     |
| `cmult` | Constant Multiply                |         |        | `math.cmult`                 |     |
| `mult`  | Multiply                         |         |        | `math.mult`                  |     |
| `cdiv`  | Constant Divise                  |         |        | `math.cdiv`                  |     |
| `div`   | Divide                           |         |        | `math.div`                   |     |
| `sin`   | SineOf                           |         |        | `math.trig`                  |     |
| `cos`   | CosineOf                         |         |        | `math.trig`                  |     |
| `tan`   | TangentOf                        |         |        | `math.trig`                  |     |
| `asin`  | ArcsineOf                        |         |        | `math.trig`                  |     |
| `acos`  | ArcosineOf                       |         |        | `math.trig`                  |     |
| `atan`  | ArcTangentOf                     |         |        | `math.trig`                  |     |
| `sct`   | SecantOf                         |         |        | `math.trig`                  |     |
| `cot`   | CotangentOf                      |         |        | `math.trig`                  |     |
| `csc`   | CosecantOf                       |         |        | `math.trig`                  |     |
| `asct`  | AsecantOf                        |         |        | `math.trig`                  |     |
| `acot`  | ArcotangentOf                    |         |        | `math.trig`                  |     |
| `acsc`  | ArcosecantOf                     |         |        | `math.trig`                  |     |
| `mssb`  | Most Significant Set Bit         |         |        | `mem.mlussb`                 |     |
| `msub`  | Most Significant Unset Bit       |         |        | `mem.mlussb`                 |     |
| `lssb`  | Least Significant Set Bit        |         |        | `mem.mlussb`                 |     |
| `lsub`  | Least Significant Unset Bit      |         |        | `mem.mlussb`                 |     |
| `sex`   | Sign extend                      |         |        | `libcore.typing`             |     |
Uncertain of when to include:

| Opcode | Name                         | Purpose | Speed | Size           | Hardware |
| ------ | ---------------------------- | ------- | ----- | -------------- | -------- |
| `ans`  | Add with Carry by Stack      |         |       |                |          |
| `sbs`  | Subtract with Carry by Stack |         |       |                |          |
| `ans`  | Bitmask by Stack             |         |       |                |          |
| `ors`  | Bitset by Stack              |         |       |                |          |
| `eos`  | Bitflip by Stack             |         |       |                |          |
| `lss`  | Left Shift Stack             |         |       |                |          |
| `rss`  | Right Shift Stack            |         |       |                |          |
| `rrs`  | Right Roll Stack             |         |       |                |          |
| `rls`  | Left Roll Stack              |         |       |                |          |
| `des`  | Decrement Stack              |         |       |                |          |
| `ins`  | Increment Stack              |         |       |                |          |
| `jmx`  | Jump Complex                 |         |       |                |          |
| `laxi` | Load AX Immediate            |         |       | `synth.i6502x` |          |
|        |                              |         |       |                |          |
|        |                              |         |       |                |          |
|        |                              |         |       |                |          |
|        |                              |         |       |                |          |
|        |                              |         |       |                |          |

