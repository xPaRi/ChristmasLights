local m = 
{
    -- Konstruktor nove hvezdy
    CreateNewStar = function (neoPixel, index, paramList)
        local self = {}

        self.ParamList = paramList
        self.Index = index
        self.Stage = 0

        self.Go = function(...)
            neoPixel:setPixel(self.Index-1, paramList.A, 0, 0)
        end

        return self
    end
    --
}

return m
