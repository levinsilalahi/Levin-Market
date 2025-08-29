Config = Config or {}

CfgLevinMarket = {}

CfgLevinMarket.Image = 'ox_inventory/web/images/'

CfgLevinMarket.Logs = {
    webhookJual = '', -- isi webhook log disini
    webhookBeli = '',
    logoImg = '', -- logo di atas nama server
    username = 'Levin Market', 
}

CfgLevinMarket.Stash = {
    idStash = 'market_stash',
    labelStash = 'Market Stash',
    slotsStash = 500,
    weightStash = 10000000,
    ownerStash = false,
    jobsStash = 'admin',
}

CfgLevinMarket.Blip = {
    enable = true,
    name = "Pasar Wak Lepen",
    sprite = 431,
    color = 8,
    scale = 0.8,
    coord = vector3(463.273, -759.948, 27.359)
}

-- Config ped & market
CfgLevinMarket.Market = {
    ["Tambang"] = {
        ["pedhash"] = "a_m_m_bevhills_01",
        ["coordped"] = vector3(463.273, -759.948, 27.359),
        ["headingped"] = 92.538,
        ["penjualan"] = {
            ["label"] = "🧱 Penjualan Hasil Tambang",
            ["Deskripsi"] = "Jual hasil tambangmu disini",
            ["icon"] = "fas fa-gem",
            ["items"] = {
                ["copper"] = {
                    hash = "copper",
                    label = "Copper",
                    price = 140,
                    maxiteminStash = 100,
                },
                ["iron"] = {
                    hash = "iron",
                    label = "Iron",
                    price = 150,
                    maxiteminStash = 100,
                },
                ["gold"] = {
                    hash = "gold",
                    label = "Gold",
                    price = 190,
                    maxiteminStash = 100,
                },
                ["diamond"] = {
                    hash = "diamond",
                    label = "Diamond",
                    price = 2000,
                    maxiteminStash = 100,
                }
            }
        },
        ["pembelian"] = {
            ["label"] = "🧱 Pembelian Hasil Tambang",
            ["Deskripsi"] = "Beli hasil tambang disini",
            ["icon"] = "fas fa-gem",
            ["items"] = {
                ["copper"] = {
                    hash = "copper",
                    label = "Copper",
                    price = 150,
                },
                ["iron"] = {
                    hash = "iron",
                    label = "Iron",
                    price = 160,
                },
                ["gold"] = {
                    hash = "gold",
                    label = "Gold",
                    price = 220,
                },
                ["diamond"] = {
                    hash = "diamond",
                    label = "Diamond",
                    price = 2500,
                }
            }
        }
    },
    ["Recycle"] = {
        ["pedhash"] = "a_m_m_bevhills_01",
        ["coordped"] = vector3(462.371, -753.084, 27.358),
        ["headingped"] = 90.937,
        ["penjualan"] = {
            ["label"] = "♻️ Penjualan Hasil Daur Ulang",
            ["Deskripsi"] = "Jual hasil daur ulangmu disini",
            ["icon"] = "fas fa-recycle",
            ["items"] = {
                ["metalscrap"] = {
                    hash = "metalscrap",
                    label = "Metalscrap",
                    price = 120,
                    maxiteminStash = 100,
                },
                ["plastic"] = {
                    hash = "plastic",
                    label = "Plastic",
                    price = 120,
                    maxiteminStash = 100,
                },
                ["aluminum"] = {
                    hash = "aluminum",
                    label = "Aluminum",
                    price = 120,
                    maxiteminStash = 100,
                },
                ["glass"] = {
                    hash = "glass",
                    label = "Glass",
                    price = 120,
                    maxiteminStash = 100,
                },
                ["pcb"] = {
                    hash = "pcb",
                    label = "Pcb",
                    price = 120,
                    maxiteminStash = 100,
                },
                ["steel"] = {
                    hash = "steel",
                    label = "Steel",
                    price = 120,
                    maxiteminStash = 100,
                }
            }
        },
        ["pembelian"] = {
            ["label"] = "♻️ Pembelian Hasil Daur Ulang",
            ["Deskripsi"] = "Beli hasil daur ulang disini",
            ["icon"] = "fas fa-recycle",
            ["items"] = {
                ["metalscrap"] = {
                    hash = "metalscrap",
                    label = "Metalscrap",
                    price = 110,
                },
                ["plastic"] = {
                    hash = "plastic",
                    label = "Plastic",
                    price = 110,
                },
                ["aluminum"] = {
                    hash = "aluminum",
                    label = "Aluminum",
                    price = 130,
                },
                ["glass"] = {
                    hash = "glass",
                    label = "Glass",
                    price = 130,
                },
                ["pcb"] = {
                    hash = "pcb",
                    label = "Pcb",
                    price = 130,
                },
                ["steel"] = {
                    hash = "steel",
                    label = "Steel",
                    price = 130,
                }
            }
        }
    }
}