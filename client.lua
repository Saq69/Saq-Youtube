local videoURL = ""
local isVideoPlaying = false
local recommendedVideos = {
    { label = "وظيفة الاخشاب", url = "https://www.youtube.com/watch?v=TvApLZ5YPPI" },
    { label = "النفط والغاز", url = "https://www.youtube.com/watch?v=QIhg9_f6I9A" },
    { label = "المعادن", url = "https://www.youtube.com/watch?v=mRqvDmwvtrs" },
}

RegisterCommand("openVideoMenu", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openMenu", videos = recommendedVideos })
end)

RegisterNUICallback("playVideo", function(data, cb)
    videoURL = convertToEmbedURL(data.url)
    StartVideo()
    cb("ok")
end)

RegisterNUICallback("stopVideo", function(data, cb)
    StopVideo()
    cb("ok")
end)

RegisterNUICallback("closeMenu", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("hideVideo", function(data, cb)
    HideVideo()
    cb("ok")
end)

RegisterNUICallback("setVolume", function(data, cb)
    SendNUIMessage({ action = "setVolume", volume = data.volume })
    cb("ok")
end)

function convertToEmbedURL(url)
    local videoID = url:match("v=([%w_-]+)")
    if videoID then
        return "https://www.youtube.com/embed/" .. videoID
    end
    
    if url:find("spotify.com") then
        local embedURL = url:gsub("open.spotify.com", "embed.spotify.com")
        embedURL = embedURL:gsub("track", "track"):gsub("playlist", "playlist"):gsub("album", "album")
        return embedURL
    end

    return url
end


function StartVideo()
    if videoURL ~= "" then
        isVideoPlaying = true
        SendNUIMessage({
            action = "play",
            url = videoURL
        })
    end
end

function StopVideo()
    isVideoPlaying = false
    SendNUIMessage({ action = "stop" })
end

function HideVideo()
    SendNUIMessage({ action = "hide" })
end
