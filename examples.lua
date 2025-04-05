-- Lua Switch-Case Examples
-- This file demonstrates various ways to use the custom switch implementation

local switch = require("switch")

print("=== Basic String Matching ===")
local result = switch("foo") {
    foo = function() return "bar" end,
    baz = "static value",
    default = "default value"
}
print("switch('foo') returns", result) -- Expected: "bar"

print("\n=== Table Comparison ===")
local key = { x = 1 }
local result = switch(key) {
    [{ x = 1 }] = function() return "matched" end,
    [{ x = 2 }] = "wrong value",
    default = "no match"
}
print("switch({x = 1}) returns", result) -- Expected: "matched"

print("\n=== List Membership Testing ===")
local result = switch(11) {
    [switch.list(1, 2, 11, 3, 9)] = "included in list",
    default = "not in list"
}
print("switch(11) with list(1,2,11,3,9) returns", result) -- Expected: "included in list"

print("\n=== Numeric Range Testing ===")
local result = switch(4) {
    [switch.range(0, 9)] = "in range 0 to 9",
    [switch.range(10, 20)] = "in range 10 to 20",
    default = "out of range"
}
print("switch(4) with range(0,9) returns", result) -- Expected: "in range 0 to 9"

print("\n=== Cyclic Table References ===")
-- Create tables with self-references
local t1 = { name = "table1", value = 42 }
local t2 = { name = "table1", value = 42 }

-- Create circular references
t1.ref = t1
t2.ref = t2

local result = switch(t1) {
    [t2] = "Matched cyclic tables correctly",
    default = "No match"
}
print("switch(t1) with cyclic references returns", result) -- Expected: "Matched cyclic tables correctly"

print("\n=== Type-Based Matching ===")
local values = { "hello", 42, true, {} }
for _, value in ipairs(values) do
    local result = switch(value) {
        [switch.typeof("string")] = "It's a string",
        [switch.typeof("number")] = "It's a number",
        [switch.typeof("boolean")] = "It's a boolean",
        default = "Other type"
    }
    print("switch(" .. tostring(value) .. ") by type returns", result)
end

print("\n=== Pattern Matching ===")
local phoneNumber = "555-123-4567"
local result = switch(phoneNumber) {
    [switch.pattern("^%d%d%d%-%d%d%d%-%d%d%d%d$")] = "US phone number",
    [switch.pattern("^%+%d%d %d+ %d+$")] = "International format",
    default = "Invalid phone format"
}
print("switch('555-123-4567') with pattern returns", result) -- Expected: "US phone number"

print("\n=== Command Processing Example ===")
local commands = { "/help users", "/login user123", "/logout" }
for _, command in ipairs(commands) do
    local result = switch(command) {
        [switch.pattern("^/help")] = function()
            local topic = command:match("^/help%s+(.+)") or "general"
            return "Showing help for " .. topic
        end,
        [switch.pattern("^/login%s+%w+")] = function()
            local username = command:match("^/login%s+(%w+)")
            return "Logging in user " .. username
        end,
        ["/logout"] = "User logged out",
        default = "Unknown command"
    }
    print("switch('" .. command .. "') returns", result)
end
