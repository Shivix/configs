require("lib")

local configs = dofile("configs.lua")

if #arg == 1 then
    local repo_path, system_path = find_match(configs, arg[1])
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
