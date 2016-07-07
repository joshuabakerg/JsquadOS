term.setBackgroundColor(colors.blue)
term.setTextColor(colors.green)

function editTool(dir)
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(colors.green)
	term.setBackgroundColor(colors.blue)
	print("open")
	print("Open with..")
	print("Copy")
	print("Cut")
	print("Paste")
	print("Delete")
	print("Edit")
	print("Rename")
	print("Create File")
	print("Create Folder")
	local event, button, xPos, yPos = os.pullEvent("mouse_click")
	if (xPos > 0 and xPos <= 15) and (yPos == 1) then              --open in new tab
		print(shell.resolve(dir))
		sleep(1)
        shell.openTab(dir)
        print("after open")
		sleep(2)
	elseif (xPos > 0 and xPos <= 15) and (yPos == 2) then          --open with..
		term.clear()
		term.setCursorPos(1,1)
		write("Please enter program: ")
		local sProg = read()
		write("Please enter extra params: ")
		local exParams = read()
			shell.run("/Programs/"..sProg.." " ..dir.." "..exParams)
  elseif (xPos > 0 and xPos < 5) and (yPos == 3) then             --copy
	  if fs.exists("/tmp/clipBoardContents") then
	     fs.delete("/tmp/clipBoardContents")
	  end
	  if fs.exists("/tmp/clipBoardContentsName") then
	     fs.delete("/tmp/clipBoardContentsName")
	  end
	  fs.copy(shell.resolve(dir),"/tmp/clipBoardContents")
	  local tFile = fs.open("/tmp/clipBoardContentsName","w")
	  tFile.write(dir)
	  tFile.close()  
	elseif (xPos > 0 and xPos < 5) and (yPos == 4) then              --cut
	  if fs.exists("/tmp/clipBoardContents") then
       fs.delete("/tmp/clipBoardContents")
    end
    if fs.exists("/tmp/clipBoardContentsName") then
       fs.delete("/tmp/clipBoardContentsName")
    end
    fs.copy(shell.resolve(dir),"/tmp/clipBoardContents")
    fs.delete(shell.dir().."/"..dir)
    local tFile = fs.open("/tmp/clipBoardContentsName","w")
    tFile.write(dir)
    tFile.close()  
	elseif (xPos > 0 and xPos < 6) and (yPos == 5) then              --paste
	  local tFile = fs.open("/tmp/clipBoardContentsName","r")
	  fs.copy("/tmp/clipBoardContents",shell.dir().."/"..tFile.readAll())
	  tFile.close()
		
	elseif (xPos > 0 and xPos < 7) and (yPos == 6) then              --delete
		fs.delete(shell.dir().."/"..dir)
	elseif (xPos > 0 and xPos <= 4) and (yPos == 7) then             --edit
        shell.run("edit " ..dir)
	elseif (xPos > 0 and xPos <= 6) and (yPos == 8) then             --rename
        local orgF = shell.resolve(dir)
		term.clear()
		term.setCursorPos(1,1)
		write("Rename from "..dir.." to:")
		local newF = shell.resolve(read())
		fs.move(orgF,newF)
	elseif (xPos > 0 and xPos <= 11) and (yPos == 9) then            --create file
		term.clear()
		term.setCursorPos(1,1)
		write("File Name:")
		local myFile = fs.open(shell.dir().."/"..read(),"w")
		myFile.close()
		
	elseif (xPos > 0 and xPos <= 13) and (yPos == 10) then           --create folder
		term.clear()
		term.setCursorPos(1,1)
		write("Name:")
		fs.makeDir(shell.dir().."/"..read())
    end

end

function explorer()
while true do
    n = 0
    term.clear()
    term.setCursorPos(1,1)
    local FileList = fs.list(shell.dir()) 
    for i, file in ipairs(FileList) do
  if fs.isDir(shell.resolve(file)) then
    term.setTextColor(colors.yellow)
  else
    term.setTextColor(colors.white)
  end
        print(file)
        aList[i] = file
        n = i
        if i == 16 then
            break
        end
    end
    term.setTextColor(colors.white)
        

    print("/")
    print("X")
    n = n+1;
    aList[n] = "..";
    n = n+1;
    aList[n] = "X";
    
    local event, button, xPos, yPos = os.pullEvent("mouse_click")
  if button == 1 then
    if aList[yPos] ~= nil then
      if aList[yPos] == "X" then
        break
      elseif aList[yPos] == ".." then
        shell.run("cd "..aList[yPos])
      end
      if fs.isDir(shell.resolve(aList[yPos])) and aList[yPos] ~= ".." then
        shell.run("cd "..aList[yPos]) 
      end 
      if task ~= nil then
          shell.run(task .." "..aList[yPos])
      else
        shell.run(aList[yPos])
      end
    end
  elseif button == 2 then
    if aList[yPos] ~= nil then
      if (aList[yPos] ~= "X") and (aList[yPos] ~= "/") then
        editTool(aList[yPos])
      end
    end
  end
end
end
explorer()
