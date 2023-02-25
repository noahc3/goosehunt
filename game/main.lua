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

    local sin, cos, abs = math.sin, math.cos, math.abs

    local joystick = love.joystick.getJoysticks()[1]
    local sixaxis = gyroaxes(joystick, JOYCON)

    local finalvector = {
        CURSOR_SENSITIVITY * (sixaxis[1] - gyrocenter[1]),
        CURSOR_SENSITIVITY * (sixaxis[3] - gyrocenter[2]),
        sixaxis[2] - gyrocenter[3]
    }

    local xrad = 2 * math.pi * finalvector[1]
    local yrad = 2 * math.pi * finalvector[2]
    local zrad = 2 * math.pi * finalvector[3]

    finalvector[1] = sin(zrad) * sin(xrad) - cos(zrad) * sin(yrad) * cos(xrad)
    finalvector[2] = cos(zrad) * sin(xrad) + sin(zrad) * sin(yrad) * cos(xrad)

    if (abs(finalvector[1]) > POINTER_MAGIC) then
        if (finalvector[1] > 0) then
            finalvector[1] = POINTER_MAGIC
        else
            finalvector[1] = -POINTER_MAGIC
        end
    end

    if (abs(finalvector[2]) > POINTER_MAGIC) then
        if (finalvector[2] > 0) then
            finalvector[2] = POINTER_MAGIC
        else
            finalvector[2] = -POINTER_MAGIC
        end
    end

    finalvector[1] = (finalvector[1] + POINTER_MAGIC) / 2 / POINTER_MAGIC
    finalvector[2] = (-finalvector[2] + POINTER_MAGIC) / 2 / POINTER_MAGIC

    point = {finalvector[1] * 1280, finalvector[2] * 720}

    return point
end

-- END GYRO FUNCS

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
    centergyro()

    goose = {}
    goose.x = 100
    goose.y = 100
    goose.width = 70
    goose.height = 90
end

function love.draw()
    debugdraw()

    local cursorpos = gyropos()
    love.graphics.circle("fill", cursorpos[1], cursorpos[2], 15)

    love.graphics.rectangle("line", goose.x, goose.y, goose.width, goose.height)
end

-- we need to quit the app when a button is pressed
function love.gamepadpressed(joystick, button)
    if button == "x" then
        centergyro()
    else
        love.event.quit()
    end
end