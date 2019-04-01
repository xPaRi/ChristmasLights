package.path = "c:/temp/lua/account.lua"
require("account.lua")
require("tasks")

ucty = 
{
    ACCOUNT.new("John", "$"),
    ACCOUNT.new("Vlado", "EUR"),
    ACCOUNT.new("Franta", "Kč")
}

for i, ucet in ipairs(ucty) do
    ucet:deposit(100)
    TASKS.add(
        function()
            repeat
                local rnd = math.random(20)
                ucet:withdraw(rnd)
                TASK.sleep(rnd/10)
                print(ucet)
            until ucet.amount <= 0

            print("Ucet "..ucet.name .. "vycerpan!")
        end
    )
end

print("Ucty naplneny, zaciname utracet!")

TASKS.run_all()
