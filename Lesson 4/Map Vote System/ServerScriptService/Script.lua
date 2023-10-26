-- Services
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- Variables
local maps = ServerStorage.Maps
local mapList = maps:GetChildren()
local module = require(ServerStorage.GameFunctions)

-- Control variables
local isVoting = false
local votes = {}
local plrsWhoHaveVoted = {}

-- Setup the votes table
for _, child in pairs(mapList) do
	votes[string.lower(child.Name)] = 0
end

-- Events
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		local split = string.split(string.lower(message), " ")
		
		if split[1] and split[1] == "!vote" and isVoting == true then
			local hasPlrVoted = table.find(plrsWhoHaveVoted, player)
			if hasPlrVoted then return end
			
			local desiredMap = string.lower(
				string.sub(
					message,
					7,
					string.len(message)
				)
			)
			
			if desiredMap and votes[desiredMap] then
				votes[desiredMap] += 1
				table.insert(plrsWhoHaveVoted, player)
				return
			end
		end
	end)
end)

-- Game loop

while task.wait() do
	for map, _ in pairs(votes) do
		votes[map] = 0
	end
	table.clear(plrsWhoHaveVoted)
	
	isVoting = true
	local voteCast = false
	
	module.closeGate()
	module.respawnAllPlayers()
	module.clearMap()
	module.startVote(mapList)
	
	repeat
		for _, voteCount in pairs(votes) do
			if voteCount >= 1 then
				voteCast = true
			end
		end
		task.wait(1)
	until voteCast == true 
	
	task.wait(10)
	
	for _, v in pairs(workspace:GetChildren()) do
		if v.Name == "VoteMessage" then
			v:Destroy()
		end
	end
	
	isVoting = false
	
	local bestMap = nil
	local bestVote = 0
	
	for map, voteCount in pairs(votes) do
		if voteCount > bestVote then
			bestMap = map
			bestVote = voteCount
		end
	end
	
	local actualMapName = nil
	
	for _, child in pairs(mapList) do
		if string.lower(child.Name) == bestMap then
			actualMapName = child.Name
		end 
	end
	
	local mapLoaded = module.loadMap(actualMapName)
	
	if mapLoaded == false then
		error("Game loop failed! (A map failed to load)")
	end
	
	module.openGate()
	
	task.wait(60)
end