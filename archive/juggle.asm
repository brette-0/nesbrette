.macro __juggle  __tokens__, __widths__, __polarity__, __temp__, __$recurse__
    ; engine call 

    memcpy index(__$recurse__, __tokens__), __temp__, .left(1, .mid(__$recurse__, 1, __widths__))

    .if .tcount(__tokens__) > 1
        __juggle __tokens__, __widths__, __polarity__, __temp__, __$recurse__ + 1
        .endif

    .endmacro
    

.macro juggle __tokens__, __widths__, __polarity__, __temp__
    ; engine internal
    .local __$recurse__
    
    __$recurse__ = 0

    memcpy    index(0, __tokens__), __temp__, index(0, __widths__)  ; alpha => temp
    __juggle __tokens__, __widths__, __polarity__, __temp__, __$recurse__ + 1
    memcpy   __temp__, index(.tcount(__tokens__) - 1, __tokens__), index(.tcount(__widths__) - 1, __tokens__)   ; temp => zeta

    .endmacro


; juggle {offset1, offset2, offset3}, {width1, width2, width3}, __polarity__, __temp__

/*

    offset1 offset2 offset3 temp

*/