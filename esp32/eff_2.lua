local m = 
{
    -- Konstruktor nove hvezdy
    CreateNewStar = function (neoPixel, index, paramList)
        local self = {}

        self.ParamList = paramList
        self.Index = index
        self.Stage = 0
        self.IsUp = false
        self.IsDown = false
        self.R=0
        self.G=0
        self.B=0

        self.Go = function(...)
            if (self.IsUp) then
                self.Stage = self.Stage + 10

                if (self.Stage <= 255) then
                    neoPixel:setPixel(self.Index-1, self.R * self.Stage, self.G * self.Stage, self.B * self.Stage)
                else
                    self.IsUp = false
                    self.IsDown = true    
                    self.Stage = 255
                end
            elseif (self.IsDown) then
                self.Stage = self.Stage - 1

                if (self.Stage > self.ParamList.A) then
                    neoPixel:setPixel(self.Index-1, self.R * self.Stage, self.G * self.Stage, self.B * self.Stage)
                else
                    self.IsUp = false
                    self.IsDown = false
                end 
            else
                if (math.random (0, 2000) == self.Index) then
                    self.IsUp = true
                    self.Stage = self.ParamList.A

                    repeat 
                        self.R = math.random (0, 1)
                        self.G = math.random (0, 1)
                        self.B = math.random (0, 1)
                    until (self.R+self.G+self.B > 0)
                end
            end
        end

        return self
    end
    --
}

return m
