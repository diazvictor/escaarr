#!/usr/bin/lua
--[[--
 @package   Escaarr
 @filename  init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <diaz.victor@openmailbox.org>
 @date      23.07.2019 09:51:10 -04
]]

require("lib.utils")

for h in utils.range(tonumber(os.date("%H")), 24) do
	for m in utils.range(tonumber(os.date("%M")), 60) do
		for s in utils.range(tonumber(os.date("%S")), 60) do
			print("Hora: " .. h .. "Minuto: " .. m .. "Segundo: " .. s)
			utils.sleep(1000)

		end
	end

	utils.voice("Escaarr, dando el reporte de la hora")
	utils.voice("son las ".. os.date("%I") .. " con " .. os.date("%M") .. " minutos ")
end
