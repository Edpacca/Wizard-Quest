Frostray = Class{}

FROSTRAYS = {}
ice_timer = 0
ice_hit_timer = 0
ACTIVE_ICE_ORBS = 0
CASTING_FROST = false

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

    if CASTING_FROST == true then
    
        if ON_ICE_TILE == true then

            if map:tileAt(frostray_path_x, frostray_path_y).id == FLOOR_ORB_OFF then

                ice_hit_timer = ice_hit_timer + dt

                if ice_hit_timer > 1.1 then

                    ACTIVE_ICE_ORBS = ACTIVE_ICE_ORBS + 1
                    ice_hit_timer = 0
                    sounds['orb'..tostring(math.random(1,5))]:play()

                    map:setTile(math.floor(frostray_path_x / 32) + 1, math.floor(frostray_path_y / 32) + 1, FLOOR_ORB_ON)
                    map:open_portcullis()

                    if ACTIVE_ICE_ORBS == 5 then
                        sounds['magic_swoosh']:play()
                    end
                end
            end
        end

        if map:tileAt(frostray_path_x, frostray_path_y).id == WOOD_H or map:tileAt(frostray_path_x, frostray_path_y).id == WOOD_H_BURNT then

            sounds['knock']:play()
            map:setTile(math.floor(frostray_path_x / 32) + 1, math.floor(frostray_path_y / 32) + 1, WOOD_H_FROZEN)

        elseif map:tileAt(frostray_path_x, frostray_path_y).id == WOOD_V or map:tileAt(frostray_path_x, frostray_path_y).id == WOOD_V_BURNT then

            sounds['knock']:play()
            map:setTile(math.floor(frostray_path_x / 32) + 1, math.floor(frostray_path_y / 32) + 1, WOOD_V_FROZEN)

        end
    end
end

function Frostray:spawn_frostray(x, y, aim_x, aim_y)

    local x_vector = aim_x - x
    local y_vector = aim_y - y

    if x_vector > 0 and y_vector > 0 then

        angle = (math.atan(y_vector / x_vector))

    elseif x_vector < 0 then

        angle = (math.atan(y_vector / x_vector)) + math.pi

    elseif x_vector > 0 and y_vector < 0 then

        angle = (math.atan(y_vector / x_vector)) + (2 * math.pi)

    end

    frostray_path_x = x + ((3 * 32) * math.cos(angle))
    frostray_path_y = y + ((3 * 32) * math.sin(angle))

end

function Frostray:frostray_render(x_frost, y_frost)

    love.graphics.draw(self.frostray_spritesheet, self.currentFrame, x_frost + (math.sin(angle) * 16), y_frost - (math.cos(angle) * 16) + 16, angle)

end