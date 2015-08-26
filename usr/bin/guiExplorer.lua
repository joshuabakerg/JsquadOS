function main ()
	while true do 
		jos.drawWindow(5,35,3,16,shell.dir())
		local event, button, xPos, yPos = os.pullEvent("mouse_click")
		break
	end
end

shell.run("cd /")
main()
