local module = {}

function module.openGate()
	local gate = workspace.Game.InvisWall.InvisibleWall
	gate.CanCollide = false
end

function module.closeGate()
	local gate = workspace.Game.InvisWall.InvisibleWall
	gate.CanCollide = true
end

function module.respawnAllPlayers()
	local Players = game:GetService("Players")
	
	for _, player in pairs(Players:GetPlayers()) do
		player:LoadCharacter()
	end
end

function module.clearMap()
	local children = workspace.Game.CurrentLoadedMap:GetChildren()
	for _, child in pairs(children) do
		child:Destroy()
	end
end

function module.loadMap(mapName)
	local ServerStorage = script.Parent
	local maps = ServerStorage.Maps
	local desiredMap = maps:FindFirstChild(mapName)
	
	if desiredMap then
		local mapClone = desiredMap:Clone()
		mapClone.Parent = workspace.Game.CurrentLoadedMap
	else
		warn("Could not find map: "..mapName)
		return false
	end
end

function module.startVote(mapList)
	local list = ""

	for _, map in pairs(mapList) do
		list = list .. " " .. map.Name
	end

	local message = Instance.new("Message", workspace)
	message.Name = "VoteMessage"
	message.Text = "Vote for a new map using !vote <mapName>! Options:"..list
end

return module