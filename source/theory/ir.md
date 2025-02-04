`Instruction Reference`
-----------------------


| Opcode  | Name                             | Speed   | Size   | Module                       | Use        |
| ------- | -------------------------------- | ------- | ------ | ---------------------------- | ---------- |
| `inr`   | Increment R                      | `2c`    | `1b`   | `libcore.gpr`                | Engine     |
| `der`   | Decrement R                      | `2c`    | `2b`   | `libcore.gpr`                | Engine     |
| `tar`   | Transfer A to R                  | `2c`    | `1b`   | `libcore.gpr`                | Engine     |
| `txr`   | Transfer X to R                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  | Engine     |
| `txy`   | Transfer Y to R                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  | Engine     |
| `tra`   | Transfer R to A                  | `2c`    | `1b`   | `libcore.gpr`                | Engine     |
| `trx`   | Transfer R to X                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  | Engine     |
| `try`   | Transfer R to Y                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  | Engine     |
| `trr`   | Transfer R to R                  | `2-~4c` | `1-3b` | `libcore.gpr` `synth.i6502`  | Engine     |
| `ldr`   | Load R with Mode                 | `2-~6c` | `2-3b` | `libcore.gpr`                | Engine     |
| `str`   | Store R with Mode                | `2-~6c` | `2-3b` | `libcore.gpr`                | Engine     |
| `cpr`   | Compare R with Mode              | `2-~6c` | `2-3b` | `libcore.gpr`                | Engine     |
| `cmpr`  | Compare A with R                 |         |        | `libcore.gpr` `synth.i6502`  | Engine     |
| `cmpy`  | Compare A with Y                 |         |        | `synth.i502`                 | Speed      |
| `cmpx`  | Compare A with X                 |         |        | `synth.i6502`                | Speed      |
| `sasl`  | Signed Arithmetic Shift Left (A) |         |        | `synth.s6502`                | Uncommon   |
| `sasl`  | Signed Logical Shift Right (Mem) |         |        | `synth.s6502`                | Uncommon   |
| `slsr`  | Signed Logical Shift Right       |         |        | `synth.s6502`                | Uncommon   |
| `slsr`  | Signed Logical Shift Right (Mem) |         |        | `synth.s6502`                | Uncommon   |
| `neg`   | Negative                         |         |        | `synth.s6502`                | Uncommon   |
| `ccf`   | Complement Carry                 |         |        | `synth.s6502`                | Uncommon   |
| `iror`  | Inner Roll Right                 |         |        | `synth.s6502`                | Uncommon   |
| `irol`  | Inner Roll Left                  |         |        | `synth.s6502`                | Uncommon   |
| `labs`  | Load Always Absolute A           |         | `3b`   | `synth.s6502`                | Deprecate? |
| `lybs`  | Load Always Absolute X           |         | `3b`   | `synth.s6502`                | Deprecate? |
| `lxbs`  | Load Always Absolute Y           |         | `3b`   | `synth.s6502`                | Deprecate? |
| `laxbs` | Load Always Absolute AX          |         | `3b`   | `synth.s6502`                | Deprecate? |
| `lrbs`  | Load Always Absolute R           |         | `3b`   | `synth.s6502x` `libcore.gpr` | Deprecate? |
| `sabs`  | Store Always Absolute A          |         |        | `synth.s6502`                | Deprecate? |
| `sxbs`  | Store Always Absolute X          |         |        | `synth.s6502`                | Deprecate? |
| `sybs`  | Store Always Absolute Y          |         |        | `synth.s6502`                | Deprecate? |
| `srbs`  | Store Always Absolute R          |         |        | `synth.s6502` `libcore.gpr`  | Deprecate? |
| `adx`   | Add X with Carry                 |         | `3b`   | `synth.i6502`                | Fair       |
| `ady`   | Add Y with Carry                 |         | `3b`   | `synth.i6502`                | Fair       |
| `adr`   | Add R with Carry                 |         | `3b`   | `synth.i6502`                | Engine     |
| `sbx`   | Subtract X with Carry            |         | `3b`   | `synth.i6502`                | Fair       |
| `sby`   | Subtract Y with Carry            |         | `3b`   | `synth.i6502`                | Fair       |
| `sbr`   | Subtract R with Carry            |         | `3b`   | `synth.i6502` `libcore.gpr`  | Engine     |
| `anx`   | Bitmask X                        |         | `3b`   | `synth.i6502`                | Fair       |
| `any`   | Bitmask Y                        |         | `3b`   | `synth.i6502`                | Fair       |
| `anr`   | Bitmask R                        |         | `3b`   | `synth.i6502` `libcore.gpr`  | Engine     |
| `orx`   | Bitset X                         |         | `3b`   | `synth.i6502`                | Fair       |
| `ory`   | Bitset Y                         |         | `3b`   | `synth.i6502`                | Fair       |
| `orr`   | Bitset Regiter                   |         | `3b`   | `synth.i6502` `libcore.gpr`  | Engine     |
| `eox`   | Bitflip X                        |         | `3b`   | `synth.i6502`                | Fair       |
| `eoy`   | Bitflip Y                        |         | `3b`   | `synth.i6502`                | Fair       |
| `xor`   | Bitflip R                        |         | `3b`   | `synth.i6502` `libcore.gpr`  | Engine     |
| `cmpx`  | Compare A, X                     |         | `3b`   | `synth.i6502`                | Fair       |
| `cmpy`  | Compare A, y                     |         | `3b`   | `synth.i6502`                | Fair       |
| `cpr`   | Compare by R by R                |         | `3b`   | `libcore.gpr` `synth.i6502`  | Engine     |
| `tyxa`  | Transfer Y to X \| A             |         |        | `synth.i6502x`               | Uncommon   |
| `biti`  | Bitcheck Constant                |         |        | `synth.i6502`                | Uncommon   |
| `bib`   | Bitcheck Branch                  |         |        | `synth.s6502`                | Uncommon   |
| `sev`   | Set Overflow                     |         |        | `synth.i6502`                | Uncommon   |
| `lds`   | Load Stack                       |         | `3b`   | `synth.stack`                | Speed      |
| `sts`   | Store Stack                      |         |        | `synth.stack`                | Speed      |
| `cps`   | Compare Stack                    |         |        | `synth.stack`                | Uncommon   |
| `ldz`   | Load Zero                        |         | `2b`   | `mem.flush`                  | Shortcut   |
| `sin`   | SineOf                           |         |        | `math.trig`                  | Fixed      |
| `cos`   | CosineOf                         |         |        | `math.trig`                  | Fixed      |
| `tan`   | TangentOf                        |         |        | `math.trig`                  | Fixed      |
| `asin`  | ArcsineOf                        |         |        | `math.trig`                  | Fixed      |
| `acos`  | ArcosineOf                       |         |        | `math.trig`                  | Fixed      |
| `atan`  | ArcTangentOf                     |         |        | `math.trig`                  | Fixed      |
| `sct`   | SecantOf                         |         |        | `math.trig`                  | Fixed      |
| `cot`   | CotangentOf                      |         |        | `math.trig`                  | Fixed      |
| `csc`   | CosecantOf                       |         |        | `math.trig`                  | Fixed      |
| `asct`  | AsecantOf                        |         |        | `math.trig`                  | Fixed      |
| `acot`  | ArcotangentOf                    |         |        | `math.trig`                  | Fixed      |
| `acsc`  | ArcosecantOf                     |         |        | `math.trig`                  | Fixed      |
| `mssb`  | Most Significant Set Bit         |         |        | `mem.mlussb`                 | Fixed      |
| `msub`  | Most Significant Unset Bit       |         |        | `mem.mlussb`                 | Fixed      |
| `lssb`  | Least Significant Set Bit        |         |        | `mem.mlussb`                 | Fixed      |
| `lsub`  | Least Significant Unset Bit      |         |        | `mem.mlussb`                 | Fixed      |
| `sex`   | Sign extend                      |         |        | `libcore.typing`             | Uncommon   |
Uncertain of if/when to include:

