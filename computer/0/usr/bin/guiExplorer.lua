--term size = 10x10
local startDir = "/home/joshua/"
local returnDir = ""
local cloudReturnDir= ""
local args = {...}
local start = 1
local fileDrawBegin = 9
local fileDrawEnd = 3
local termX, termY = term.getSize() 
local cloudDir = "/"
local cloudList = nil
local useCloud = false
local serverAddress = "http://josh/ComputerCraft.php"


function listFiles(aFiles,begin,finish)
	term.setBackgroundColor(josCfg.windowMainColor)	
	term.setTextColor(colors.black) 
	local fileID = {} 
	local x , y = fileDrawBegin , 4	
	
	if useCloud == false then
		for i = begin,finish do
			local fileColor = colors.white
			local fileIcon = nil
			if fs.isDir(aFiles[i]) then
				fileColor = colors.yellow
				fileIcon = jos.loadLabelIcon(josCfg.folderIcon)
			else
				fileColor = colors.white
				if josCfg.fileExtensionIcon[fc.getFileExtension(aFiles[i])] ~= nil then
					fileIcon = jos.loadLabelIcon(josCfg.fileExtensionIcon[fc.getFileExtension(aFiles[i])])
				else
					fileIcon = jos.loadLabelIcon(josCfg.blankIcon)				
				end
			end
			jos.drawLabelCustom(fs.getName(aFiles[i]),x,y,fileColor,colors.lightGray,josCfg.windowMainColor,fileIcon)
			fileID[i] = {x = x , y = y, file = aFiles[i]}	
			if x + 7 + fileDrawEnd >= termX  then 
				y = y + 5
				x = fileDrawBegin
			else
				x = x + 7
			end
			
		end
	else
		for i = begin,finish do
			local fileColor = colors.white
			local fileIcon = nil
			local theName = ""
			if fc.getFileExtension(aFiles[i]) == ".josDir" then
				fileColor = colors.yellow
				fileIcon = jos.loadLabelIcon(josCfg.folderIcon)
				theName = string.sub(aFiles[i],0,-8)
			else
				fileColor = colors.yellow
				theName = fs.getName(aFiles[i])
				if josCfg.fileExtensionIcon[fc.getFileExtension(aFiles[i])] ~= nil then
					fileIcon = jos.loadLabelIcon(josCfg.fileExtensionIcon[fc.getFileExtension(aFiles[i])])
				else
					fileIcon = jos.loadLabelIcon("/usr/icons/blank.pnt")				
				end
			end
			jos.drawLabelCustom(theName,x,y,fileColor,colors.lightGray,josCfg.windowMainColor,fileIcon)
			
			
			fileID[i] = {x = x , y = y, file = aFiles[i]}	
			if x + 7 + fileDrawEnd >= termX  then 
				y = y + 5
				x = fileDrawBegin
			else
				x = x + 7
			end
			
		end
	end
	
	local event, button, xPos, yPos = os.pullEvent("mouse_click")
	--cloudList = cloudGetList()
	if useCloud == false then
		for i =  1, #fileID do
			if event == "mouse_click" and xPos >= fileID[i].x and xPos <= fileID[i].x + 3 and yPos >= fileID[i].y and yPos <= fileID[i].y +4 then
				if button == 1 then
					if fs.isDir(fileID[i].file) then                 
						shell.run("cd /"..fileID[i].file)
						break
					else
						if josCfg.fileExtensions[fc.getFileExtension(fileID[i].file)] ~= nil then
							josMulti.setLastTab(josMulti.getCurrentTab())
							josMulti.changeCurrentTabI(josMulti.newTab(josCfg.fileExtensions[fc.getFileExtension(fileID[i].file)].." /"..fileID[i].file, fs.getName(fileID[i].file)))
							break
						else
							
							josMulti.setLastTab(josMulti.getCurrentTab())
							josMulti.changeCurrentTabI(josMulti.newTab(fileID[i].file,fs.getName(fileID[i].file)))
							break
						end
					end
				elseif button == 2 then
					jos.drawOptionPopUpMenu(xPos,yPos,fileID[i].file)
					break
				end
				break
			end
			if i == #fileID or #fileID == 0 then
				--[[if event == "mouse_click" and button ==2 and xPos > 5 and yPos > 2 then
					jos.drawOptionPopUpMenu(xPos,yPos,shell.dir())
				end
				break--]]
				doRightClickNOF(button,xPos,yPos)
			end
		end
	else	
		for i =  1, #fileID do
			if event == "mouse_click" and xPos >= fileID[i].x and xPos <= fileID[i].x + 3 and yPos >= fileID[i].y and yPos <= fileID[i].y +4 then
				if button == 1 then
					if fc.getFileExtension(fileID[i].file) == ".josDir" then                 
						cloudDir = cloudDir..fc.getFileNameExcludeExt(fileID[i].file).."/"
						break
					else
						if josCfg.fileExtensions[fc.getFileExtension(fileID[i].file)] ~= nil then
							local sData = cloudDownload(cloudDir..fileID[i].file)
							if fs.exists("/tmp/JOS_Cloud/"..fileID[i].file) then
								fs.delete("/tmp/JOS_Cloud/"..fileID[i].file)
							end
							local tFile = fs.open("/tmp/JOS_Cloud/"..fileID[i].file,"w")
							tFile.write(sData)
							tFile.close()  
							useCloud = false
							josMulti.setLastTab(josMulti.getCurrentTab())
							josMulti.changeCurrentTabI(josMulti.newTab( josCfg.fileExtensions[fc.getFileExtension(fileID[i].file)].." /tmp/JOS_Cloud/"..fileID[i].file, fileID[i].file))
							break
						else
							local sData = cloudDownload(cloudDir..fileID[i].file)
							if fs.exists("/tmp/JOS_Cloud/"..fileID[i].file) then
								fs.delete("/tmp/JOS_Cloud/"..fileID[i].file)
							end
							local tFile = fs.open("/tmp/JOS_Cloud/"..fileID[i].file,"w")
							tFile.write(sData)
							tFile.close()  
							useCloud = false
							josMulti.setLastTab(josMulti.getCurrentTab())
							josMulti.changeCurrentTabI(josMulti.newTab("/tmp/JOS_Cloud/"..fileID[i].file,fileID[i].file))	
							break
						end
					end
				elseif button == 2 then
					local answer = jos.drawOptionPopUpMenuCloud(xPos,yPos,fileID[i].file)
					if answer == "open" then --open
						if fc.getFileExtension(fileID[i].file) == ".josDir" then                 
							cloudDir = cloudDir..fc.getFileNameExcludeExt(fileID[i].file).."/"
							break
						end
						local sData = cloudDownload(cloudDir..fileID[i].file)
						if fs.exists("/tmp/JOS_Cloud/"..fileID[i].file) then
							fs.delete("/tmp/JOS_Cloud/"..fileID[i].file)
						end
						local tFile = fs.open("/tmp/JOS_Cloud/"..fileID[i].file,"w")
						tFile.write(sData)
						tFile.close()  
						useCloud = false
						josMulti.setLastTab(josMulti.getCurrentTab())
						josMulti.changeCurrentTabI(josMulti.newTab("/tmp/JOS_Cloud/"..fileID[i].file,fc.getFileName(fileID[i].file)))	
					elseif answer == "copy" then --copy
						if fc.getFileExtension(fileID[i].file) ~= ".josDir" then
							local sData = cloudDownload(cloudDir..fileID[i].file)
							if fs.exists("/tmp/JOS_Cloud/"..fileID[i].file) then
								fs.delete("/tmp/JOS_Cloud/"..fileID[i].file)
							end
							local tFile = fs.open("/tmp/JOS_Cloud/"..fileID[i].file,"w")
							tFile.write(sData)
							tFile.close()  
							if fs.exists("/tmp/clipBoardContents") then
								fs.delete("/tmp/clipBoardContents")
							end
							if fs.exists("/tmp/clipBoardContentsName") then
								fs.delete("/tmp/clipBoardContentsName")
							end
							fs.copy("/tmp/JOS_Cloud/"..fileID[i].file,"/tmp/clipBoardContents")
							local tFile = fs.open("/tmp/clipBoardContentsName","w")
							tFile.write(fs.getName("/tmp/JOS_Cloud/"..fileID[i].file))
							tFile.close()  
						else	
							local tmpCloudPath = cloudDir..fc.getFileNameExcludeExt(fileID[i].file).."/"
							local files = cloudGetListDir(tmpCloudPath)
							clearTmpFile()
							if fs.exists("/tmp/clipBoardContents") then
								fs.delete("/tmp/clipBoardContents")
							end
							cloudCopyFolder(files,tmpCloudPath,tmpCloudPath)
						end
					elseif answer == "cut" then --cut
						if fc.getFileExtension(fileID[i].file) ~= ".josDir" then
							local sData = cloudDownload(cloudDir..fileID[i].file)
							if fs.exists("/tmp/JOS_Cloud/"..fileID[i].file) then
								fs.delete("/tmp/JOS_Cloud/"..fileID[i].file)
							end
							local tFile = fs.open("/tmp/JOS_Cloud/"..fileID[i].file,"w")
							tFile.write(sData)
							tFile.close()  
							if fs.exists("/tmp/clipBoardContents") then
								fs.delete("/tmp/clipBoardContents")
							end
							if fs.exists("/tmp/clipBoardContentsName") then
								fs.delete("/tmp/clipBoardContentsName")
							end
							fs.copy("/tmp/JOS_Cloud/"..fileID[i].file,"/tmp/clipBoardContents")
							local tFile = fs.open("/tmp/clipBoardContentsName","w")
							tFile.write(fs.getName("/tmp/JOS_Cloud/"..fileID[i].file))
							tFile.close()  
							http.post(serverAddress,"password=wesfzxc&command=delete&name="..textutils.urlEncode(cloudDir)..textutils.urlEncode(fileID[i].file))
						end
					elseif answer == "paste" then --paste
						local tFile = fs.open("/tmp/clipBoardContentsName","r")
						cloudUpload("/tmp/clipBoardContents",tFile.readAll(),false)
						tFile.close()
					elseif answer == "delete" then
						if jos.showConfirmation("Are you sure","delete "..fileID[i].file.."?") == "yes" then
							if fc.getFileExtension(fileID[i].file) == ".josDir" then
								http.post(serverAddress,"password=wesfzxc&command=rmDir&name="..textutils.urlEncode(cloudDir)..textutils.urlEncode(fc.getFileNameExcludeExt(fileID[i].file)))
							else
								http.post(serverAddress,"password=wesfzxc&command=delete&name="..textutils.urlEncode(cloudDir)..textutils.urlEncode(fileID[i].file))
							end
						end
					elseif answer == "edit" then --edit
						local sData = cloudDownload(cloudDir..fileID[i].file)
						if fs.exists("/tmp/JOS_Cloud/"..fileID[i].file) then
							fs.delete("/tmp/JOS_Cloud/"..fileID[i].file)
						end
						local tFile = fs.open("/tmp/JOS_Cloud/"..fileID[i].file,"w")
						tFile.write(sData)
						tFile.close()  
						--useCloud = false
						--josMulti.changeCurrentTabI(josMulti.newTab(josCfg.defualtEditProgram.." /tmp/JOS_Cloud/"..fileID[i].file,fc.getFileName(fileID[i].file)))
						shell.run(josCfg.defualtEditProgram.." /tmp/JOS_Cloud/"..fileID[i].file)
						local tFile = fs.open("/tmp/JOS_Cloud/"..fileID[i].file,"r")
						print(cloudUpload("/tmp/JOS_Cloud/"..fileID[i].file,fileID[i].file,true))
						tFile.close()
					elseif answer == "rename" then --rename
						http.post(serverAddress,"password=wesfzxc&command=rename&name="..textutils.urlEncode(cloudDir..fileID[i].file).."&newName="..textutils.urlEncode(cloudDir..jos.drawInputDialog("Rename","Enter new name",fileID[i].file)))
					elseif answer == "createFile" then
						http.post(serverAddress,"password=wesfzxc&command=upload&name="..textutils.urlEncode(cloudDir)..textutils.urlEncode(jos.drawInputDialog("Name","Enter the name ","")).."&content= ")
					elseif answer == "createFolder" then
						http.post(serverAddress,"password=wesfzxc&command=mkDir&name="..textutils.urlEncode(cloudDir)..textutils.urlEncode(jos.drawInputDialog("Name","Enter the name ","")).."&content= ")
					end
					break
				end
				break
			end
			if i == #fileID then
				doRightClickNOF(button,xPos,yPos)
			end
		end
		if #fileID == 0 then
			doRightClickNOF(button,xPos,yPos)
		end
	end	
	if event == "mouse_click" and xPos >= 1 and xPos <= 4 and yPos == 2 then
		jos.drawCustomPopup(1,3,{"new File","new Folder","settings"})
	elseif event == "mouse_click" and xPos >= 2 and xPos <= 3 and yPos == 4 then	
		if useCloud then
			cloudReturnDir = cloudDir
			cloudDir = fc.cutPath(cloudDir:sub(1,#cloudDir-1),"/")
			if cloudDir == nil then
				cloudDir = "/"
			end
		else
			returnDir = "/"..shell.dir()
			shell.run("cd ..")
		end
	elseif event == "mouse_click" and xPos >= 2 and xPos <= 3 and yPos == 6 then		
		if useCloud then
			if cloudReturnDir ~= "" then
				cloudDir = cloudReturnDir
			end
		else
			if returnDir ~= "" then
				shell.run("cd "..returnDir)	
			end
		end
	elseif event == "mouse_click" and xPos >= 2 and xPos <= 3 and yPos == 8 then	
		if useCloud then
			cloudDir = "/"
		else
			returnDir = "/"..shell.dir()
			shell.run("cd /")
		end
	elseif event == "mouse_click" and xPos >= 2 and xPos <= 3 and yPos == 10 then
		returnDir = "/"..shell.dir()
		shell.run("cd /home/"..josCfg.userName)
		if useCloud then
			return "terminate"
		end
	elseif event == "mouse_click" and xPos >= 2 and xPos <= 3 and yPos == 12 then
		--cloudMain()
		if useCloud then
			return "terminate"
		else
			useCloud = true
		end
	end
end

function doRightClickNOF(button,xPos,yPos) -- NotClickOnFile.. if the user right clicks not on a file or folder but on empty space this gets run 
	if  button ==2 and xPos > 5 and yPos > 2 then
		if useCloud then
			local sList = {"paste","make file","make folder"}
			local sResponse = jos.drawCustomPopup(xPos,yPos,sList)
			if sResponse == "paste" then
				local tFile = fs.open("/tmp/clipBoardContentsName","r")
				cloudUpload("/tmp/clipBoardContents",tFile.readAll(),false)
				tFile.close()
			elseif sResponse == "make file" then
				http.post(serverAddress,"password=wesfzxc&command=upload&name="..textutils.urlEncode(cloudDir..jos.drawInputDialog("Name","Enter the name ","")).."&content= ")
			elseif sResponse == "make folder" then
				http.post(serverAddress,"password=wesfzxc&command=mkDir&name="..textutils.urlEncode(cloudDir..jos.drawInputDialog("Name","Enter the name ","")).."&content= ")
			end
		else
			local sList = {"paste","open terminal here","make file","make folder"}
			local sResponse = jos.drawCustomPopup(xPos,yPos,sList)
			if sResponse == "paste" then
				local tFile = fs.open("/tmp/clipBoardContentsName","r")
				fs.copy("/tmp/clipBoardContents",shell.dir().."/"..tFile.readAll())
				tFile.close()
			elseif sResponse == "open terminal here" then
				josMulti.changeCurrentTabI(josMulti.newTab("cd ","shell",shell.dir()))
			elseif sResponse == "make file" then
				
			elseif sResponse == "make folder" then
				
			end
		end
	end
end

function cloudCopyFolder(files,startFolder,path)
	for i = 1,#files,1 do
		if fc.getFileExtension(files[i]) == ".josDir" then
			local aFiles = cloudGetListDir(path..fc.getFileNameExcludeExt(files[i]))
			cloudCopyFolder(aFiles,startFolder,path..fc.getFileNameExcludeExt(files[i]).."/")
		else
			pathA = path:gsub(startFolder:sub(1,-2),"")
			local sData = cloudDownload(path.."/"..files[i])
			local tFile = fs.open("/tmp/JOS_Cloud/"..files[i],"w")
			tFile.write(sData)
			tFile.close()  
			fs.copy("/tmp/JOS_Cloud/"..files[i],"/tmp/clipBoardContents"..pathA..files[i])
			if fs.exists("/tmp/clipBoardContentsName") then
				fs.delete("/tmp/clipBoardContentsName")
			end
			local aFile = fs.open("/tmp/clipBoardContentsName","w")
			aFile.write(fc.getPath(startFolder:sub(1,-2),"/"))
			aFile.close()
		end
	end
end

function cloudCopyFolderFinish()
	
end

function main ()
	local files = {}
	while true do 		
		if useCloud == false then
			term.clear()
			local FileList = fs.list(shell.dir())
			for i, file in ipairs(FileList) do
				files[i] = shell.dir().."/"..file 
			end	
			jos.drawWindow(1,52,1,19,"/"..shell.dir())
			term.setCursorPos(2,4)
			term.setBackgroundColor(colors.green)
			write("<-")
			term.setCursorPos(2,6)
			write("->")
			term.setCursorPos(2,8)
			write(" /")
			term.setCursorPos(2,10)
			write(" "..string.sub(josCfg.userName,1,1))
			term.setCursorPos(2,12)
			write("jC")
			jos.drawRectangle(5,3,0,termY-2,colors.lightGray)
			jos.drawRectangle(1,2,termX-1,0,colors.lightGray)
			term.setCursorPos(1,2)
			write("file")
			write("  ")
			write("edit")
			write("  ")
			write("search")
			local x
			if table.getn(files) > 18 then
				x = table.getn(files) -18
			else
				x = 0
			end
			if listFiles(files,1,table.getn(files)-x) == "terminate" then
				break
			end
			files = {}
		else
			term.clear()
			jos.drawWindow(1,52,1,19,"josCloud:/"..cloudDir)
			term.setCursorPos(2,4)
			term.setBackgroundColor(colors.green)
			write("<-")
			term.setCursorPos(2,6)
			write("->")
			term.setCursorPos(2,8)
			write(" /")
			term.setCursorPos(2,10)
			write(" "..string.sub(josCfg.userName,1,1))
			term.setCursorPos(2,12)
			write("jC")
			jos.drawRectangle(5,3,0,termY-2,colors.lightGray)
			jos.drawRectangle(1,2,termX-1,0,colors.lightGray)
			term.setCursorPos(1,2)
			write("file")
			write("  ")
			write("edit")
			write("  ")
			write("search")
			cloudList = cloudGetList()
			if listFiles(cloudList,1,#cloudList) == "terminate" then
				useCloud = false
			end
		end		
	end
end

function cloudMain()
	while false do
		jos.drawWindow(1,52,1,19,"cloud")
		jos.drawButton(3,3,"upload",colors.black,colors.green)
		jos.drawButton(3,7,"download",colors.black,colors.green)
		evnt = {os.pullEvent("mouse_click")}
		if evnt[2] == 1 and evnt[3] >= 3 and evnt[3] <= #"upload" + 2 + 2 and evnt[4] >= 3 and evnt[4] < 3+3 then
			cloudUpload()
		elseif evnt[2] == 1 and evnt[3] >= 3 and evnt[3] <= #"download" + 2 + 2 and evnt[4] >= 7 and evnt[4] < 7+3 then
			
		end
	end
	
	while false do 
		term.clear()
		jos.drawWindow(1,52,1,19,"/"..shell.dir())
		term.setCursorPos(2,4)
		term.setBackgroundColor(colors.green)
		write("<-")
		term.setCursorPos(2,6)
		write("->")
		term.setCursorPos(2,8)
		write(" /")
		term.setCursorPos(2,10)
		write(" "..string.sub(josCfg.userName,1,1))
		term.setCursorPos(2,12)
		write("jC")
		jos.drawRectangle(5,3,0,termY-2,colors.lightGray)
		jos.drawRectangle(1,2,termX-1,0,colors.lightGray)
		term.setCursorPos(1,2)
		write("file")
		write("  ")
		write("edit")
		write("  ")
		write("search")
		dList = cloudGetList()
		if listFiles(dList,1,#dList) == "terminate" then
			break
		end
		files = {}
		
	end
end

function cloudUpload(dir,name,overWrite)
	if fs.exists(dir) then
		local myFile = fs.open(dir,"r")
		local myFileContents = myFile.readAll()
		myFile.close()
		if overWrite then
			local response = http.post(serverAddress,"password=wesfzxc&command=upload&overWrite=true&name="..textutils.urlEncode(cloudDir..name).."&content="..textutils.urlEncode(myFileContents))
		else
			local response = http.post(serverAddress,"password=wesfzxc&command=upload&name="..textutils.urlEncode(cloudDir)..textutils.urlEncode(name).."&content="..textutils.urlEncode(myFileContents))
		end
		if response then
			local sResponse = response.readAll()
			response.close()	
			return sResponse 
		else
			return "Failed"
		end
	else
		return "file not found"
	end
end

function cloudGetList()
	response = http.post(serverAddress,"password=wesfzxc&command=getList&name="..textutils.urlEncode(cloudDir))
	local dLists = fc.split(response.readAll(),"\n")
	return dLists

end

function cloudGetListDir(dir)
	response = http.post(serverAddress,"password=wesfzxc&command=getList&name="..textutils.urlEncode(dir))
	local dLists = fc.split(response.readAll(),"\n")
	return dLists

end

function cloudDownload(name)
	return http.post(serverAddress,"password=wesfzxc&command=download&name="..textutils.urlEncode(name)).readAll()
end

function clearTmpFile()
	shell.run("delete /tmp/JOS_Cloud/")
	fs.makeDir("/tmp/JOS_Cloud/")
end

--shell.run("cd "..startDir) --Too set default start director
if args[1] ~= null then
	if fs.isDir(args[1]) then
		shell.run("cd " ..args[1])
	end
end

--cloudList = cloudGetList()
clearTmpFile()
main()
