fx_version 'adamant'

game 'gta5'

autor 'Luke'

Discrod 'https://discord.gg/unitydev'

client_scripts {
	"config.lua",
	"client/main.lua"
}

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    "config.lua",
    "server/main.lua",
}

ui_page "html/index.html"

files {
    'html/index.html',
    'html/app.js',
    'html/style.css',
    'html/img/*.png',
}

dependencies {
	'async',
	'es_extended'
}


lua54 'yes'
escrow_ignore {
  "config.lua"
}
