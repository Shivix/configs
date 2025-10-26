local configs = dofile("configs.lua")

for name, config in pairs(configs) do
    local ls <close> = assert(io.popen("fd '' --type file configs/" .. name))
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
