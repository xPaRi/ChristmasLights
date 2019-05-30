mutex1 = thread.createmutex()
mutex2 = thread.createmutex()

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

function Go(list, mutex)
    while true do
        mutex:lock()

        for i, obj in ipairs(list) do
            obj.Go()
        end
        
        list.Update()
        
        mutex:unlock()

        thread.sleepms(1)
    end
end

function ChannelStop(channel)
    if (channel == 1 and TH1 ~= nil) then
        print("mutext1 locking...")
        mutex1:lock()
        print("mutext1 locked.")

        print("set crestor = nil")
        creator = nil
        print("set crestor is nil")

        print("TH1 suspending...")
        thread.suspend(TH1)
        print("TH1 suspended...")

        print("TH1 stoping...")
        thread.stop(TH1)
        print("TH1 stoped.")

        print("mutext1 unlocking...")
        mutex1:unlock()
        print("mutext1 unlocked.")

        print("Setting TH1 = nil...")
        TH1=nil
        print("Setting TH1 is nil.")
    elseif (channel == 2 and TH2 ~= nil) then
        mutex2:lock()
        thread.stop(TH2)
        mutex2:unlock()
        TH2=nil
    end
end

function ChannelStart(channel, modulName)
    ChannelStop(channel)

    if (channel == 1) then
        ParamList_1 = {A = 10, B = 0, C = 0}
        StarList_1 = CreateStarList(NeoPixel_1, STAR_COUNT_1, modulName, ParamList_1) 

        TH1 = thread.start(function() Go(StarList_1, mutex1) end, 4096, 20, 0, "modul: "..modulName)
    elseif (channel == 2) then
        ParamList_2 = {A = 0, B = 20, C = 20}
        StarList_2 = CreateStarList(NeoPixel_2, STAR_COUNT_2, modulName, ParamList_2) 

        TH2 = thread.start(function() Go(StarList_2, mutex2) end, 4096, 20, 0, "neo_channel_2")
    end

    thread.list()
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
    { Text="Modul",  SelIndex=1, Values={"eff_1", "eff_2", "eff_3", "eff_4", "eff_5"},
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

STAR_COUNT_2 = 3 -- Pocet hvezd
NeoPixel_2 = neopixel.attach(neopixel.WS2812B, pio.GPIO14, STAR_COUNT_2)


print("Cajk!")

while true do ChannelStart(1,"eff_3") thread.sleepms(100) ChannelStart(1,"eff_4") thread.sleepms(100) ChannelStart(1,"eff_5") end

--[[
ChannelStart(1,"eff_3")

ChannelStart(1,"eff_4")

ChannelStart(1,"eff_5")
]]--

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

-- -- Get the file named src-filename.lua
--net.scp.get(host, port, src, dst, user, password)
--Transfers the file src from the remote host to the Lua device's file system with the name dst.
--net.scp.get("remotehost",22,"~/lua/src-filename.lua","/examples/lua/dst-filename.lua","username","secretpass")

-- net.wf.setup(net.wf.mode.STA, "IDEA-HOST", "ideahost123*")
-- net.wf.setup(net.wf.mode.STA, "IDEA1", "qweasd-123")
-- net.wf.start(false)
-- net.stat()
-- net.ping("10.5.73.113")
-- net.scp.get("10.5.73.113",22,"/test.txt","/test.txt","esp32","esp32")
-- net.scp.get("10.5.73.113",22,"test.txt","/test.txt","esp32","esp32")
-- net.scp.get("idea-envi.cz",21,"~/wwwroot/pari/mon.css","/mon.css","idea-envi","")

-- res, header, body = net.curl.get("http://www.idea-envi.cz/pari/", "mon.css")

-- program WinSCP (Total Commander)
-- program SolarWinds SFTP/SCP Server
