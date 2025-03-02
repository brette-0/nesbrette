``synth``
---------

Synthetic instructions are macros comprised of instructions that perform a basic task to expand on the hardware immitating differeng instruction sets. The ``synth`` module houses them all, the only types they use are register indicator enums, they score well for size and speed across the board with little but strong utility.

It should also be noted that by using SMC (Self-Modifying Code) you can improve the speed of some opcodes by abusing the mutability of the operand to change 'directness'. This is useful for sophisticated raster code that may need to crunch operations within a delicate timeframe. It also can be used to enable indirectness where before not possible such as indirect without indexing and indirect Absolute indexed.

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   
   s6502
   i6502
   stack