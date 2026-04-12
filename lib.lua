function find_match(configs, input)
    local match_finder <close> = assert(io.popen("fd . --full-path --type file --hidden configs | fp -e '" .. input .. "'"))
    local matches = {}
    for line in match_finder:lines() do
        table.insert(matches, line)
    end
    if #matches > 1 then
        error("matching config file is ambiguous found")
    end
    local match = matches[1]

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
    return repo_path, system_path
end
