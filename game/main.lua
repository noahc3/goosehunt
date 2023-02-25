-- MODULE REQUIREMENTS

cursor_module = require "cursor"
shoot_module = require "shoot"
goose_module = require "goose"
scorehud = require "gui/scorehud"
graphics = require "gui/graphics"

-- END MODULES

function round(num, digits)
    local mult = 10^(digits or 0)
    return math.floor(num * mult + 0.5) / mult
end

function debugdraw()
    local strs = {
        "Debug Output",
        "FPS: " .. love.timer.getFPS(),
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
<<<<<<< Updated upstream
    lsoffset = {0, 0}
    cursor:centergyro()
    goose = goose_module:new(200, 532, 128, 128)
=======
    centergyro()
    goose = goose_module:new(200, 588, 45, 45)
    graphics:init()
>>>>>>> Stashed changes
    scorehud:init()
end

function love.update(dt)
    goose:update(dt)
    cursor:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)

    debugdraw()

    local cursorpos = cursor:gyropos()
    local stick = love.joystick.getJoysticks()[1]

    if (stick:getAxis(6) == 1) and (not triggerheld) then
        shoot_module:shoot(stick, cursorpos)
        triggerheld = true
    elseif stick:getAxis(6) == 0 then
        triggerheld = false
    end

    goose:draw()
<<<<<<< Updated upstream
    cursor:draw(cursorpos, lsoffset)
=======
    graphics:draw()
>>>>>>> Stashed changes
    scorehud:draw(2, 0, 0, 500)
end

-- we need to quit the app when a button is pressed
function love.gamepadpressed(joystick, button)
    goose:gamepadpressed(joystick, button)

    if button == "x" then
        cursor:centergyro()
    elseif button == "start" then
        love.event.quit()
    end
end