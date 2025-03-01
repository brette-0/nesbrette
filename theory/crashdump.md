# `libdev::crash`

Crash Dumps are modules that dump a bunch of text information onto the screen when a fatal error occurs, these are typically caused by an interrupt. They are not found in commercial NES Games, but homebrew games *may* choose to use them in debug builds. They are much less useful than an active debugger or live lua scripting but serve a basic purpose.

That was until I touched them, here are the 'todo' features to make this work the best:
```
- Use of Midline 
- Use of DMC IRQ to 'Squash all text'
- IRQ EVERY SCANLINE
    - Switch Views
    - Scroll for Squashed Text
    - Highlight areas that need highlighting

- Use of Input to smoothly scroll a 'CPU Viewer'
    - Must not be able to trigger Read-Registers
    - Must not attempt to interact with Open Bus
    - D-Pad to Navigate
    - A = Access
    - B = Cancel
    - IN ACCESS MODE:
        
        - Up = Increment Low Nybble
        - Down = Decrement Low Nybble
        - Left = Increment High Nybble
        - Right = Decrement High Nybble

        - Select - Toggle Write Protect

    - Select + Start (Held for 3 Seconds) - Exit Crash Dump
    - Start - Call Reset Vector
- CPU Viewer
    
    - ZP            Bright Green
    - Stack         
        - Left SP   Green
        - SP        Yellow
        - After SP  Red
    - OAMDMA RAM    Purple
    - System RAM
    - Mirrors (Shaded)
    - PPU Read Regs (greyed out if no shadow reg present)
    - PPU Writes Regs
    - PPU RW Regs (greyed out if no shadow reg present)
    - APU Read Regs (greyed out if no shadow reg present)
    - APU Writes Regs
    - APU RW Regs (greyed out if no shadow reg present)
    - Open Bus (greyed out)
    - 
```