| Opcode | Name                         | Purpose | Speed | Size           |                |
| ------ | ---------------------------- | ------- | ----- | -------------- | -------------- |
| `ads`  | Add with Carry by Stack      |         |       |                | No Use Case    |
| `sbs`  | Subtract with Carry by Stack |         |       |                | No Use Case    |
| `ans`  | Bitmask by Stack             |         |       |                | No Use Case    |
| `ors`  | Bitset by Stack              |         |       |                | No Use Case    |
| `eos`  | Bitflip by Stack             |         |       |                | No Use Case    |
| `lss`  | Left Shift Stack             |         |       |                | No Use Case    |
| `rss`  | Right Shift Stack            |         |       |                | No Use Case    |
| `rrs`  | Right Roll Stack             |         |       |                | No Use Case    |
| `rls`  | Left Roll Stack              |         |       |                | No Use Case    |
| `des`  | Decrement Stack              |         |       |                | No Use Case    |
| `ins`  | Increment Stack              |         |       |                | No Use Case    |
| `jmx`  | Jump Complex                 |         |       |                | Weird Use Case |
| `laxi` | Load AX Immediate            |         |       | `synth.i6502x` | Nothing New    |
|        |                              |         |       |                |                |
|        |                              |         |       |                |                |
|        |                              |         |       |                |                |
|        |                              |         |       |                |                |
|        |                              |         |       |                |                |

