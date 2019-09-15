
if _G.GSO then return end

local assert = assert
local open = assert(io.open)
local FileExist = assert(FileExist)
local COMMON_PATH = COMMON_PATH
local SPRITE_PATH = SPRITE_PATH

_G.GSO =
{
}

local Version
do
    local DownloadFile, OldVersion, NewVersion
    
    DownloadFile = function(url, path)
        DownloadFileAsync(url, path, function() end)
        local timer = os.clock()
        while not FileExist(path) do
            if os.clock() > timer + 6 then break end
        end
        if FileExist(path) then
            return true
        end
        assert(false, "Downloader Error ! Please try again 2xF6 !")
        return false
    end
    
    if not DownloadFile("https://raw.githubusercontent.com/gamsteron/Gamsteron/master/AIO/GamsteronAIO_Version.lua", COMMON_PATH .. "GamsteronAIO_Version.lua") then
        return
    end
    
    if FileExist(COMMON_PATH .. "GamsteronAIO_Version_Old.lua") then
        OldVersion = require("GamsteronAIO_Version_Old")
    end
    
    NewVersion = require("GamsteronAIO_Version")
    
    -- UPDATE:
    Version = 0
    local BaseUrl = "https://raw.githubusercontent.com/gamsteron/Gamsteron/master/"
    local success, downloaded = true, false
    for k, v in pairs(NewVersion) do
        Version = Version + v
        if not FileExist(COMMON_PATH .. k .. ".lua") or OldVersion == nil or OldVersion[k] == nil or v > OldVersion[k] then
            print("Downloading " .. k .. ".lua, please wait...")
            if not DownloadFile(BaseUrl .. "AIO/" .. k .. ".lua", COMMON_PATH .. k .. ".lua") then
                success = false
                break
            end
            downloaded = true
        end
    end
    
    if not success then
        return
    end
    
    if downloaded or not FileExist(COMMON_PATH .. "GamsteronAIO_Version_Old.lua") then
        local oldPath = COMMON_PATH .. "GamsteronAIO_Version_Old.lua"
        local newPath = COMMON_PATH .. "GamsteronAIO_Version.lua"
        local fi = open(newPath, "r")
        local fo = open(oldPath, "w")
        fo:write(fi:read("*all"))
        fi:close()
        fo:close()
    end
    
    if downloaded then
        print("Update Completed, please 2x F6!")
        return
    end
    
    do
        local path = COMMON_PATH.."Gamsteron_Loader.lua"
        if FileExist(path) then require("Gamsteron_Loader") return end
        DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/Gamsteron/master/Gamsteron_Loader.lua", path, function() end)
        while not FileExist(path) do end
        require("Gamsteron_Loader")
    end
end

