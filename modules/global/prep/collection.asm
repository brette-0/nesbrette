.define index(collection, _index) .right(1, {.left((_index << 1) + 1, collection)})
.define append(collection, value) {.left(.tcount(collection), collection), value}
.define isarray(unindicated_token) (.tcount(.left(2, unindicated_token)) = 2)