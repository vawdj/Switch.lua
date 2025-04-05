local function is_eq(v1, v2, visited)
    if v1 == v2 then return true end
    local t1 = type(v1)
    if t1 ~= type(v2) then return false end
    if t1 == "table" then
        visited = visited or {}
        local pair_key = tostring(v1) .. ":" .. tostring(v2)
        if visited[pair_key] then return true end
        visited[pair_key] = true
        local l1, l2 = 0, 0
        for k, i1 in pairs(v1) do
            if v2[k] == nil then return false end
            if not is_eq(i1, v2[k], visited) then return false end
            l1 = l1 + 1
        end
        for _ in pairs(v2) do l2 = l2 + 1 end
        return l1 == l2
    end
    return false
end

local switch = { id = {} }

function switch.list(...)
    local args = { ... }
    return setmetatable({
        call = function(v)
            for _, i in pairs(args) do
                if is_eq(i, v) then return true end
            end
            return false
        end
    }, switch.id)
end

local all_types = {
    ["string"] = true,
    ["number"] = true,
    ["boolean"] = true,
    ["table"] = true,
    ["function"] = true,
    ["thread"] = true,
    ["userdata"] = true,
    ["nil"] = true
}
function switch.typeof(t)
    assert(type(t) == "string", "Type must be a string")
    assert(all_types[t], "Invalid type: " .. t)
    return setmetatable({
        call = function(v)
            return type(v) == t
        end
    }, switch.id)
end

function switch.range(min, max, step)
    step = step or 1
    assert(type(min) == "number", "Minimum must be a number")
    assert(type(max) == "number", "Maximum must be a number")
    assert(type(step) == "number", "Step must be a number")
    assert(step > 0, "Step must be positive")
    return setmetatable({
        call = function(v)
            if type(v) ~= "number" then return false end
            if v < min or v > max then return false end
            return (v - min) % step == 0
        end
    }, switch.id)
end

function switch.pattern(pattern)
    assert(type(pattern) == "string", "Pattern must be a string")
    return setmetatable({
        call = function(v)
            if type(v) ~= "string" then return false end
            return v:match(pattern) ~= nil
        end
    }, switch.id)
end

function switch.new(_, v)
    return function(t)
        local val
        for k, o in pairs(t) do
            if type(k) == "table" and getmetatable(k) == switch.id then
                if k.call(v) then
                    val = o; break
                end
            else
                if is_eq(k, v) then
                    val = o; break
                end
            end
        end
        val = val or t.default
        return type(val) == "function" and val() or val
    end
end

return setmetatable(switch, { __call = switch.new })
