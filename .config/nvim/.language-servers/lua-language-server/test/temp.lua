        package.cpath = [[build/linux/bin/?.so]]
        local function eq(a, b)
            assert(#a == #b)
            for i, v in ipairs(a) do
                assert(v == b[i], b[i])
            end
        end
        local t = {"A\" B"}
        eq(arg, t)
    