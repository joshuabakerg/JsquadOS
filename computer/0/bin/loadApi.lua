
local FileList = fs.list("/etc")
for i, file in ipairs(FileList) do
	os.loadAPI("/etc/"..file)
	print("/etc/"..file)
end

local FileList = fs.list("/bin/api")
for i, file in ipairs(FileList) do
	os.loadAPI("/bin/api/"..file)
	print("/bin/api/"..file)
end

