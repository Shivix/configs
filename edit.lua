local input = arg[1]
if #arg ~= 1 then
    error("please provide a single path for config to edit")
end

local configs = dofile("configs.lua")

local pos = assert(input:find("/"), "all files are stored in directories, but non / found in input")
local name = input:sub(1, pos - 1)
local file = input:sub(pos + 1)

local config = configs[name]
if config == nil then
    error("could not find matching config for: " .. name)
end

local repo_path = "configs/" .. input
local system_path = config.path .. "/" .. file
if not os.execute(string.format("ls %q", repo_path)) then
    error("could not find file: " .. input)
end
os.execute(string.format("nvim -d %s %s", repo_path, system_path))
