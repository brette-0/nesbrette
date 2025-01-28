.define null_coalesce(n, c) ((n == null) * c) | ((n != null) * n)
.define is_null(n) (n == null)