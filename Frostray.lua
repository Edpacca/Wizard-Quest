Frostray = Class{}

FROSTRAYS = {}
ice_timer = 0
CASTING_FROST = false
local ice_dt_store = 0

function Frostray:init(map)

    self.frostray_spritesheet = love.graphics.newImage('Graphics/Casting/Frostray/Frostray_spritesheet.png')
    self.frames = generateQuads(self.frostray_spritesheet, 64, 32)

    self.frost_animation = Animation({
        texture = self.frostray_spritesheet,
        frames = {
            self.frames[1], self.frames[2]
        },
    interval = 0.1
    })
    
end



function Frostray:frostray_update(dt)

    self.frost_animation:update(dt)
    self.currentFrame = self.frost_animation:getCurrentFrame()

end

function Frostray:spawn_frostray(x, y, aim_x, aim_y)

    x_vector = aim_x - x
    y_vector = aim_y - y
    angle = (math.atan(x_vector / y_vector))

end


function Frostray:frostray_render(x_frost, y_frost)

    love.graphics.draw(self.frostray_spritesheet, self.currentFrame, x_frost, y_frost, angle)
    love.graphics.print("FR angle " ..tostring(angle), map.camX + 75, map.camY + 20)

end
