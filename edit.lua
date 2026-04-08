local input = arg[1]
if #arg ~= 1 then
    error("please provide a single path for config to edit")
end

local configs = dofile("configs.lua")

local find_match = assert(io.popen("fd . --full-path --type file --hidden configs | fp -e '" .. input .. "'"))
-- If multiple matches, just get top match.
local match = find_match:read("*l")

local pos1 = assert(match:find("/"))
local pos2 = assert(match:find("/", pos1 + 1))
local name = match:sub(pos1 + 1, pos2 - 1)
local file = match:sub(pos2 + 1)

local config = configs[name]
if config == nil then
    error("could not find matching config for: " .. name)
end

local repo_path = match
local system_path = config.path .. "/" .. file
os.execute(string.format("vim -d %s %s", repo_path, system_path))
