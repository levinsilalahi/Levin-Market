ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('levin-market:client:Notif', function(msg, type)
    ESX.ShowNotification(msg, type)
end)

function ItemImage(itemName)
    local img = "nui://"..CfgLevinMarket.Image..itemName..".png"
    return img
end

-- Fungsi untuk mendapatkan jumlah item dari stash market
function GetItemCount(jumlahitemname)
    local jumlahitem = jumlahitemname
    local stashmarket = lib.callback.await('cekjumlahitemyangadadimarket', false, jumlahitem)
    return stashmarket
end

-- blip market
CreateThread(function()
    if CfgLevinMarket.Blip.enable then
        local blip = AddBlipForCoord(CfgLevinMarket.Blip.coord.x, CfgLevinMarket.Blip.coord.y, CfgLevinMarket.Blip.coord.z)
        SetBlipSprite(blip, CfgLevinMarket.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, CfgLevinMarket.Blip.scale)
        SetBlipColour(blip, CfgLevinMarket.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(CfgLevinMarket.Blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- pedspawn
CreateThread(function()
    for k, v in pairs(CfgLevinMarket.Market) do
        local pedModel = GetHashKey(v["pedhash"])
        local coords = v["coordped"]
        local heading = v["headingped"]
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(500)
        end
        local ped = CreatePed(4, pedModel, coords.x, coords.y, coords.z-1, heading, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'levin-market:openmenu',
                icon = 'fas fa-shopping-basket',
                label = 'Market ' .. k,
                onSelect = function()
                    TriggerEvent('levin-market:client:OpenMenuMarket', k)
                end,
                distance = 2.5
            }
        })
    end
end)

function MenuPenjualan(jenis)
    for k, v in pairs(CfgLevinMarket.Market[jenis]["penjualan"]) do
        local itemList = {}
        for x, y in pairs(CfgLevinMarket.Market[jenis]["penjualan"]["items"]) do
            itemList[#itemList + 1] = {
                title = y.label .. " | $" .. y.price .. " / Item",
                description = "Stok di Stash: " .. GetItemCount(y.hash) .. " / " .. y.maxiteminStash,
                icon = ItemImage(y.hash),
                onSelect = function()
                    InputPenjualan({
                        item = y.hash,
                        price = y.price,
                        maxiteminStash = y.maxiteminStash
                    })
                end
            }
        end
        lib.registerContext({
            id = 'penjualan_' .. jenis,
            title = CfgLevinMarket.Market[jenis]["penjualan"]["label"],
            options = itemList
        })
    end
    lib.showContext('penjualan_' .. jenis)
end

function MenuPembelian(jenis)
    for k, v in pairs(CfgLevinMarket.Market[jenis]) do
        local Pembelian = {}
        for x, y in pairs(CfgLevinMarket.Market[jenis]["pembelian"]["items"]) do
            Pembelian[#Pembelian + 1] = {
                title = y.label .. " | $" .. y.price .. " / Item",
                description = "Stok di Stash: " .. GetItemCount(y.hash) .. " | Harga Beli: $" .. y.price,
                icon = ItemImage(y.hash),
                onSelect = function()
                    InputPembelian({
                        item = y.hash,
                        price = y.price,
                    })
                end
            }
        end
        lib.registerContext({
            id = 'pembelian_' .. jenis,
            title = CfgLevinMarket.Market[jenis]["pembelian"]["label"],
            options = Pembelian
        })
    end
    lib.showContext('pembelian_' .. jenis)
end

function InputPenjualan(data)
    local jumlah = lib.inputDialog('Penjualan ' .. data.item, {
        { type = 'number', label = 'Jumlah', icon = 'hashtag', min = 1, max = data.maxiteminStash }
    })
    -- cek stok item di stashes
    if jumlah then
        local stash = GetItemCount(data.item)
        local maxdiStash = (data.maxiteminStash - stash)
        if tonumber(jumlah[1]) > maxdiStash then
            return TriggerEvent('levin-market:client:Notif', 'Anda tidak dapat menjual lebih dari ' .. maxdiStash .. ' barang.')
        end
        TriggerServerEvent('levin-market:server:jualbarang', data.item, tonumber(jumlah[1]), data.price)
    end
end

function InputPembelian(data)
    local jumlah = lib.inputDialog('Pembelian ' .. data.item, {
        { type = 'number', label = 'Jumlah', icon = 'hashtag', min = 1 }
    })
    if jumlah then
        TriggerServerEvent('levin-market:server:beliBarang', data.item, tonumber(jumlah[1]), data.price)
    end
end

RegisterNetEvent('levin-market:client:OpenMenuMarket', function(jenis)
    if jenis then
        local menulist = {
            {
                title = CfgLevinMarket.Market[jenis]["penjualan"]["label"],
                description = CfgLevinMarket.Market[jenis]["penjualan"]["Deskripsi"],
                icon = CfgLevinMarket.Market[jenis]["penjualan"]["icon"],
                onSelect = function()
                    MenuPenjualan(jenis)
                end
            },
            {
                title = CfgLevinMarket.Market[jenis]["pembelian"]["label"],
                description = CfgLevinMarket.Market[jenis]["pembelian"]["Deskripsi"],
                icon = CfgLevinMarket.Market[jenis]["pembelian"]["icon"],
                onSelect = function()
                    MenuPembelian(jenis)
                end
            }
        }
        lib.registerContext({
            id = 'market_menu',
            title = 'Pilih Market',
            options = menulist
        })
    end
    lib.showContext('market_menu')
end)