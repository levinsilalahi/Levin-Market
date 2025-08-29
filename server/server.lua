ESX = exports['es_extended']:getSharedObject()

local ox_inventory = exports.ox_inventory

local stashes = {
    {
		-- market stash
		id = CfgLevinMarket.Stash.idStash,
		label = CfgLevinMarket.Stash.labelStash,
		slots = CfgLevinMarket.Stash.slotsStash,
		weight = CfgLevinMarket.Stash.weightStash,
		owner = CfgLevinMarket.Stash.ownerStash,
		jobs = CfgLevinMarket.Stash.jobsStash,
	}
}

-- Register Stash Ox-iventory untuk market
AddEventHandler('onServerResourceStart', function(resourceName)
    local GetCurrentResourceName = GetCurrentResourceName()
	if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
		for i=1, #stashes do
			local stash = stashes[i]
			ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner, stash.jobs)
		end
	end
end)

-- dapatkan stok item di stash
lib.callback.register('cekjumlahitemyangadadimarket', function(fllwme, item)
    local jumlahitem = item
    local stashmarket = exports.ox_inventory:GetItemCount('market_stash', item)
    if stashmarket then
        jumlahitem = stashmarket
    end
    return jumlahitem
end)

function MembacaMarket(data)
    if data.jual then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_market', function(account)
            if account then
                account.removeMoney(data.price)
            end
        end)
    elseif data.beli then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_market', function(account)
            if account then
                account.addMoney(data.price)
            end
        end)
    end
end

RegisterNetEvent('levin-market:server:jualbarang', function(item, jumlah, harga)
    local fllwme = source
    local GetItemCount = exports.ox_inventory:GetItemCount(CfgLevinMarket.Stash.idStash, item)
    local MaxItemDiStash = CfgLevinMarket.Stash.slotsStash - GetItemCount
    if MaxItemDiStash >= jumlah then -- jika masih ada slot
        local HashItem = exports.ox_inventory:Search(fllwme, 'count', item)
        if HashItem >= jumlah then -- jika pemain memiliki cukup item
            local totalHarga = harga * jumlah
            exports.ox_inventory:RemoveItem(fllwme, item, jumlah)
            exports.ox_inventory:AddItem(CfgLevinMarket.Stash.idStash, item, jumlah)
            exports.ox_inventory:AddItem(fllwme, 'money', totalHarga)
            MembacaMarket({jual = true, price = totalHarga})
            MarketLogs({jual = true, id = fllwme, item = item, jumlah = jumlah, totalharga = totalHarga})
            TriggerClientEvent('levin-market:client:Notif', fllwme, 'Anda telah menjual ' .. jumlah .. ' ' .. item .. ' seharga $' .. totalHarga)
        else
            TriggerClientEvent('levin-market:client:Notif', fllwme, 'Anda tidak memiliki cukup barang untuk dijual.')
        end
    else
        TriggerClientEvent('levin-market:client:Notif', fllwme, 'Stash market penuh, silahkan hubungi admin.')
    end
end)

RegisterNetEvent('levin-market:server:beliBarang', function(item, jumlah, harga)
    local fllwme = source
    local totalHarga = harga * jumlah
    local HashItem = exports.ox_inventory:Search(fllwme, 'count', 'money')
    if HashItem >= totalHarga then -- jika pemain memiliki cukup uang
        local GetItemCount = exports.ox_inventory:GetItemCount(CfgLevinMarket.Stash.idStash, item)
        if GetItemCount >= jumlah then -- jika stash market memiliki cukup item
            exports.ox_inventory:RemoveItem(CfgLevinMarket.Stash.idStash, item, jumlah)
            exports.ox_inventory:AddItem(fllwme, item, jumlah)
            exports.ox_inventory:RemoveItem(fllwme, 'money', totalHarga)
            MembacaMarket({beli = true, price = totalHarga})
            MarketLogs({beli = true, id = fllwme, item = item, jumlah = jumlah, totalharga = totalHarga})
            TriggerClientEvent('levin-market:client:Notif', fllwme, 'Anda telah membeli ' .. jumlah .. ' ' .. item .. ' seharga $' .. totalHarga)
        else
            TriggerClientEvent('levin-market:client:Notif', fllwme, 'Stash market tidak memiliki cukup barang.')
        end
    else
        TriggerClientEvent('levin-market:client:Notif', fllwme, 'Anda tidak memiliki cukup uang untuk membeli barang tersebut.')
    end
end)

function GetPlayerJob(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        return xPlayer.job.name .. " - " .. xPlayer.job.grade_name
    else
        return "Unknown"
    end
end

-- dapatkan nama player
function PlayerName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        return xPlayer.getName()
    else
        return "Unknown"
    end
end

function GetPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        return xPlayer.identifier
    else
        return "Unknown"
    end
end

function MarketLogs(data)
    if data.beli then
        local embed = {
            {
                ["color"] = 15158332,
                ["title"] = "# Levin Market | Logs Pembelian",
                ["description"] = "```Name: " .. PlayerName(data.id) .. "\nSteamID: " .. GetPlayerIdentifier(data.id) .. "\nJob: " .. GetPlayerJob(data.id) .. "\nItem: " .. data.item .. "\nJumlah: " .. data.jumlah .. "\nTotal Harga: $" .. data.totalharga .. "```",
                ["footer"] = {
                    ["text"] = "Levin Market",
                    ["icon_url"] = CfgLevinMarket.Logs.logoImg,
                },
            }
        }
        PerformHttpRequest(CfgLevinMarket.Logs.webhookBeli, function(err, text, headers) end, 'POST', json.encode({username = CfgLevinMarket.Logs.username, embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif data.jual then
        local embed = {
            {
                ["color"] = 3066993,
                ["title"] = "# Levin Market | Logs Penjualan",
                ["description"] = "```Name: " .. PlayerName(data.id) .. "\nSteamID: " .. GetPlayerIdentifier(data.id) .. "\nJob: " .. GetPlayerJob(data.id) .. "\nItem: " .. data.item .. "\nJumlah: " .. data.jumlah .. "\nTotal Harga: $" .. data.totalharga .. "```",
                ["footer"] = {
                    ["text"] = "Levin Market",
                    ["icon_url"] = CfgLevinMarket.Logs.logoImg,
                },
            }
        }
        PerformHttpRequest(CfgLevinMarket.Logs.webhookJual, function(err, text, headers) end, 'POST', json.encode({username = CfgLevinMarket.Logs.username, embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
end