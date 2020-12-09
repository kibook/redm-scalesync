local PlayerScales = {}

RegisterNetEvent('scalesync:updateScales')
RegisterNetEvent('scalesync:setScale')
RegisterNetEvent('scalesync:resetScale')

AddEventHandler('scalesync:updateScales', function(scales)
	PlayerScales = scales
end)

AddEventHandler('scalesync:setScale', function(player, scale)
	PlayerScales[player] = scale
end)

function SetScale(player, scale)
	SetPedScale(GetPlayerPed(GetPlayerFromServerId(player)), scale)
end

AddEventHandler('scalesync:resetScale', function(player)
	PlayerScales[player] = nil
	SetScale(player, 1.0)
end)

AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		SetPedScale(PlayerPedId(), 1.0)
	end
end)

CreateThread(function()
	TriggerServerEvent('scalesync:init')

	while true do
		Wait(100)
		for player, scale in pairs(PlayerScales) do
			SetScale(player, scale)
		end
	end
end)
