.define type(__token__)\
      (.xmatch(.left(1, __token__), u8)     * 1 ) \
    | (.xmatch(.left(1, __token__), u16)    * 2 ) \
    | (.xmatch(.left(1, __token__), u24)    * 3 ) \
    | (.xmatch(.left(1, __token__), u32)    * 4 ) \
    | (.xmatch(.left(1, __token__), u64)    * 8 ) \
    | (.xmatch(.left(1, __token__), string) * -1) \
    | (.xmatch(.left(1, __token__), token)  * -2) \
    | (.xmatch(.left(1, __token__), x)      * -3) \
    | (.xmatch(.left(1, __token__), y)      * -4)
    ;| (.xmatch(.left(1, __token__), a)      * ?) \

.define label(__token__)\
    .string(.right(1, __token__))

.define peek(__token__)\
    .sprintf("%d", .ident(label __token__))
    
.define isnum(__token__)\
      (.xmatch(.left(1, __token__), u8)     * 1 ) \
    | (.xmatch(.left(1, __token__), u16)    * 1 ) \
    | (.xmatch(.left(1, __token__), u24)    * 1 ) \
    | (.xmatch(.left(1, __token__), u32)    * 1 ) \
    | (.xmatch(.left(1, __token__), u64)    * 1 ) \
    | (.xmatch(.left(1, __token__), x)      * 1) \
    | (.xmatch(.left(1, __token__), y)      * 1)
    ;| (.xmatch(.left(1, __token__), a)      * ?)

.define isconst(__token__)\
      (.xmatch(.left(1, __token__), u8)     * 1 ) \
    | (.xmatch(.left(1, __token__), u16)    * 1 ) \
    | (.xmatch(.left(1, __token__), u24)    * 1 ) \
    | (.xmatch(.left(1, __token__), u32)    * 1 ) \
    | (.xmatch(.left(1, __token__), u64)    * 1 ) \
    | (.xmatch(.left(1, __token__), string) * 1) \
    | (.xmatch(.left(1, __token__), token)  * 1) \
    | (.xmatch(.left(1, __token__), x)      * 0) \
    | (.xmatch(.left(1, __token__), y)      * 0)
    ;| (.xmatch(.left(1, __token__), a)      * ?)