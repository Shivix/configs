local configs = dofile("configs.lua")
local home = assert(os.getenv("HOME"), "HOME is not set")

for name, config in pairs(configs) do
    local repo = assert(os.getenv("PWD"))
    local src = repo .. "/configs/" .. name
    local dest = config.path:gsub("^~", home)
    assert(os.execute(string.format("ln -s %q %q", src, dest)))
end
