# Lua Switch Function

This is a small utility to mimic a switch-case statement in Lua, with support for:

- Direct value matching
- Table key matching using deep equality
- Optional default fallback
- Function or static value responses

## Usage

```lua
local switch = require("switch")

local result = switch "foo" {
    foo = function() return "bar" end,
    baz = "static value",
    default = "default value"
}

print(result) -- "bar"
```

## Table Key Matching

You can also match table keys using deep comparison:

```lua
local key = {x = 1}

local result = switch(key) {
    [{x = 1}] = function() return "matched" end,
    default = "no match"
}

print(result) -- "matched"
```

## Notes

- If the matching value is a function, it's called and its output is returned.
- If not, the value is returned.
- If no match is found, `default` is used (if provided).
