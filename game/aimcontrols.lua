module("aimcontrols", package.seeall)

-- GYRO CONTROL FUNCS

POINTER_MAGIC = 0.70710678118654752440084436210485
CURSOR_SENSITIVITY = 2
gyrocenter = {0,0,1}
JOYCON = 2 -- 1 for left, 2 for right

function aimcontrols:gyroaxes(joystick, joycon)
    local axes = {joystick:getAxes()}
    local s = 13 + ((joycon - 1) or 0) * 9
    local e = s + 2
    local axes = {unpack(axes, s, e)}
    return axes
end

-- Implementation stolen from https://github.com/friedkeenan/nx-hbc/blob/master/source/drivers.c#L88
-- ty keenan and destiny <3
function aimcontrols:centergyro()
    if (love.joystick.getJoystickCount() < 1) then
        return
    end

    local sixaxis = aimcontrols:gyroaxes(love.joystick.getJoysticks()[1], JOYCON)
    gyrocenter = {
        sixaxis[1],
        sixaxis[3],
        sixaxis[2]
    }
end

function aimcontrols:gyropos()
    if (love.joystick.getJoystickCount() < 1) then
        return {1280/2,720/2}
    end

    local sin, cos, abs = math.sin, math.cos, math.abs

    local joystick = love.joystick.getJoysticks()[1]
    local sixaxis = aimcontrols:gyroaxes(joystick, JOYCON)

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

-- LEFT STICK CONTROL FUNCS

function aimcontrols:leftstickdelta()
    if (love.joystick.getJoystickCount() < 1) then
        return {0, 0}
    end

    local controller = love.joystick.getJoysticks()[1]
    local leftstick = {controller:getAxis(1), controller:getAxis(2)}

    delta = {leftstick[1], leftstick[2]}

    return delta
end

-- END LEFT STICK CONTROL FUNCS