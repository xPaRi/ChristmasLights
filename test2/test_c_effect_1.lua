local m = 
{
    -- Konstruktor nove hvezdy
    CreateNewStar = function (index, paramList)
        local self = {}

        self.ParamList = paramList
        self.Index = index
        self.Stage = 0

        self.Go = function(...)
            self.Stage = self.Stage + 1
            print("Star: " .. self.Index .. "; Effect: 1; Stage: " .. self.Stage .. "(" .. self.ParamList.A .. ", " .. self.ParamList.B .. ", " .. self.ParamList.C .. ")")
        end

        return self
    end
    --
}

return m