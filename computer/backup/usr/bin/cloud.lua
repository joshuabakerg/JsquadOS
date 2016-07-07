
function cloudMain()
	while true do
		jos.drawWindow(1,52,1,19,"cloud")
		jos.drawButton(3,3,"upload",colors.black,colors.green)
		jos.drawButton(3,7,"download",colors.black,colors.green)
		evnt = {os.pullEvent("mouse_click")}
		if evnt[2] == 1 and evnt[3] >= 3 and evnt[3] <= #"upload" + 2 + 2 and evnt[4] >= 3 and evnt[4] < 3+3 then
			cloudUpload()
		elseif evnt[2] == 1 and evnt[3] >= 3 and evnt[3] <= #"download" + 2 + 2 and evnt[4] >= 7 and evnt[4] < 7+3 then
			cloudDownload()
		end
	end
end

function cloudUpload()

	local uFile = jos.drawInputDialog("Upload","please enter file to upload","")
	if fs.exists(uFile) then
		local myFile = fs.open(uFile,"r")
		local myFileContents = myFile.readAll()
		myFile.close()
		local response = http.post("http://10.0.0.21/ComputerCraft.php","password=wesfzxc&command=upload&name="..textutils.urlEncode(fs.getName(uFile)).."&content="..textutils.urlEncode(myFileContents))
		if response then
			local sResponse = response.readAll()
			response.close()	
			jos.showMessage(sResponse )
		else
			jos.showMessage("Failed." )
		end
	else
		print("file not found")
		sleep(2)
		jos.showMessage("file not found")
	end
end

function cloudDownload()
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	term.clear()
	jos.drawWindow(1,52,1,19,"lists")
	response = http.post("http://10.0.0.21/ComputerCraft.php","password=wesfzxc&command=getList")
	dList = fc.split(response.readAll(),"\n")
	for i = 1 ,#dList,1 do
		jos.drawButton(3,3 *i + (i-1),dList[i],colors.magenta,colors.purple)
	end
	os.pullEvent("mouse_click")
	

end

cloudMain();
