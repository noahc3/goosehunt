local graphics = {}

function graphics:init()
    self.wallpaper = love.graphics.newImage("assets/background.png")
    self.foreground_image = love.graphics.newImage("assets/foreground.png")

    self.background_music_one = love.audio.newSource("assets/sounds/minecraft_one.ogg", "stream")
    self.background_music_two = love.audio.newSource("assets/sounds/minecraft_two.ogg", "stream")
    self.background_music_three = love.audio.newSource("assets/sounds/minecraft_three.ogg", "stream")

    local random_num = math.random(1, 3)

    if(random_num == 1) then
      self.background_music = self.background_music_one
    elseif(random_num == 2) then
      self.background_music = self.background_music_two
    else
      self.background_music = self.background_music_three
    end

    self.background_music:play()


end

function graphics:draw()
    graphics:background()
    graphics:foreground()
end

function graphics:foreground()
    love.graphics.draw(self.foreground_image, 0, 0)
end

function graphics:background()
    love.graphics.draw(self.wallpaper, 0, 0)
end


return graphics