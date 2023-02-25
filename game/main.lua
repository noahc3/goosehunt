-- MODULE REQUIREMENTS

aimcontrols_module = require "aimcontrols"
shoot_module = require "shoot"
goose_module = require "goose"
scorehud = require "gui/scorehud"

-- END MODULES

function round(num, digits)
    local mult = 10^(digits or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- GYRO FUNCS

POINTER_MAGIC = 0.70710678118654752440084436210485
CURSOR_SENSITIVITY = 2
gyrocenter = {0,0,1}
JOYCON = 2 -- 1 for left, 2 for right

function gyroaxes(joystick, joycon)
    local axes = {joystick:getAxes()}
    local s = 13 + ((joycon - 1) or 0) * 9
    local e = s + 2
    local axes = {unpack(axes, s, e)}
    return axes
end

-- Implementation stolen from https://github.com/friedkeenan/nx-hbc/blob/master/source/drivers.c#L88
-- ty keenan and destiny <3
function centergyro()
    if (love.joystick.getJoystickCount() < 1) then
        return
    end

    local sixaxis = gyroaxes(love.joystick.getJoysticks()[1], JOYCON)
    gyrocenter = {
        sixaxis[1],
        sixaxis[3],
        sixaxis[2]
    }
end

function gyropos()
    if (love.joystick.getJoystickCount() < 1) then
        return {1280/2,720/2}
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
    lsoffset = {0, 0}
    aimcontrols:centergyro()
    goose = goose_module:new(200, 100, 70, 90)
    scorehud:init()
end

function love.update()
    goose:update()
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
    scorehud:draw()
end

-- we need to quit the app when a button is pressed
function love.gamepadpressed(joystick, button)
    if button == "x" then
        centergyro()
    else
        love.event.quit()
    end
end