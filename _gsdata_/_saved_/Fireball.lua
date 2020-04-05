Fireball = Class{}

FIREBALL_SPEED = 175
FIREBALLS = {}

SMALL_FIREBALL_SPEED = 17
BIG_FIREBALL_SPEED = 22

fireball_scale = 1
remaining_fireballs = 0

local fb_timer = 0
local dt_store = 0

function Fireball:init(map)

    self.spell_texture = love.graphics.newImage('master_graphics/Casting/Fireball/fireball_single.png')
    self.fb_height = 8
    self.fb_width = 8

end

function Fireball:fireball_update(dt)

    fb_timer = fb_timer + dt
    dt_store = dt
    for i, v in ipairs(FIREBALLS) do
        FIREBALLS[i].nfb_x = FIREBALLS[i].nfb_x + dt * FIREBALL_SPEED * FIREBALLS[i].x_speed
        FIREBALLS[i].nfb_y = FIREBALLS[i].nfb_y + dt * FIREBALL_SPEED * FIREBALLS[i].y_speed
        x_speed_measure = (FIREBALLS[i].nfb_x - x_init) / fb_timer
        y_speed_measure = (FIREBALLS[i].nfb_y - y_init) / fb_timer

        if map:collides(map:tileAt(FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y)) then
            table.remove(FIREBALLS, i)
        end
    end

end

function Fireball:spawn_fireball(x, y, aim_x, aim_y, scale)

    fb_timer = 0
    x_init = x
    y_init = y
    x_vector = aim_x - x
    y_vector = aim_y - y

    FIREBALLS[table.getn(FIREBALLS) + 1] = {nfb_x = x, nfb_y = y, img = self.spell_texture, 
        x_speed = x_vector / (math.abs(x_vector) + math.abs(y_vector)), 
        y_speed = y_vector / (math.abs(x_vector) + math.abs(y_vector)), nfb_scale = scale}

end


function Fireball:fireball_render()
    for i, new_fireball in ipairs(FIREBALLS) do


        love.graphics.draw(FIREBALLS[i].img, FIREBALLS[i].nfb_x, FIREBALLS[i].nfb_y, 0, nfb_scale, nfb_scale)


        love.graphics.print("Fireball "..tostring(i), FIREBALLS[i].nfb_x - 20, FIREBALLS[i].nfb_y - 50)
        love.graphics.print("x_speed: " ..string.format("%.2f", FIREBALLS[i].x_speed), FIREBALLS[i].nfb_x - 20, FIREBALLS[i].nfb_y - 30)
        love.graphics.print("y_speed: " ..string.format("%.2f", FIREBALLS[i].y_speed), FIREBALLS[i].nfb_x - 20, FIREBALLS[i].nfb_y - 20)
        love.graphics.print("sum_speed: " ..string.format("%.2f", math.abs(FIREBALLS[i].x_speed) + math.abs(FIREBALLS[i].y_speed)), FIREBALLS[i].nfb_x - 20, FIREBALLS[i].nfb_y - 40)
        love.graphics.print("fb_timer: " ..string.format("%.2f", fb_timer), 200, 445)
        love.graphics.print("x speed: " ..string.format("%.2f", x_speed_measure), 200, 460)
        love.graphics.print("y speed: " ..string.format("%.2f", y_speed_measure), 200, 475)
        love.graphics.print("sum speed: " ..string.format("%.0f", math.abs(x_speed_measure) + math.abs(y_speed_measure)), 200, 490)
        love.graphics.print("dt: " ..string.format("%.3f", dt_store), 200, 505)
        love.graphics.print("fireballs: " ..tostring(NUM_FIREBALLS), 200, 520)
        love.graphics.print("fireballs: " ..tostring(table.getn(FIREBALLS)), 200, 535)

        love.graphics.print("x_vector: " ..string.format("%.0f", x_vector), 200, 415)
        love.graphics.print("y_vector: " ..string.format("%.0f", y_vector), 200, 430)

    end
end
