require("lib")

local input = arg[1]
if #arg ~= 1 then
    error("please provide a single path for config to edit")
end

local configs = dofile("configs.lua")

local repo_path, system_path = find_match(configs, input)
local expanded = system_path:gsub("~", os.getenv("HOME"))
os.execute(string.format("cp %q %q", expanded, repo_path))
