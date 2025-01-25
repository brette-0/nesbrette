.define itype(__token__)\
  .ident(.string(.left(1, __token__)))

.define signed(__token__)\
  __token__ & (1 << 30)

.define eindex(__offset__, __width__, __index__, __endian__)\
  ((__offset__ + __index__) * (__endian__ < 1)) | ((__offset__ + __width__ - __index__ - 1) * (__endian__ > 0))

.define type(__token__)\
      (.xmatch(.left(1, __token__), u8)     * 1 ) \
    | (.xmatch(.left(1, __token__), u16)    * 2 ) \
    | (.xmatch(.left(1, __token__), u24)    * 3 ) \
    | (.xmatch(.left(1, __token__), u32)    * 4 ) \
    | (.xmatch(.left(1, __token__), u64)    * 8 ) \
    | (.xmatch(.left(1, __token__), bu8)    * ((1 << 29) + 1) ) \
    | (.xmatch(.left(1, __token__), bu16)   * ((1 << 29) + 2) ) \
    | (.xmatch(.left(1, __token__), bu24)   * ((1 << 29) + 3) ) \
    | (.xmatch(.left(1, __token__), bu32)   * ((1 << 29) + 4) ) \
    | (.xmatch(.left(1, __token__), bu64)   * ((1 << 29) + 8) ) \
    | (.xmatch(.left(1, __token__), i8)     * ((1 << 30) + 1) ) \
    | (.xmatch(.left(1, __token__), i16)    * ((1 << 30) + 2) ) \
    | (.xmatch(.left(1, __token__), i24)    * ((1 << 30) + 3) ) \
    | (.xmatch(.left(1, __token__), i32)    * ((1 << 30) + 4) ) \
    | (.xmatch(.left(1, __token__), i64)    * ((1 << 30) + 8) ) \
    | (.xmatch(.left(1, __token__), bi8)    * ((3 << 29) + 1) ) \
    | (.xmatch(.left(1, __token__), bi16)   * ((3 << 29) + 2) ) \
    | (.xmatch(.left(1, __token__), bi24)   * ((3 << 29) + 3) ) \
    | (.xmatch(.left(1, __token__), bi32)   * ((3 << 29) + 4) ) \
    | (.xmatch(.left(1, __token__), bi64)   * ((3 << 29) + 8) ) \
    | (.xmatch(.left(1, __token__), string) * -1) \
    | (.xmatch(.left(1, __token__), token)  * -2) \
    | (.xmatch(.left(1, __token__), x)      * -3) \
    | (.xmatch(.left(1, __token__), y)      * -4) \
    | (.xmatch(.left(1, __token__), acc)    * -5)

; d31 = Reserved for special case
; d30 = signed flag (for numbers)
; d29 = endian flag (for numbers)
; (d0-d11) value segment

.define typeval(__type__)\
  (__type__) & 0%11111111111


.define def(__label__, __typed_const__)\
  .ident(__label__) .set type __typed_const__ \
  typeas(__label__, .right(1, __typed_const__))

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
    | (.xmatch(.left(1, __token__), u16)    * 2 ) \
    | (.xmatch(.left(1, __token__), u24)    * 3 ) \
    | (.xmatch(.left(1, __token__), u32)    * 4 ) \
    | (.xmatch(.left(1, __token__), u64)    * 8 ) \
    | (.xmatch(.left(1, __token__), bu8)    * 1 ) \
    | (.xmatch(.left(1, __token__), bu16)   * 1 ) \
    | (.xmatch(.left(1, __token__), bu24)   * 1 ) \
    | (.xmatch(.left(1, __token__), bu32)   * 1 ) \
    | (.xmatch(.left(1, __token__), bu64)   * 1 ) \
    | (.xmatch(.left(1, __token__), i8)     * 1 ) \
    | (.xmatch(.left(1, __token__), i16)    * 1 ) \
    | (.xmatch(.left(1, __token__), i24)    * 1 ) \
    | (.xmatch(.left(1, __token__), i32)    * 1 ) \
    | (.xmatch(.left(1, __token__), i64)    * 1 ) \
    | (.xmatch(.left(1, __token__), bi8)    * 1 ) \
    | (.xmatch(.left(1, __token__), bi16)   * 1 ) \
    | (.xmatch(.left(1, __token__), bi24)   * 1 ) \
    | (.xmatch(.left(1, __token__), bi32)   * 1 ) \
    | (.xmatch(.left(1, __token__), bi64)   * 1 ) \
    | (.xmatch(.left(1, __token__), string) * 0) \
    | (.xmatch(.left(1, __token__), token)  * 0) \
    | (.xmatch(.left(1, __token__), x)      * 1) \
    | (.xmatch(.left(1, __token__), y)      * 1) \
    | (.xmatch(.left(1, __token__), acc)    * 1)

.define isconst(__token__)\
      (.xmatch(.left(1, __token__), u8)     * 1 ) \
    | (.xmatch(.left(1, __token__), u16)    * 2 ) \
    | (.xmatch(.left(1, __token__), u24)    * 3 ) \
    | (.xmatch(.left(1, __token__), u32)    * 4 ) \
    | (.xmatch(.left(1, __token__), u64)    * 8 ) \
    | (.xmatch(.left(1, __token__), bu8)    * 1 ) \
    | (.xmatch(.left(1, __token__), bu16)   * 1 ) \
    | (.xmatch(.left(1, __token__), bu24)   * 1 ) \
    | (.xmatch(.left(1, __token__), bu32)   * 1 ) \
    | (.xmatch(.left(1, __token__), bu64)   * 1 ) \
    | (.xmatch(.left(1, __token__), i8)     * 1 ) \
    | (.xmatch(.left(1, __token__), i16)    * 1 ) \
    | (.xmatch(.left(1, __token__), i24)    * 1 ) \
    | (.xmatch(.left(1, __token__), i32)    * 1 ) \
    | (.xmatch(.left(1, __token__), i64)    * 1 ) \
    | (.xmatch(.left(1, __token__), bi8)    * 1 ) \
    | (.xmatch(.left(1, __token__), bi16)   * 1 ) \
    | (.xmatch(.left(1, __token__), bi24)   * 1 ) \
    | (.xmatch(.left(1, __token__), bi32)   * 1 ) \
    | (.xmatch(.left(1, __token__), bi64)   * 1 ) \
    | (.xmatch(.left(1, __token__), string) * 1) \
    | (.xmatch(.left(1, __token__), token)  * 0) \
    | (.xmatch(.left(1, __token__), x)      * 0) \
    | (.xmatch(.left(1, __token__), y)      * 0) \
    | (.xmatch(.left(1, __token__), acc)    * 0)

.define endian(__type__)\
    __type__ & (1 << 29)


.macro detype __typed__, __type__
  .if .tcount(__typed__) > .tcount({0:0})
    .exitmacro  ; array
  .elseif .tcount(__typed__) = 1
    __type__ .set width __typed__
  .else
    __type__ .set type __typed__
    .if !__type__
      __type .set itype __typed__
    .endif
  .endif
.endmacro