STAR_COUNT = 5

StarList = {}

StarList_mt =
{
    Action = function(self, num)
        self.amount = self.amount + num
    end,

    new = function(self, index)
        self[index] = {["Index"] = index, ["Name"] = "Nazev "..index}
    end,

    go = function(self, index)
        self[index]["Name"] = self[index]["Name"] .. "xxxx"
    end,


    item = function(self, index)
        return index.."xx"
    end,

    __tostring = function(self)
        return table.concat{"Name: " .. self.Name, "; Index: " .. self.Index}
    end
}

setmetatable(StarList, StarList_mt)

StarList_mt.__index = StarList_mt


print("Init Star list [" .. STAR_COUNT .. "]")

for i=1, STAR_COUNT, 1 do
    StarList:new(i)
    print(StarList[i].Index)
end

print("Func calling... ")



for i=1, STAR_COUNT, 1 do
    print(StarList[i].Index .. " " .. StarList[i].Name)
    StarList:go(i)
    print(StarList[i].Index .. " " .. StarList[i].Name)
end


--[[
for i=1, STAR_COUNT, 1 do
    StarList[i] = 
    {
        ["Go"] = function () 
            next = StarList[i+1] 
            if (next == nil) then
                print(i, "END") 
            else
                print(i, next.Index) 
            end
        end, 
        ["Print"] = function () self = StarList[i] print(self.Index) end, 
        ["Index"] = i*100,
        ["Index"] = i,
        ["Name"] = "Prvek " .. i
    }
end

print("Func calling...")

for i=1, STAR_COUNT, 1 do
    local item = StarList[i]
    item.Go() --StarList[i].Go()
    item.Print() 
    print(item.Index) --print(StarList[i].Index)
    --print(" " .. StarList)
end
]]--

