local graphics = {}

function graphics:init()
    self.wallpaper = love.graphics.newImage("assets/background.png")
    self.foreground_image = love.graphics.newImage("assets/foreground.png")
    -- self.background_music = love.audio.newSource("assets/sounds/minecraft_three", "stream")
end

function graphics:draw()
    graphics:background()
    graphics:foreground()
    -- self.background_music:play()
end

function graphics:foreground()
    love.graphics.draw(self.foreground_image, 0, 0)
end

function graphics:background()
    love.graphics.draw(self.wallpaper, 0, 0)
end


return graphics