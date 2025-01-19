.define istyped(__token__)\
  !.xmatch(.left(1, __token__), .right(1, __token__))

.define itype(__token__)\
  .ident(.string(.left(1, __token__)))

.define signed(__token__)\
  __token__ & (1 << 30)

.define type(__token__)\
      (.xmatch(.left(1, __token__), u8)     * 1 ) \
    | (.xmatch(.left(1, __token__), u16)    * 2 ) \
    | (.xmatch(.left(1, __token__), u24)    * 3 ) \
    | (.xmatch(.left(1, __token__), u32)    * 4 ) \
    | (.xmatch(.left(1, __token__), u64)    * 8 ) \
    | (.xmatch(.left(1, __token__), i8)     * ((1 << 30) + 1) ) \
    | (.xmatch(.left(1, __token__), i16)    * ((1 << 30) + 2) ) \
    | (.xmatch(.left(1, __token__), i24)    * ((1 << 30) + 3) ) \
    | (.xmatch(.left(1, __token__), i32)    * ((1 << 30) + 4) ) \
    | (.xmatch(.left(1, __token__), i64)    * ((1 << 30) + 8) ) \
    | (.xmatch(.left(1, __token__), string) * -1) \
    | (.xmatch(.left(1, __token__), token)  * -2) \
    | (.xmatch(.left(1, __token__), x)      * -3) \
    | (.xmatch(.left(1, __token__), y)      * -4) \
    | (.xmatch(.left(1, __token__), acc)    * -5)
    ;| (.xmatch(.left(1, __token__), a)      * ?) \

; d31 = Reserved for special case
; d12 = signed flag (for numbers)
; (d0-d11) value segment

.define typeas(__label__, __type__)\
  .ident(.sprintf("w_%s", .string(__label__))) .set type __type__

.define label(__token__)\
  .string(.right(1, __token__))

.define ilabel(__token__)\
  .ident(label __token__)

; consider removal
.define peek(__token__)\
  .sprintf("%d", .ident(label __token__))

.define width(__token__)\
  .ident(.concat("w_", label __token__))
    
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


.macro detype __typed__, __type__
  .if istyped __typed__
      __type__ .set type __typed__
      .if !__type__
          __type__ .set itype __typed__
      .endif
  .else
      __type__ .set width __typed__
  .endif
.endmacro