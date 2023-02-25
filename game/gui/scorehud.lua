local scorehud = {}

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
   
  end
  

function scorehud:goose_counter()
    goose_x = 430
    goose_y = 560
    goose_x_change = 45

    for i = 0, 9 do
      love.graphics.draw(self.hud_hit_goose, goose_x + i * goose_x_change, goose_y)
    
    -- love.graphics.draw(self.hud_hit_goose, goose_x, goose_y)
    end
end

return scorehud