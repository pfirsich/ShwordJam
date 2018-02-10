local tableUtils = {}

function tableUtils.updateTable(tbl, with)
    for k, v in pairs(with) do
        tbl[k] = v
    end
end

return tableUtils
