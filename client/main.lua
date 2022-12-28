ESX                         = nil
inMenu                      = true
local atbank = false
local bankMenu = true

local keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

if bankMenu then
	Citizen.CreateThread(function()
		while true do
			Wait(0)
			if nearBank() or nearATM() then
					DisplayHelpText("Drücke E um die Bank zu benutzen")

				if IsControlJustPressed(1, keys[Config.Keys.Open]) then

					SetDisplay(not Display)
					TriggerServerEvent('banking:balance')
					local ped = GetPlayerPed(-1)
				end
			end

			if IsControlJustPressed(1, keys[Config.Keys.Close]) then
				if nearBank() or nearATM() then
					closeUI()
				end
			end
		end
	end)
end


--BANK
Citizen.CreateThread(function()
	if Config.ShowBlips then
	  for k,v in ipairs(Config.Bank)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, v.id)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Bank")
		EndTextCommandSetBlipName(blip)
	  end
	end
end)

--ATM
Citizen.CreateThread(function()
	if Config.ShowBlips and Config.OnlyBank == false then
	  for k,v in ipairs(Config.ATM)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, v.id)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("ATM")
		EndTextCommandSetBlipName(blip)
	  end
	end
end)


RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(fullcash, balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)

	SendNUIMessage({
		type = "balanceHUD",
        fullcash = fullcash,
		balance = balance,
	})
end)

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('banking:deposit', tonumber(data.amount))
	TriggerServerEvent('banking:balance')
end)

RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('banking:withdraw', tonumber(data.amountw))
	TriggerServerEvent('banking:balance')
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('banking:transfer', tonumber(data.amountt), tonumber(data.target))
	TriggerServerEvent('banking:balance')
end)

RegisterNUICallback('balance', function()
	TriggerServerEvent('banking:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('banking:transfer', data.to, data.amountt)
	TriggerServerEvent('banking:balance')
end)

RegisterNetEvent('banking:result')
AddEventHandler('banking:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

RegisterNUICallback('exit', function()
    SetDisplay(false)
    closeUI()
end)

function nearBank()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)

	for _, search in pairs(Config.Bank) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

		if distance <= 3 then
			return true
		end
	end
end

function nearATM()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)

	for _, search in pairs(Config.ATM) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

		if distance <= 2 then
			return true
		end
	end
end

function closeUI()
	inMenu = false
	if Config.Animation.Active then 
		playAnim('mp_common', 'givetake1_a', Config.Animation.Time)
		Citizen.Wait(Config.Animation.Time)
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function SetDisplay(bool)
    if bool then
        if Config.Animation.Active then 
            playAnim('mp_common', 'givetake1_a', Config.Animation.Time)
            Citizen.Wait(Config.Animation.Time)
        end
    end
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
    TriggerServerEvent('banking:balance')
end