.define index(_index, collection) .right(1, {.left((_index << 1) + 1, collection)})
.define append(collection, value) {.left(.tcount(collection), collection), value}
.define iscollection(token) .tcount(.left(2, token)) = 2