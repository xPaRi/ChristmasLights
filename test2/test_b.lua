-- Definice

-- Inicializace seznamu hvezd
START_COUNT = 5 --pocet hvezd

neopixel = require("NeoPixel.lua") -- Pseudo objekt pixel
Neo = neopixel.attach(START_COUNT)

starlist = require("Starlist.lua")
StartList = starlist

for i=1, START_COUNT do 
    -- StartList[i] = StartList:new(i)
end
-- ---

-- Main
for i, star in ipairs(StartList) do
    print(star)
end
-- ---

print("Cajk!")