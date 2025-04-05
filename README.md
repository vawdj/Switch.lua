# Lua Switch Function

This is a small utility to mimic a switch-case statement in Lua, with extensive matching capabilities:

- Direct value matching
- Table key matching using deep equality
- List checking
- Numeric range checking
- Type-based matching
- String pattern matching
- Handling for cyclic table references
- Optional default fallback
- Function or static value responses

## Basic Usage

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

You can match table keys using deep comparison:

```lua
local key = {x = 1}

local result = switch(key) {
    [{x = 1}] = function() return "matched" end,
    default = "no match"
}

print(result) -- "matched"
```

## Advanced Matching

### List Membership

Check if a value is contained in a list:

```lua
local result = switch(11) {
    [switch.list(1, 2, 11, 3, 9)] = "included in list",
    default = "not in list"
}
```

### Numeric Ranges

Check if a number falls within a range (with optional step):

```lua
local result = switch(4) {
    [switch.range(0, 9)] = "in range 0 to 9",
    [switch.range(10, 20)] = "in range 10 to 20",
    default = "out of range"
}
```

### Type Checking

Match based on value type:

```lua
local result = switch(value) {
    [switch.typeof("string")] = "It's a string",
    [switch.typeof("number")] = "It's a number",
    [switch.typeof("table")] = "It's a table",
    default = "Other type"
}
```

### Pattern Matching

Match strings against Lua patterns:

```lua
local result = switch(phoneNumber) {
    [switch.pattern("^%d%d%d%-%d%d%d%-%d%d%d%d$")] = "US phone number",
    [switch.pattern("^%+%d%d %d+ %d+$")] = "International format",
    default = "Invalid phone format"
}
```

## Notes

- If the matching value is a function, it's called and its output is returned
- If not, the value is returned as is
- If no match is found, `default` is used (if provided)
- The implementation handles cyclic table references correctly
- All matchers can be combined in the same switch statement