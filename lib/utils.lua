--[[
 @package   Escaarr
 @filename  lib/utils.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <diaz.victor@openmailbox.org>
 @date      29.07.2019 01:47:02 -04
]]--

utils = {
	_HOME = string.gsub("$HOME", "%$(%w+)", os.getenv)
}

function utils.voice(message)
	os.execute("espeak -ves-la+f2 -s150 -p50 --stdout '"..message.."'  | play  -t wav - >/dev/null")
end

-- I detect the operating system
utils.os = nil

if utils.os then
	pattern = os.getenv("USERPROFILE").."\\"
	utils.os = "Window"
else
	pattern = "^" .. os.getenv("HOME")
	utils.os = "Linux"
end

function utils.file_exist(file)
	--return (io.open(file, "r") == nil) and false or true
	local file_found = io.open(file, "r")
	if (file_found == nil) then
		return false
	end
	return true
end

function utils.capture(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()

	if raw then return s end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end

function utils.round(num, dec)
	local mult = 10^(dec or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- function util.round(num, dec)
	-- return tonumber(string.format("%." .. (dec or 0) .. "f", num))
-- end

-- range(a) returns an iterator from 1 to a (step = 1)
-- range(a, b) returns an iterator from a to b (step = 1)
-- range(a, b, step) returns an iterator from a to b, counting by step.
function utils.range(a, b, step)
	if not b then
		b = a
		a = 1
	end
	step = step or 1
	local f =
    step > 0 and
		function(_, lastvalue)
			local nextvalue = lastvalue + step
			if nextvalue <= b then return nextvalue end
		end or
    step < 0 and
		function(_, lastvalue)
			local nextvalue = lastvalue + step
			if nextvalue >= b then return nextvalue end
		end or
		function(_, lastvalue) return lastvalue end
	return f, nil, a - step
end

local last_str = ''

function utils.clear_output(str)
	io.write(('\b \b'):rep(#last_str))
	io.write(str)
	io.flush()
	last_str = str
end

function utils.sleep(msec)
	local t = os.clock()
	repeat
	until os.clock() > t + msec * 1e-3
end

local function string(o)
    return '"' .. tostring(o) .. '"'
end

local function recurse(o, indent)
    if indent == nil then indent = '' end
    local indent2 = indent .. '  '
    if type(o) == 'table' then
        local s = indent .. '{' .. '\n'
        local first = true
        for k,v in pairs(o) do
            if first == false then s = s .. ', \n' end
            if type(k) ~= 'number' then k = string(k) end
            s = s .. indent2 .. '[' .. k .. '] = ' .. recurse(v, indent2)
            first = false
        end
        return s .. '\n' .. indent .. '}'
    else
        return string(o)
    end
end

function utils.var_dump(...)
    local args = {...}
    if #args > 1 then
        var_dump(args)
    else
        print(recurse(args[1]))
    end
end
