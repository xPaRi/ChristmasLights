-- StarList

local starlist = 
{
    local StarList_mt =
    {
        Action = function(self, num)
            self.amount = self.amount + num
        end,

        new = function(self, index)
            self[index] = START.new(index)
        end,

        __tostring = function(self)
            return table.concat{"Name: " .. self.Name, "; Index: " .. self.Index}
        end
    }

    StarList_mt.__index = StarList_mt

    STAR = 
    {
        new = function(index)
            local obj = {Index=index, Name="Star "..index}
            setmetatable(obj, StarList_mt)
            return obj
        end
    }
}

return starlist