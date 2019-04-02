local m = 
{
    -- Konstruktor nove hvezdy
    CreateNewStar = function (index)
        local self = {}

        self.Index = index

        self.Stage = 0

        self.Go = function(...)
            self.Stage = self.Stage + 1
            print("Star: " .. self.Index .. "; Effect: 2; Stage: " .. self.Stage)
        end

        return self
    end
    --
}

return m