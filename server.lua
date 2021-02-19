local PlayerScales = {}

RegisterNetEvent('scalesync:init')

function SetScale(player, scale)
	if scale then
		if scale < Config.MinScale then
			scale = Config.MinScale
		elseif scale > Config.MaxScale then
			scale = Config.MaxScale
		end

		if PlayerScales[player] ~= scale then
			PlayerScales[player] = scale
			TriggerClientEvent('scalesync:setScale', -1, player, scale)
		end
	else
		if PlayerScales[player] then
			PlayerScales[player] = nil
			TriggerClientEvent('scalesync:resetScale', -1, player)
		end
	end
end

RegisterCommand('scale', function(source, args, raw)
	SetScale(source, tonumber(args[1]))
end, true)

function GetPlayerId(id)
	local players = GetPlayers()

	for _, playerId in ipairs(players) do
		if playerId == id then
			return tonumber(playerId)
		end
	end

	id = string.lower(id)
	for _, playerId in ipairs(players) do
		local playerName = string.lower(GetPlayerName(playerId))
		if playerName == id then
			return tonumber(playerId)
		end
	end

	return nil
end

RegisterCommand('setscale', function(source, args, raw)
	local player = args[1]
	local scale = tonumber(args[2])
	local id = GetPlayerId(player)

	SetScale(id, scale)
end, true)

RegisterCommand('scales', function(source, args, raw)
	for player, scale in pairs(PlayerScales) do
		print(player, scale)
	end
end, true)

AddEventHandler('playerDropped', function(reason)
	PlayerScales[source] = nil
	TriggerClientEvent('scalesync:resetScale', -1, source)
end)

AddEventHandler('scalesync:init', function()
	TriggerClientEvent('scalesync:updateScales', source, PlayerScales)
end)
