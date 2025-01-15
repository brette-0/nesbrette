.define type(__token__)\
      (.xmatch(.left(1, __token__), u8)     * 1 ) \
    | (.xmatch(.left(1, __token__), u16)    * 2 ) \
    | (.xmatch(.left(1, __token__), u24)    * 3 ) \
    | (.xmatch(.left(1, __token__), u32)    * 4 ) \
    | (.xmatch(.left(1, __token__), u64)    * 8 ) \
    | (.xmatch(.left(1, __token__), string) * -1) \
    | (.xmatch(.left(1, __token__), token)  * -2) \
    | (.xmatch(.left(1, __token__), list)   * -2) \