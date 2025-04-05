# TODO

- Make switch statement preserve evaluation order so matches are checked in the order defined

## Current Syntax (order not guaranteed)
```lua
local result = switch(value) {
    case1 = result1,
    case2 = result2,
    default = "default value"
}
```

## New Syntax (preserves order)
```lua
local result = switch(value)
    .case(case1, result1)
    .case(case2, result2)
    .default("default value")
    .execute()
```

## Notes
- Current implementation uses pairs() which doesn't guarantee order
- Implement method chaining approach to maintain definition order