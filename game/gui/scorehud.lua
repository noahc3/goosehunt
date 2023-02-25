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
end

function scorehud:draw(bulletCount, gooseCount, score)
    love.graphics.setFont(self.hudfont)
    love.graphics.draw(self.hudtexture, 0, 0)
    love.graphics.print("000000", self.hudfont, 0, 0)
    love.graphics.setFont(self.defaultfont)
end

return scorehud