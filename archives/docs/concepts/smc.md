# 'Self-Modifying Code' (SMC)
***
##### Benefits
- Modifable Operands
  - Fast Direct for all immediate instructions
  - Fast Non-Indexed Indirect for all direct instructions.
- Fast Variable-Width 'branchless' code
- Non-Linear Code-Flow

##### Constraints
- Requires 'generation' in RAM
- consumes RAM and ROM
- May require 'maintenance'
- Potential Volality (ACE Exploits)
- Cognitively Taxing to write

##### Safety Measures
- Automate the generation on boilerplate via library utilities
- Engineer optimal solutions to reduce ROM regardless of CPU time
- Macros to handle the calling and validation where appropriate.
- Use Write-Protect and store in System RAM to prevent banking (*not reccomended*)
- Translate a ROM solution into a RAM solution procedurally

##### Changing an operand
- non-indexed indirect addressing for all opcodes with direct addressing
- writing the immediate instruction operand, faster timed code.

##### Calling vWith Code
vWidth processes are pattern based unrolled iterable instructions, because of this we can identify the 'body' that iterates and decide it if 'ticks' down or up. Code that 'ticks down' must be jumped into decided by the desired width. This code *could* leak into code further in the sequence meaning we can use indirect jump, but if configured ahead of time we could use a fast indirect jump by modifying the operand of a direct jump, or jump to subroutine which means we need not worry about its position in memory.

For code that 'ticks up' we use a simpler method known as 'return injecting' in which an `rts` opcode overwrites the first instruction that would be out of the bounds of the desired width. This method is easier as the functions act like typical functions and can be called with a simple `jsr`. It should be noted that neither solution is equally suited to each vWidth problem SMC can optimise.