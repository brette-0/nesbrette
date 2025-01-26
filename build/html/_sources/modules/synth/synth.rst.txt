``synth``
---------

Synthetic instructions are macros comprised of instructions that perform a basic task to expand on the hardware immitating differeng instruction sets. The ``synth`` module houses them all, the only types they use are register indicator enums, they score well for size and speed across the board with little but strong utility.

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   
   s6502
   i6502
   stack
   gpr