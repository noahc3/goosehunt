local scorehud = {}

score_module = require "score"

function scorehud:loadfont(file, size)
    love.graphics.setNewFont(file, size)
    local font = love.graphics.getFont()
    love.graphics.setFont(self.defaultfont)

    return font
end

function scorehud:init()
    self.defaultfont = love.graphics.getFont()
    self.hudfont = self:loadfont("assets/joystix.ttf", 40)
    self.hudtexture = love.graphics.newImage("assets/hud.png")
    self.hud_hit_goose = love.graphics.newImage("assets/hit-goose.png")
    self.hud_goose = love.graphics.newImage("assets/miss-goose.png")
    self.hud_bullet = love.graphics.newImage("assets/netting.png")
end

function scorehud:draw(round, bulletCount, gooseCount, score)
    local scoreText = string.format("%05d", score)

    love.graphics.setFont(self.hudfont)
    love.graphics.draw(self.hudtexture, 0, 0)
    love.graphics.setColor(53/255, 192/255, 80/255, 1.0)
    love.graphics.print(tostring(round), self.hudfont, 213, 473)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(scoreText, self.hudfont, 954, 565)
    love.graphics.setFont(self.defaultfont)

    self:goose_counter(gooseCount)
    scorehud:bullet_counter(bulletCount)
    scorehud:miss_counter()
end
  

function scorehud:goose_counter(goose_count)
    goose_x = 430
    goose_y = 560
    goose_x_change = 45

    for i = 0, goose_count do
      love.graphics.draw(self.hud_hit_goose, goose_x + i * goose_x_change, goose_y)
    end
    for i = goose_count, 9 do
      love.graphics.draw(self.hud_goose, goose_x + i * goose_x_change, goose_y)
    end
end

function scorehud:bullet_counter(bullet_count)
    bullet_x = 150
    bullet_y = 560
    bullet_x_change = 35

    for i = 0, (bullet_count - 1) do
      love.graphics.draw(self.hud_bullet, bullet_x + i * bullet_x_change, bullet_y)
    end
end

function scorehud:miss_counter()
    line_x = 345
    line_y = 610

    start_amount = 24

    line_amount = start_amount - score_module:get_miss_shot()

    love.graphics.setColor(35/255,110/255,248/255,1.0)
    for i = 0, line_amount do
      love.graphics.rectangle("fill", line_x + 20*i, line_y, 10,50)
    end
end


return scorehud