local flr = _G.math.floor
-- Floor division be implemented via `//`, but Love2D's LuaJIT doesn't support it yet.
-- It is only used @ 13 : 15, change the whole expression to `index // width` if you wish.

function get_cell_bonds(data, width, height, set, index)

    local l = nil
    local u = nil
    local r = nil
    local d = nil

    local x = index %  width
    local y = flr(index / width) -- `//`

    local pin = nil
    
    pin = x - 1; if pin >= 0
    then
        l = (set[data[pin + y * width]] or { }).r
    end

    pin = y - 1; if pin >= 0
    then
        u = (set[data[x + pin * width]] or { }).d
    end

    pin = x + 1; if pin < width
    then
        r = (set[data[pin + y * width]] or { }).l
    end

    pin = y + 1; if pin < height
    then
        d = (set[data[x + pin * width]] or { }).u
    end

    return { l = l
           , u = u
           , r = r
           , d = d }

end

function get_set_cells_matching_bonds(set, bonds)

    local l = bonds.l
    local u = bonds.u
    local r = bonds.r
    local d = bonds.d

    local cells = { }

    for i = 1, #set do
        if  (l == nil or l == set[i].l)
        and (u == nil or u == set[i].u)
        and (r == nil or r == set[i].r)
        and (d == nil or d == set[i].d) then
            table.insert(cells, i)
        end
    end

    return cells

end

function collapse(data, width, height, set, pick)

    local smallest = set
    local position = nil

    local size = width * height

    for i = 0, size - 1 do

        if data[i] ~= nil then goto continue end

        local bonds = get_cell_bonds(data, width, height, set, i)
        local cells = get_set_cells_matching_bonds(set, bonds)

        if #cells <= #smallest then
            smallest = cells
            position = i
        end

        ::continue::
    end
    
    if position == nil then return false end

    data[position] = pick(smallest)

    return true

end

return collapse
