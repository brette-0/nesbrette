.define itype(__token__)\
  (.ident(.string(.left(1, __token__))))

.define signed(__token__)\
  (__token__ & (1 << 30))

.define eindex(__offset__, __width__, __index__, __endian__)\
  ((__offset__ + __index__) * (0 = __endian__)) | ((__offset__ + __width__ - __index__ - 1) * (0 <> __endian__))

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
    | (.xmatch(.left(1, __token__), r)      * -3)


typectx = (3 << 29)
; d31 = Reserved for special case
; d30 = signed flag (for numbers)
; d29 = endian flag (for numbers)
; (d0-d11) value segment

.define typeval(__type__)\
  ((__type__ >= 0) * (__type__ & ~typectx)) | ((__type__ < 0) * null)

.define typeas(__label__, __type__)\
  .ident(.sprintf("t_%s", .string(__label__))) .set type __type__

.define __label(__token__)\
  .string(.right(1, __token__))

.define dedtype(__token__)\
  .ident(.concat("t_", __label __token__))

.define endian(__type__)\
  (__type__ & (1 << 29))


.macro detype __typed__, __type__
  .if .tcount(__typed__) > .tcount({0:0})
    .exitmacro  ; array
  .elseif .tcount(__typed__) = 1
    __type__ .set (dedtype __typed__)
  .else
    __type__ .set type __typed__
    .if !__type__
      __type__ .set .left(1, __typed__)
    .endif
  .endif
.endmacro

.define null_coalesce(n, c) ((n = null) * c) | ((n <> null) * n)

.macro null_coalset n, c
  n .set null_coalesce n, c
.endmacro

.define is_null(n) (n = null)

.macro filter_types __ctx__, __filter__, __msg__
  .local pass

  pass .set 0
  
  .repeat .tcount(__filter__), iter
    .if ctx <> (index __filter__, iter)
      pass .set 1 
    .endif
  .endrepeat
  
  .if !pass
    .fatal __msg__
  .endif
.endmacro

.macro bad_types __ctx__, __pass__, __msg__
  .repeat .tcount(__pass__), iter
    .if ctx <> (index __pass__, iter)
      .fatal __msg__ 
    .endif
  .endrepeat
.endmacro