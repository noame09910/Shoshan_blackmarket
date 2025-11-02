fx_version 'bodacious'
game 'gta5'

name 'Black Market'
description 'Shoshan Black Market'

lua54 'yes'


shared_scripts{
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

ui_page 'html/index.html'

files{
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/images/*.png',

}
