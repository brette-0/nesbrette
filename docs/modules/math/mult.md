# `vptr::mult`
***

The fastest way to perform multiplication on the NES for longer values is to store the function in RAM, then you insert returns at certain points in the code, removing the logic behind all vwidth elements. 

The way we carefully handled SMC for this.


#### 1a. RAM-Code 'Generation'
This process is a register width limited approach to generating the code in RAM with the intention of writing the smallest 'generation code' to yield the result. This is handled in a macro called `__mult__init` which is called by the main `mult` macro.

> Page aligned memory use allows for simpler, shorter & faster generation.

**Or**

#### 1b. ROM=>RAM 'Copy-Out'
This process is not register width bound, slightly faster but takes up an incredible amount of space scaling with the `MAX_WIDTH` constant that predefines the data to copy.

#### 2. Return Insertion
Now we need to 'fetch' the opcode of the first iterated instruction within each called modular 'subprocess' immediately and store at the last inserted return, inserting a new return based on the function of target the return inserter is inserting returns into.

#### 3. Call Function
The function should now be called, all vWidth logic handled by the macro at the start. 


### Bottlenecks
Generating code that uses relative branches limits the size of the output within those confines, meaning that code may need to 'invert' the logic sub-optimally to yield a result within the confines the signed byte operand.