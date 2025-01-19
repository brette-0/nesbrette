***
##### Introduction

`nesbrette` macros and defines use typed parameters where appropriate. In order to create a typed parameter simply create a label with the same name but prefixed with 'w_' as seen below:
```
PlayerHealth   = $0300
w_PlayerHealth = 2
```

Then when you pass `PlayerHealth` as a parameter, the 'array width' or 'type' will be accessed from the prefixed label. However, should you wish to *manually* specify the type of the value you can always do the following:
```
cmult u16: PlayerHealth, 5	; multiply health by 5 'health bonus'
```

If you are using `nesbrette` for a more versatile project, or a project with rapidly changing scope in which hard-coded types are not appropriate, you *should* use type labels like so:

```
PlayerHealth = $0300
HEALTH_WIDTH = 2

cmult HEALTH_WIDTH: PlayerHealth, 5
```

If your solution wishes to use type validation, the only instruction you might really care for is `detype` which requests an integer value token as its secondary parameter, with the typed parameter as its primary token. 

```
.macro Example __param__
	.local __val

	detype __param__, __val
	.if __val > 4
		.warning "This function may take a long time"
	.endif
.endmacro
```

##### Feature Breakdown:

| Feature   | Return     | Type     | Function                               | Limit |
| --------- | ---------- | -------- | -------------------------------------- | ----- |
| `istyped` | `bool`     | `define` | Checks for type indicator              | None  |
| `itype`   | `identity` | `define` | Identifies type indicator              | Scope |
| `type`    | `int`      | `define` | Compares token for type                | None  |
| `label`   | `string`   | `define` | Fetches target name                    | None  |
| `ilabel`  | `identity` | `define` | Identifies parameter target            | Scope |
| `peek`    | `string`   | `define` | Fetches string of target value         | Scope |
| `width`   | `identity` | `define` | Width identifier for target            | Scope |
| `isnum`   | `bool`     | `define` | Checks for numerical type              | None  |
| `isconst` | `bool`     | `define` | Checks for constant type               | None  |
| `detype`  | `None`     | `macro`  | Prioritised type fetch                 | Scope |
| `int`     | `int`      | `define` | Casts string to integer                | None  |
| `get`     | `int`      | `define` | Casts typed parameter value to integer | Scope |

##### Types:

| Name           | Prefix   | Category     | Size |
| -------------- | -------- | ------------ | ---- |
| Unsigned 8bit  | `u8`     | Number       | 1    |
| Unsigned 16bit | `u16`    | Number       | 2    |
| Unsigned 24bit | `u24`    | Number       | 3    |
| Unsigned 32bit | `u32`    | Number       | 4    |
| Unsigned 64bit | `u64`    | Number       | 8    |
| Signed 8bit    | `i8`     | Number       | 1    |
| signed 16bit   | `i16`    | Number       | 2    |
| Signed 24bit   | `i24`    | Number       | 3    |
| Signed 32bit   | `i32`    | Number       | 4    |
| Signed 64bit   | `i64`    | Number       | 8    |
| String         | `string` | Preprocessor | None |
| Token          | `token`  | Preprocessor | None |
| X Register     | `x`      | Special      | 1*   |
| Y Register     | `y`      | Special      | 1*   |
| Accumolator    | `acc`    | Special      | 1*   |
