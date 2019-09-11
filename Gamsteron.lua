--https://discord.gg/wXfvEKV
do
    local path = COMMON_PATH.."Gamsteron\\Loader.lua"
    if FileExist(path) then require("Gamsteron\\Loader") return end
    DownloadFileAsync("https://raw.githubusercontent.com/GSOProject/Gamsteron/master/Loader.lua", path, function() end)
    while not FileExist(path) do end
    require("Gamsteron\\Loader")
end