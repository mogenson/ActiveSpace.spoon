local ActiveSpace    = {}
ActiveSpace.__index  = ActiveSpace

-- Metadata
ActiveSpace.name     = "ActiveSpace"
ActiveSpace.version  = "0.1"
ActiveSpace.author   = "Michael Mogenson"
ActiveSpace.homepage = "https://github.com/mogenson/ActiveSpace.spoon"
ActiveSpace.license  = "MIT - https://opensource.org/licenses/MIT"

local function build_title()
    local title = {}
    local num_spaces = 0
    local spaces_layout = hs.spaces.allSpaces()
    local active_spaces = hs.spaces.activeSpaces()
    for _, screen in ipairs(hs.screen.allScreens()) do
        table.insert(title, screen:name() .. ": ")
        local screen_uuid = screen:getUUID()
        local active_space = active_spaces[screen_uuid]
        for i, space in ipairs(spaces_layout[screen_uuid]) do
            local space_title = tostring(i + num_spaces)
            if active_space and active_space == space then
                table.insert(title, "[" .. space_title .. "]")
            else
                table.insert(title, " " .. space_title .. " ")
            end
        end
        num_spaces = num_spaces + #spaces_layout[screen_uuid]
        table.insert(title, "  ")
    end
    table.remove(title)
    return table.concat(title)
end

function ActiveSpace:start()
    self.menu = hs.menubar.new()
    local title = build_title()
    -- print(title)
    self.menu:setTitle(title)

    self.watcher = hs.spaces.watcher.new(function(space)
        self.menu:setTitle(build_title())
    end)
    self.watcher:start()
end

function ActiveSpace:stop()
    if self.watcher then
        self.watcher:stop()
        self.watcher = nil
    end

    if self.menu then
        self.menu:delete()
        self.menu = nil
    end
end

return ActiveSpace
