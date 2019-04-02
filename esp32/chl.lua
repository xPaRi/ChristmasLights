function CreateStarList(neoPixel, count, modul, paramList)
    
    local creator = require(modul) -- pripojime knihovnu pro tvorbu hvezd
    
    local list = {}

    list.Update = function() 
        neoPixel:update()
    end

    for index=1, count, 1 do
        list[index] = creator.CreateNewStar(neoPixel, index, paramList)
    end

    return list
end

function Go(list)
    while true do
        for i, obj in ipairs(list) do
            obj.Go()
        end

        list.Update()
    end
end
-- 

STAR_COUNT_1 = 20 -- Pocet hvezd
NeoPixel_1 = neopixel.attach(neopixel.WS2812B, pio.GPIO12, STAR_COUNT_1)
ParamList_1 = {A = 10, B = 0, C = 0}
StarList_1 = CreateStarList(NeoPixel_1, STAR_COUNT_1, "eff_2", ParamList_1) 

STAR_COUNT_2 = 3 -- Pocet hvezd
NeoPixel_2 = neopixel.attach(neopixel.WS2812B, pio.GPIO14, STAR_COUNT_2)
ParamList_2 = {A = 0, B = 20, C = 20}
StarList_2 = CreateStarList(NeoPixel_2, STAR_COUNT_2, "eff_1", ParamList_2) 

-- Jedeme
thread.start(function() Go(StarList_1) end)
thread.start(function() Go(StarList_2) end)
--

print("Cajk!")
