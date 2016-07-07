aList = {}
jsquadosPastebinCode = "w93AaBmB";
josVersion = "v1.02"

function settings()
 term.clear()
 term.setCursorPos(1,1)
 print("Set default apps")
 print("exit")
 
 local event, button, xPos, yPos = os.pullEvent("mouse_click")

end

function MainMenuBtns()
DrawMainMenu()
while true do
   local event, button, xPos, yPos = os.pullEvent("mouse_click")

   if (xPos > 17 and xPos < 25) and (yPos == 1) then 
       Explorer()
       DrawMainMenu()
   end

   if (xPos > 15 and xPos < 28) and (yPos == 2) then 
       print("Enter a program")
       shell.openTab(read())
       DrawMainMenu()
   end

   if (xPos > 18 and xPos < 31) and (yPos == 3) then
                settings()
                DrawMainMenu()
   end
   if (xPos > 20 and xPos < 25) and (yPos == 4) then
       print("program will exit")
       sleep(1)
       break
   end
end
end

function DrawMainMenu()
   term.clear()
   term.setCursorPos(1,1)
   print("                   Explore                  "..josVersion)
   print("                 Open program                     ")
   print("                   Settings                      ")
   print("                    Exit                          ")
   print("___________________________________________________")
end

function Explorer(task)
 shell.run("/usr/bin/Explorer.lua")
end



function updateOS()
        if fs.exists("/JsquadOS") then        
                fs.delete("/JsquadOS")
        end
        shell.run("pastebin get "..jsquadosPastebinCode.." /JsquadOS")
        print("")
        shell.run("reboot")
end

MainMenuBtns()
