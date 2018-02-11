local tableUtils = {}

function tableUtils.updateTable(tbl, with)
    for k, v in pairs(with) do
        tbl[k] = v
    end
end

function tableUtils.mergeLists(...)
    local ret = {}
    for i = 1, select("#", ...) do
        tableUtils.extend(ret, select(i, ...))
    end
    return ret
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

function tableUtils.indexOf(list, elem)
    for i, v in ipairs(list) do
        if v == elem then return i end
    end
    return nil
end

function tableUtils.inList(list, elem)
    return tableUtils.indexOf(list, elem) ~= nil
end

return tableUtils
