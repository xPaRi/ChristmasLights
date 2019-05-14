#t::Run C:\WApp\Putty\putty.exe -load "ESP32" ;Win+T
return

#y::
Send dofile("menu.lua"){enter}
return

f12::
Send exit{enter}
Sleep 1000
Send +{insert}


