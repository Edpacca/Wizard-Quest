Frostray = Class{}

FROSTRAYS = {}
ice_timer = 0
CASTING_FROST = false
local ice_dt_store = 0
local screen = 16

function Frostray:init(map)

    self.frostray_spritesheet = love.graphics.newImage('master_graphics/Casting/Frostray/Frostray3_spritesheet.png')
    self.frames = generateQuads(self.frostray_spritesheet, 128, 32)

    self.frost_animation = Animation({
        texture = self.frostray_spritesheet,
        frames = {
            self.frames[1], self.frames[2], self.frames[3], self.frames[4]
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

    if x_vector > 0 and y_vector > 0 then
        angle = (math.atan(y_vector / x_vector))

    elseif x_vector < 0 then
        angle = (math.atan(y_vector / x_vector)) + math.pi
    elseif x_vector > 0 and y_vector < 0 then
        angle = (math.atan(y_vector / x_vector)) + (2 * math.pi)
    end
end


function Frostray:frostray_render(x_frost, y_frost)

    love.graphics.draw(self.frostray_spritesheet, self.currentFrame, x_frost + (math.sin(angle) * 16), y_frost - (math.cos(angle) * 16) + 16, angle)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(defaultfont)
    love.graphics.print("ray angle " ..tostring(angle * (180/math.pi)), map.camX + 20, map.camY + 310)
    love.graphics.print("y_frost " ..tostring(y_frost), map.camX + 20, map.camY + 320)

end