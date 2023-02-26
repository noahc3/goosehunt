-- MODULE REQUIREMENTS

cursor_module = require "cursor"
shoot_module = require "shoot"
goose_module = require "goose"
scorehud = require "gui/scorehud"
graphics = require "gui/graphics"

-- END MODULES

SCENES = {INTRO = 0, TITLE = 1, GAME = 2}
SCENE = SCENES.INTRO

gooseypos = 532
spawnafter = 3
geeselist = {}

function round(num, digits)
    local mult = 10^(digits or 0)
    return math.floor(num * mult + 0.5) / mult
end

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
    
    graphics:init()
    scorehud:init()
    shoot_module:init()

    introimage = love.graphics.newImage("assets/start.png")
    titleimage = love.graphics.newImage("assets/title.png")
    introtime = love.timer.getTime()

    spawn_one = love.audio.newSource("assets/sounds/grass_one.ogg", "stream")
    spawn_two = love.audio.newSource("assets/sounds/grass_two.ogg", "stream")
    spawn_three = love.audio.newSource("assets/sounds/grass_three.ogg", "stream")
    spawn_four = love.audio.newSource("assets/sounds/grass_four.ogg", "stream")
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

function draw_intro()
    local joystick = love.joystick.getJoysticks()[1]
    local alpha = love.timer.getTime() - introtime
    love.graphics.setColor(1,1,1,alpha)
    love.graphics.draw(introimage, 0, 0)
end

function draw_title()
  local joystick = love.joystick.getJoysticks()[1]
  local alpha = love.timer.getTime() - alpha
  love.graphics.setColor(1,1,1,alpha)
  love.graphics.draw(titleimage, 0, 0)
end

function draw_game()
    if love.timer.getTime() > spawntime then
        local goosexpos = math.random(0, 1280)
        table.insert(geeselist, goose_module:new(goosexpos, gooseypos, 128, 128))
        spawntime = love.timer.getTime() + spawnafter

        local random_num = math.random(1, 4)

        if(random_num == 1) then
          spawn_audio = spawn_one
        elseif(random_num == 2) then
          spawn_audio = spawn_two
        elseif(random_num == 3) then
          spawn_audio = spawn_three
        else
          spawn_audio = spawn_four
        end

        spawn_audio:play()

    end

    local cursorpos = cursor:gyropos()
    local stick = love.joystick.getJoysticks()[1]

    graphics:draw()

    for i,goose in ipairs(geeselist) do
        goose:draw()
    end
    
    cursor:draw(cursorpos, lsoffset)

    scorehud:draw(2, 0, 0, 500)

    if (stick:getAxis(6) == 1) and (not triggerheld) then
        shoot_module:shoot(stick, cursorpos, geeselist)
        triggerheld = true
    elseif stick:getAxis(6) == 0 then
        triggerheld = false
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    
    debugdraw()

    if SCENE == SCENES.INTRO then
      draw_intro()
    elseif SCENE == SCENES.TITLE then
        draw_title()
    elseif SCENE == SCENES.GAME then
        draw_game()
    end
end

-- we need to quit the app when a button is pressed
function love.gamepadpressed(joystick, button)
    for i,goose in ipairs(geeselist) do
        goose:gamepadpressed(joystick, button)
    end

    if SCENE == SCENES.INTRO then
      if button == "start" then
        SCENE = SCENES.TITLE
        alpha = love.timer.getTime()
      end
    elseif SCENE == SCENES.TITLE then
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