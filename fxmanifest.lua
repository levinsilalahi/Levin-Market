fx_version 'cerulean'
game 'gta5'

author 'Levin Silalahi - flLwme @2025'
description 'flLwme Market'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua',
}
server_scripts {
    'server/*.lua',
}

dependencies {
    'ox_lib',
    'ox_inventory'
}