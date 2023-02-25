local scorehud = {}

function scorehud:init()
    defaultfont = love.graphics.getFont()
    love.graphics.setNewFont("assets/joystix.ttf", 40)
    hudfont = love.graphics.getFont()
    love.graphics.setFont(defaultfont)
end

function scorehud:draw(bulletCount, gooseCount, score)
    love.graphics.setFont(hudfont)
    love.graphics.print("000000", hudfont, 0, 0)
    love.graphics.setFont(defaultfont)
end

return scorehud