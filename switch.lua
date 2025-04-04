local function tbl_eq(t1, t2)
    local l1, l2 = 0, 0

    for k, v1 in pairs(t1) do
        if not t2[k] then return false end

        local typ1, v2 = type(v1), t2[k]

        if typ1 ~= type(v2) then return false end

        if typ1 == "table" then
            if not tbl_eq(v1, v2) then return false end
        else
            if v1 ~= v2 then return false end
        end

        l1 = l1 + 1
    end

    for _ in pairs(t2) do
        l2 = l2 + 1
    end

    return l1 == l2
end

return function(v)
    return function(t)
        local val

        if type(v) == "table" then
            if t[v] then
                val = t[v]
            else
                for k, o in pairs(t) do
                    if type(k) == "table" and tbl_eq(k, v) then
                        val = o
                        break
                    end
                end
            end
        else
            val = t[v]
        end

        val = val or t.default
        return type(val) == "function" and val() or val
    end
end
