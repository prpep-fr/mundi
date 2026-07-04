-- GitHub Loader with Cache System
-- Loads modules from GitHub Raw without depending on ModuleScripts

local BASE_URL = "https://raw.githubusercontent.com/prpep-fr/mundi/main/"
local moduleCache = {}

local function GithubRequire(path)
    -- Check if module is already cached
    if moduleCache[path] then
        return moduleCache[path]
    end
    
    -- Construct the full URL
    local url = BASE_URL .. path .. ".lua"
    
    -- Attempt to fetch the module from GitHub
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not response then
        error("Failed to load module from GitHub: " .. url)
    end
    
    -- Execute the module code using loadstring
    local moduleFunction = loadstring(response)
    if not moduleFunction then
        error("Failed to parse module: " .. path)
    end
    
    -- Execute the module and store the result in cache
    local result = moduleFunction()
    moduleCache[path] = result
    
    return result
end

return GithubRequire
