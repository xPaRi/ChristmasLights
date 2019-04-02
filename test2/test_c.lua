function CreateStarList(count, modul, paramList)
    
    local creator = require(modul) -- pripojime knihovnu pro tvorbu hvezd
    
    local list = {}

    for index=1, count, 1 do
        list[index] = creator.CreateNewStar(index, paramList)
    end
    
    return list
end

function Go(list)
    for stage=1, 3 do
        print("-- " .. stage .. " --")
    
        for index, obj in ipairs(list) do
            obj.Go()
        end
    end
end


STAR_COUNT = 5 -- Pocet hvezd

paramList = {A = 1, B = 2, C = 3}

-- Pole hvezd, efekt 1
StarList = CreateStarList(STAR_COUNT, "test2/test_c_effect_1", paramList) 
Go(StarList)

paramList.A = 11
paramList.B = 22
paramList.C = 33

Go(StarList)

-- Pole hvezd, efekt 2
--StarList = CreateStarList(STAR_COUNT, "test2/test_c_effect_2")
--Go(StarList)

print("Cajk!")
