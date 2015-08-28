startDir = "/home/joshua/"
function listFiles(aFiles,begin,finish)
	term.setBackgroundColor(josCfg.windowMainColor)	
	term.setTextColor(colors.black)
	x , y = 6 , 4	
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
			x = 6
		else
			x = x + 7
		end

	end
	local event, button, xPos, yPos = os.pullEvent()
	if event == "mouse_click" and xPos == 47 and yPos == 3 then
		return "terminate"
	end
end

function main ()
	local files = {}
	while true do 
		local FileList = fs.list(shell.dir())
		for i, file in ipairs(FileList) do
			files[i] = shell.dir().."/"..file 
		end	
		jos.drawWindow(5,48,3,17,"/"..shell.dir())
		
		if listFiles(files,1,table.getn(files)) == "terminate" then
			break
		end
		
	end
end

--shell.run("cd "..startDir)
main()
