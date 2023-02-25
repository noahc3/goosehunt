-- MODULE REQUIREMENTS

cursor_module = require "cursor"
shoot_module = require "shoot"
goose_module = require "goose"
scorehud = require "gui/scorehud"

-- END MODULES

function round(num, digits)
    local mult = 10^(digits or 0)
    return math.floor(num * mult + 0.5) / mult
end

basegoosepos = {200, 532}
spawnafter = 3
geeselist = {}

function debugdraw()
    local strs = {
        "Debug Output",
        "FPS: " .. love.timer.getFPS(),
        "Geese active: " .. table.getn(geeselist),
        "Joystick Count: " .. love.joystick.getJoystickCount(),
        "Joysticks:",
    }

    for i, joystick in ipairs(love.joystick.getJoysticks()) do
        local axes = {joystick:getAxes()}

        for i, axis in ipairs(axes) do
            axes[i] = round(axis, 2)
        end
        strs[#strs + 1] = "  " .. joystick:getName()

        for i, axis in ipairs(axes) do
            strs[#strs + 1] = "    " .. i .. ": " .. axis
        end
    end

    love.graphics.print(table.concat(strs, "\n"), 10, 10);
end

function love.load()
    triggerheld = false;
    lsoffset = {0, 0}
    cursor:centergyro()
    spawntime = love.timer.getTime() + spawnafter
    
    scorehud:init()
end

function love.update(dt)
    for i,goose in ipairs(geeselist) do
        goose:update(dt)

        if goose.y + goose.height < 0 or goose.x + goose.width < 0 or goose.x > 1280 then
            table.remove(geeselist, i)
        end
    end

    cursor:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)

    debugdraw()

    if love.timer.getTime() > spawntime then
        table.insert(geeselist, goose_module:new(basegoosepos[1], basegoosepos[2], 128, 128))
        spawntime = love.timer.getTime() + spawnafter
    end

    local cursorpos = cursor:gyropos()
    local stick = love.joystick.getJoysticks()[1]

    if (stick:getAxis(6) == 1) and (not triggerheld) then
        shoot_module:shoot(stick, cursorpos)
        triggerheld = true
    elseif stick:getAxis(6) == 0 then
        triggerheld = false
    end

    for i,goose in ipairs(geeselist) do
        goose:draw()
    end
    
    cursor:draw(cursorpos, lsoffset)
    scorehud:draw(2, 0, 0, 500)
end

-- we need to quit the app when a button is pressed
function love.gamepadpressed(joystick, button)
    for i,goose in ipairs(geeselist) do
        goose:gamepadpressed(joystick, button)
    end

    if button == "x" then
        cursor:centergyro()
    elseif button == "start" then
        love.event.quit()
    end
end