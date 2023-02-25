-- MODULE REQUIREMENTS

aimcontrols_module = require "aimcontrols"
shoot_module = require "shoot"
goose_module = require "goose"

-- END MODULES

function round(num, digits)
    local mult = 10^(digits or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- GYRO FUNCS



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
    lsoffset = {0, 0}
    aimcontrols:centergyro()

    goose = goose_module:new(200, 100, 70, 90)
end

function love.draw()
    debugdraw()

    local cursorpos = aimcontrols:gyropos()
    local stick = love.joystick.getJoysticks()[1]
    
    love.graphics.setColor(1, 1, 1, 1)

    if (stick:getAxis(6) == 1) and (not triggerheld) then
        shoot_module:shoot(stick, cursorpos)
        triggerheld = true
    elseif stick:getAxis(6) == 0 then
        triggerheld = false
    end

    lsdelta = aimcontrols:leftstickdelta()
    lsoffset[1] = lsoffset[1] + lsdelta[1]
    lsoffset[2] = lsoffset[2] + lsdelta[2]

    love.graphics.circle("fill", cursorpos[1] + lsoffset[1], cursorpos[2] + lsoffset[2], 15)

    goose:draw()
end

-- we need to quit the app when a button is pressed
function love.gamepadpressed(joystick, button)
    if button == "x" then
        centergyro()
    else
        love.event.quit()
    end
end