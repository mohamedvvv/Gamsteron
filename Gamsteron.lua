--https://discord.gg/wXfvEKV
do
    local path = COMMON_PATH.."Gamsteron_Loader.lua"
    if FileExist(path) then require("Gamsteron_Loader") return end
    DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/Gamsteron/master/Gamsteron_Loader.lua", path, function() end)
    while not FileExist(path) do end
    require("Gamsteron_Loader")
end