local wallpaper = nil
local fileUIList = nil
local mainPanel = nil
local startPopup = nil
local tabsList = nil

function main()
	local screen = renderer.newScreen(51,19)
	local renderer = renderer.new(screen)
	while true do
		term.setCursorBlink(false)
		renderer:clear(colors.black)
		mainPanel:render(renderer)
		renderer:flush()
		mainPanel:update({os.pullEvent()})
	end
end

function init()
	local termWidth = nil
	local termHeight = nil
	termWidth, termHeight = term.getSize()
	local leftClick = function(self)
		if fs.isDir(self.value) then
			josMulti.changeCurrentTabI(josMulti.newTab("/usr/bin/guiExplorer.lua "..self.value,"explorer"))
		else
			josMulti.changeCurrentTabI(josMulti.newTab(self.value,fs.getName(self.value)))
		end
		
	end
	
	local startClick = function(self)
		if startPopup.enabled then
			startPopup.enabled = false
		else
			startPopup.enabled = true
		end
	end
	
	local function popupClicked(value)
		local index = 0
		for i = 1,#josCfg.startMenuItems do
			if josCfg.startMenuItems[i] == value.name then
				index = i
				break
			end
		end

		local command = josCfg.startMenuExec[index]
		if fs.isDir(command) then
			josMulti.changeCurrentTabI(josMulti.newTab("/usr/bin/guiExplorer.lua "..command,"explorer"))
		else
			josMulti.changeCurrentTabI(josMulti.newTab(command,value.name))
		
		end
	end
	
	mainPanel = josuiu.newPanel("main")

	wallpaper = josuiu.newImage("background",josUsers.currentUser.wallpaper,1,1)
	wallpaper.orgUpdate = wallpaper.update
	wallpaper.update = function(self,event)
		self:orgUpdate(event)
		if self.imageDir ~= josUsers.currentUser.wallpaper then
			self.image = paintutils.loadImage(josUsers.currentUser.wallpaper)
			self.imageDir = josUsers.currentUser.wallpaper
		end

	end

	fileUIList = josuiu.newFileList("files",josCfg.desktopDirectory,2,2,7*7,6*3,leftClick,function() end)
	fileUIList.alwaysUpdate = false
	startPopup = josuiu.newPopupList("start",1,19-#josCfg.startMenuItems,josCfg.startMenuItems,function(self) popupClicked(self) end)
	startPopup.hover = false;
	startPopup.enabled = false
	startBtn = josuiu.newButton("jos",startClick,1,19,4,1,colors.green)
	tabsList = josuiu.newTabList("tabs",5,19,termWidth-5,1,josMulti.tabs)
	local theTime = josuiu.newLabel(textutils.formatTime(os.time(), false),termWidth-7,19,colors.blue)
	theTime.update = function(self,event)
		self.name = textutils.formatTime(os.time(), false)
	end
	mainPanel:addUI(wallpaper)
	mainPanel:addUI(fileUIList)
	mainPanel:addUI(josuiu.newRect("taskbar",1,19,51,1,colors.blue))
	mainPanel:addUI(theTime)
	mainPanel:addUI(tabsList)
	mainPanel:addUI(startBtn)
	mainPanel:addUI(startPopup)
end

init()
main()