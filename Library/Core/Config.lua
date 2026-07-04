local Config = {}
Config.__index = Config

local HttpService = game:GetService("HttpService")

function Config.Save(name, settings)
    assert(typeof(name) == "string", "Config.Save expects a file name")
    if writefile then
        writefile(name, HttpService:JSONEncode(settings or {}))
    end
end

function Config.Load(name)
    assert(typeof(name) == "string", "Config.Load expects a file name")
    if readfile then
        local content = readfile(name)
        return HttpService:JSONDecode(content)
    end
    return {}
end

return Config