STAR_COUNT = 5

StarList = {}

function Go()
end

function Add(list, index)
    list[index] = 
    {
        ["Index"] = index,
        ["Go"] = function () index = 5 end,
        ["Print1"] = function () print("Print1: "..index) end,
        ["Print2"] = function () print("Print2: "..self) end,
    }
end

for index=1, 10, 1 do
    Add(StarList, index)
end

for index=1, 10, 1 do
    StarList[index].Print1()
    StarList[index].Print2()
end

