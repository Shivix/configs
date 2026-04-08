local configs = dofile("configs.lua")

if #arg == 1 then
    -- TODO: helper function for this? Also consider warning if more than one match.
    local find_match = assert(io.popen("fd . --full-path --type file --hidden configs | fp -e '" .. arg[1] .. "'"))
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
    os.execute(string.format("diff -u %s %s", repo_path, system_path))
    os.exit(0)
end

for name, config in pairs(configs) do
    local ls <close> = assert(io.popen("fd --hidden '' --type file configs/" .. name))
    for repo_path in ls:lines() do
        local file = repo_path:gsub("[^/]*/[^/]*/", "")
        if
            os.execute("test -f " .. config.path .. "/" .. file)
            and not os.execute(
                string.format("diff %s %s/%s >/dev/null", repo_path, config.path, file)
            )
        then
            print(name .. "/" .. file)
        end
    end
end
