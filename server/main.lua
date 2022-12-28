ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('banking:deposit')
AddEventHandler('banking:deposit', function(amount)
    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)
    if amount == nil or amount <= 0 then
        TriggerClientEvent('chatMessage', _source, "Ungültige Anzahl")
    else
        if amount > xPlayer.getMoney() then
            amount = xPlayer.getMoney()
        end
        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', tonumber(amount))
    end
end)

RegisterServerEvent('banking:withdraw')
AddEventHandler('banking:withdraw', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local base = 0
    amount = tonumber(amount)
    base = xPlayer.getAccount('bank').money
    if amount == nil or amount <= 0 then
        TriggerClientEvent('chatMessage', _source, "Ungültige Anzahl")
    else
        if amount > base then
            amount = base
        end
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
    end
end)

RegisterServerEvent('banking:balance')
AddEventHandler('banking:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    fullcash = xPlayer.getMoney()
    balance = xPlayer.getAccount('bank').money
    TriggerClientEvent('currentbalance1', _source, fullcash, balance)

end)

RegisterServerEvent('banking:transfer')
AddEventHandler('banking:transfer', function(amountt, to)
    print("test")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    if zPlayer ~= nil and GetPlayerEndpoint(to) ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('notifications', _source, "#fffff", "Bank", "Du kannst dir selber kein Geld senden!")
        else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source, "Bank", "Du hast nicht genug Geld")
            else
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source, "Bank", "Du hast das Geld erfolgreich überwiesen")
                TriggerClientEvent('esx:showAdvancedNotification', to, "Bank", "Dir wurde Geld überwiesen")
            end

        end
    end

end)