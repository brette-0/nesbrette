.define strindex(c, i) .right(1, {.left(1 + (i << 1), c)})
.define index(collection, _index) ((i >= 0) * .right(1, {.left(1 + (i << 1), c)})) | ((i < 0) * .left(1, {.right(1 + (abs i << 1), c)}))
.define append(collection, value) {.left(.tcount(collection), collection), value}
.define isarray(unindicated_token) (.tcount(.left(2, unindicated_token)) = 2)