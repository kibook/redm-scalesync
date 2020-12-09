local PlayerScales = {}

RegisterNetEvent('scalesync:init')

function SetScale(player, scale)
	if scale < Config.MinScale then
		scale = Config.MinScale
	end
	if scale > Config.MaxScale then
		scale = Config.MaxScale
	end

	if scale == 1.0 then
		if PlayerScales[player] then
			PlayerScales[player] = nil
			TriggerClientEvent('scalesync:resetScale', -1, player)
		end
	elseif PlayerScales[player] ~= scale then
		PlayerScales[player] = scale
		TriggerClientEvent('scalesync:setScale', -1, player, scale)
	end
end

RegisterCommand('scale', function(source, args, raw)
	local scale = (args[1] and tonumber(args[1]) * 1.0 or 1.0)

	SetScale(source, scale)
end, false)

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
	local scale = tonumber(args[2]) * 1.0
	local id = GetPlayerId(player)

	SetScale(id, scale)
end, true)

RegisterCommand('scales', function(source, args, raw)
	for player, scale in pairs(PlayerScales) do
		TriggerClientEvent('chat:addMessage', source, {
			args = {player, scale}
		})
	end
end, true)

AddEventHandler('playerDropped', function(reason)
	PlayerScales[source] = nil
	TriggerClientEvent('scalesync:resetScale', -1, source)
end)

AddEventHandler('scalesync:init', function()
	TriggerClientEvent('scalesync:updateScales', source, PlayerScales)
end)
