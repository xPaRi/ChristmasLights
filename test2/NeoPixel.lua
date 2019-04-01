-- Fake třída NeoPixel
local neopixel = 
{
    pixPre = {},

    pixCur = {},

    count = 0,

    attach = function(count)
        self = neopixel
        self.count = count

        for index=1, self.count do
            self.pixPre[index] = {r=0, g=0, b=0} 
            self.pixCur[index] = {r=0, g=0, b=0} 
        end

        return neopixel
    end,

    setPixel = function(self, index, r, g, b)
        self.pixPre[index] = {r=r, g=g, b=b} 
    end,

    update = function(self)
        for index=1, self.count do
            self.pixCur[index] = self.pixPre[index]
        end
    end,

    print = function(self)
        print("-- neopixel ----------------------------")
        for i, item in ipairs(self.pixCur) do
            print("pixel: "..i, item.r, item.g, item.b)
        end
        print("----------------------------------------")
    end
}

return neopixel
