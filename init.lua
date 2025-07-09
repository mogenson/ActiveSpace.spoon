local ActiveSpace    = {}
ActiveSpace.__index  = ActiveSpace

-- Metadata
ActiveSpace.name     = "ActiveSpace"
ActiveSpace.version  = "0.2"
ActiveSpace.author   = "Michael Mogenson"
ActiveSpace.homepage = "https://github.com/mogenson/ActiveSpace.spoon"
ActiveSpace.license  = "MIT - https://opensource.org/licenses/MIT"

-- Variables
ActiveSpace.compact = false

local function build_title()
    local title = {}
    local num_spaces = 0
    local spaces_layout = hs.spaces.allSpaces()
    local active_spaces = hs.spaces.activeSpaces()
    for _, screen in ipairs(hs.screen.allScreens()) do
        if not ActiveSpace.compact then
            table.insert(title, screen:name() .. ": ")
        end
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
        table.insert(title, (ActiveSpace.compact and " | " or "  "))
    end
    table.remove(title)
    return table.concat(title)
end

function ActiveSpace:start()
    self.menu = hs.menubar.new()
    local title = build_title()
    -- print(title)
    self.menu:setTitle(title)

    self.menu:setClickCallback(function()
        ActiveSpace.compact = not ActiveSpace.compact
        self.menu:setTitle(build_title())
    end)

    self.space_watcher = hs.spaces.watcher.new(function()
        self.menu:setTitle(build_title())
    end):start()

    self.screen_watcher = hs.screen.watcher.new(function()
        self.menu:setTitle(build_title())
    end):start()
end

function ActiveSpace:stop()
    if self.space_watcher then
        self.space_watcher:stop()
        self.space_watcher = nil
    end

    if self.screen_watcher then
        self.screen_watcher:stop()
        self.screen_watcher = nil
    end

    if self.menu then
        self.menu:delete()
        self.menu = nil
    end
end

return ActiveSpace
