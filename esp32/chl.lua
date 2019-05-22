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

-- Modifikuje menu podle nastaveného modulu
function MenuModify(index, value)
    -- odmazeme existujici
    for i=4, 10, 1 do
        MenuList[i] = nil
    end

    -- dame nove
    for i=4, 10, 1 do
        MenuList[i] = { Text=i..". menu", SelIndex=2, Values={10,20,30,40}}
    end
end


-- nastaveni a inicializace menu
MenuList = 
{ 
    { Text="Channel",  SelIndex=1, Values={1,2}},
    { Text="Modul",  SelIndex=1, Values={"eff_1", "eff_2"},
        ValueChanged = MenuModify
    },
    { Text="Speed",  SelIndex=1, Values={10,20,30,40,50,60,70,80,90,100}},
    { Text="3.Random", SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="4.Red",    SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="5.Green",  SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="6.Black",  SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="7.White",  SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="8.Yellow", SelIndex=1, Values={1,2,3,4,5,6}},
    { Text="9.Santin", SelIndex=1, Values={1,2,3,4,5,6}}
}

Menu = require("menu") -- pripojime knihovnu pro praci s menu
Menu.Init(pio.GPIO34, pio.GPIO35, pio.GPIO32, MenuList)
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

-- https://www.gammon.com.au/scripts/doc.php?lua=f:lines
-- f=io.input("eff_1.lua")
-- it=f:lines()
-- for i in it do print (i) end
-- f:close()

-- for line in io.lines ("eff_1.lua") do
--     print (line)
-- end 

-- for fi in io.lines ("lib/lua") do
--     print (fi)
-- end 
-- for i, key in ipairs(fi) do print (i) end

-- print(table.)
-- dir = io.open("lib/lua")
-- for i in pairs(io.open("lib/lua")) do print (i) end

