--https://discord.gg/wXfvEKV
_G.GamsteronUseUpdater = true--change to false if you have trouble with loading
-- if you set it to false, you must manually download all files: https://github.com/gamsteron/Gamsteron/blob/master/Gamsteron.zip?raw=true
do
    local path = COMMON_PATH.."Gamsteron_Loader.lua"
    if FileExist(path) then require("Gamsteron_Loader") return end
    if GamsteronUseUpdater then
	    DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/Gamsteron/master/Gamsteron_Loader.lua", path, function() end)
	    while not FileExist(path) do end
	    require("Gamsteron_Loader")
    end
end