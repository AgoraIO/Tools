local _M = {}


local function contains(t, target)
    for i=1, #t do
        if t[i] == target then
            return true
        end

    end

    return false
end

_M.contains = contains

return _M