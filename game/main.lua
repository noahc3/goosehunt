-- MODULE REQUIREMENTS

cursor_module = require "cursor"
shoot_module = require "shoot"
goose_module = require "goose"
scorehud = require "gui/scorehud"
graphics = require "gui/graphics"

-- END MODULES

SCENES = {INTRO = 0, GAME = 1}
SCENE = SCENES.INTRO

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
    lsoffset = {0, 0}
    cursor:centergyro()
    goose = goose_module:new(200, 532, 128, 128)
    graphics:init()
    scorehud:init()

    introimage = love.graphics.newImage("assets/introscene.png")
    introtime = love.timer.getTime()
end

function love.update(dt)
    goose:update(dt)
    cursor:update(dt)
end

function draw_intro()
    local joystick = love.joystick.getJoysticks()[1]
    local alpha = love.timer.getTime() - introtime
    love.graphics.setColor(1,1,1,alpha)
    love.graphics.draw(introimage, 0, 0)
end

function draw_game()
    local cursorpos = cursor:gyropos()
    local stick = love.joystick.getJoysticks()[1]

    if (stick:getAxis(6) == 1) and (not triggerheld) then
        shoot_module:shoot(stick, cursorpos)
        triggerheld = true
    elseif stick:getAxis(6) == 0 then
        triggerheld = false
    end

    graphics:draw()
    scorehud:draw(2, 0, 0, 500)
    cursor:draw(cursorpos, lsoffset)
    goose:draw()
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    
    debugdraw()

    if SCENE == SCENES.INTRO then
        draw_intro()
    elseif SCENE == SCENES.GAME then
        draw_game()
    end
end

-- we need to quit the app when a button is pressed
function love.gamepadpressed(joystick, button)
    goose:gamepadpressed(joystick, button)

    if SCENE == SCENES.INTRO then
        if button == "start" then
            SCENE = SCENES.GAME
        end
    elseif SCENE == SCENES.GAME then
        if button == "x" then
            cursor:centergyro()
        elseif button == "start" then
            love.event.quit()
        end
    end
end