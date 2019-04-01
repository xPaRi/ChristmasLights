local account_mt =
{
    deposit = function(self, num)
        self.amount = self.amount + num
    end,
    withdraw = function(self, num)
        self.amount = self.amount - num
    end,
    __tostring = function(self)
        return table.concat{self.name, ": ", self.amount, " ", selft.currency}
    end
}

account_mt.__index = account_mt

ACCOUNT = 
{
    new = function(name, currency)
        local obj = {name=name, currency=currency, amount=0}
        setmetatable(obj, account_mt)
        return obj
    end
}