Fireball = Class{}

-- Variables ------------------------
FIREBALL_SPEED = 200
SMALL_FIREBALL_SPEED = 200
BIG_FIREBALL_SPEED = 240
-------------------------------------

FIREBALLS = {}
fireball_scale = 1
remaining_fireballs = 0
ACTIVE_FB_ORBS = 0
fireball_texture = love.graphics.newImage('master_graphics/Casting/Fireball/fireball_single.png')

function Fireball:fireball_update(dt)

    for i, v in ipairs(FIREBALLS) do

        FIREBALLS[i].nfb_x = FIREBALLS[i].nfb_x + dt * FIREBALL_SPEED * FIREBALLS[i].x_speed
        FIREBALLS[i].nfb_y = FIREBALLS[i].nfb_y + dt * FIREBALL_SPEED * FIREBALLS[i].y_speed
        
        if map:fireball_interact(map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y)) then

            if ON_FIRE_TILE == true then

                if map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == ALCOVE_ORB_OFF_E then

                    ACTIVE_FB_ORBS = ACTIVE_FB_ORBS + 1
                    sounds['orb'..tostring(math.random(1,5))]:play()

                    map:open_portcullis()
                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, ALCOVE_ORB_ON_E)

                elseif map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == ALCOVE_ORB_OFF_S then
                    
                    ACTIVE_FB_ORBS = ACTIVE_FB_ORBS + 1
                    sounds['orb'..tostring(math.random(1,5))]:play()

                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, ALCOVE_ORB_ON_S)
                    map:open_portcullis()

                elseif map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == ALCOVE_ORB_OFF_N then

                    ACTIVE_FB_ORBS = ACTIVE_FB_ORBS + 1
                    sounds['orb'..tostring(math.random(1,5))]:play()

                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, ALCOVE_ORB_ON_N)
                    map:open_portcullis()

                elseif map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == ALCOVE_ORB_OFF_W then

                    ACTIVE_FB_ORBS = ACTIVE_FB_ORBS + 1
                    sounds['orb'..tostring(math.random(1,5))]:play()

                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, ALCOVE_ORB_ON_W)
                    map:open_portcullis()

                end

                if ACTIVE_FB_ORBS == 5 then
                    sounds['magic_swoosh']:play()
                end

            elseif map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == WOOD_V  then

                if fireball_scale == 2 then
                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, DIRT)
                else
                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, WOOD_V_BURNT)
                end

                sounds['firehit']:play()

            elseif map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == WOOD_H then

                if fireball_scale == 2 then
                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, DIRT)
                else
                    map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, WOOD_H_BURNT)
                end

                sounds['firehit']:play()

            elseif map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == WOOD_H_BURNT or 
            map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == WOOD_V_BURNT or 
            map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == WOOD_V_FROZEN or 
            map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y).id == WOOD_H_FROZEN then

                map:setTile(math.floor(FIREBALLS[i].nfb_x / 32) + 1, math.floor(FIREBALLS[i].nfb_y / 32) + 1, DIRT)

                sounds['firehit']:play()

            end

            table.remove(FIREBALLS, i)

        elseif map:collides(map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y)) then

            table.remove(FIREBALLS, i)
            sounds['firehit']:play()

        end
    end
end

-- Credit to Jens Genburg for initial shooter mechanics: https://dev.to/jeansberg/make-a-shooter-in-lualove2d---part-2
function Fireball:spawn_fireball(x, y, aim_x, aim_y, scale)

    local x_init = x
    local y_init = y
    local x_vector = aim_x - x
    local y_vector = aim_y - y

    FIREBALLS[table.getn(FIREBALLS) + 1] = {nfb_x = x - (4 * scale) , nfb_y = y - (4 * scale), img = fireball_texture, 
        x_speed = x_vector / (math.abs(x_vector) + math.abs(y_vector)), 
        y_speed = y_vector / (math.abs(x_vector) + math.abs(y_vector)), nfb_scale = scale}

end

function Fireball:fireball_render()

    for i, new_fireball in ipairs(FIREBALLS) do
        love.graphics.draw(FIREBALLS[i].img, FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y, 0, FIREBALLS[i].nfb_scale, FIREBALLS[i].nfb_scale)
    end

end
