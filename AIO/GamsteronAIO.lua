--https://discord.gg/wXfvEKV
do
    local path = COMMON_PATH.."GamsteronAIO_Loader.lua"
    if FileExist(path) then require("GamsteronAIO_Loader") return end
    DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/Gamsteron/master/AIO/GamsteronAIO_Loader.lua", path, function() end)
    while not FileExist(path) do end
    require("GamsteronAIO_Loader")
end