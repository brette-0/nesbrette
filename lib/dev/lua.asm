/*

    THIS LIBRARY SHOULD BE USED ALONGSIDE "nesbrette/lua/mesen.lua" OR IT WILL DO NOTHING MORE THAN SLOW DOWN YOUR CODE

*/

.macro lua __type__ 
    .byte $0c           ; nop abs (16bit arg)


.endmacro