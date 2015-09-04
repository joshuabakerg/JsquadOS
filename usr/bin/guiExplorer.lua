startDir = "/home/joshua/"
returnDir = ""
function listFiles(aFiles,begin,finish)
	term.setBackgroundColor(josCfg.windowMainColor)	
	term.setTextColor(colors.black)
	x , y = 8 , 4	
	for i = begin,finish do
		fileColor = colors.white
		if fs.isDir(aFiles[i]) then
			fileColor = colors.yellow
		else
			fileColor = colors.white	
		end
		jos.drawLabel(fs.getName(aFiles[i]),x,y,fileColor,colors.white,josCfg.windowMainColor)
		if x >= 48 -7 then 
			y = y + 5
			x = 8
		else
			x = x + 7
		end

	end
	local event, button, xPos, yPos = os.pullEvent("mouse_click")
	if event == "mouse_click" and xPos == 48 and yPos == 3 then
		return "terminate"
	elseif event == "mouse_click" and xPos >= 4 and xPos <= 5 and yPos == 4 then
		returnDir = "/"..shell.dir()
		shell.run("cd ..")
	elseif event == "mouse_click" and xPos >= 4 and xPos <= 5 and yPos == 6 then
		if returnDir ~= "" then
			shell.run("cd "..returnDir)	
		end
	end
end

function main ()
	local files = {}
	while true do 
		local FileList = fs.list(shell.dir())
		for i, file in ipairs(FileList) do
			files[i] = shell.dir().."/"..file 
		end	
		jos.drawWindow(4,49,3,17,"/"..shell.dir())
		term.setCursorPos(4,4)
		term.setBackgroundColor(colors.green)
		write("<-")
		term.setCursorPos(4,6)
		write("->")
		
		local x
		if table.getn(files) > 18 then
			x = table.getn(files) -18
		else
			x = 0
		end
		if listFiles(files,1,table.getn(files)-x) == "terminate" then
			break
		end
		
	end
end

--shell.run("cd "..startDir) --Too set default start directory
main()
