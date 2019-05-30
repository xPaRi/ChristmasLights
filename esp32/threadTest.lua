function MyFun()
    while true do
        print(".")
        thread.sleepms(200)
    end
end

print("TEST 3")

index = 0
while (true) do
    index = index + 1

    TH = thread.start(MyFun, 4096, 3, 1, "th_"..index)
    thread.list()

    thread.sleepms(1000)
    print("Stoping TH...")
    thread.stop(TH)
    print("TH stoped.")
    thread.list()
    
    thread.sleepms(50)
end

-- dofile("threadTest.lua")