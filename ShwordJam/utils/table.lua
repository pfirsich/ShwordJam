local tableUtils = {}

function tableUtils.updateTable(tbl, with)
    for k, v in pairs(with) do
        tbl[k] = v
    end
end

function tableUtils.enum(list)
    local enum = {}
    local counter = 0
    for i = 1, #list do
        enum[list[i]] = counter
        counter = counter + 1
    end
    return enum
end

function tableUtils.extend(a, b)
    if not b then
        return a
    end

    for _, item in ipairs(b) do
        table.insert(a, item)
    end

    return a
end

return tableUtils
