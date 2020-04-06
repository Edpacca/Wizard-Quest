Wizard = Class{}

ON_ICE_TILE = false
ON_FIRE_TILE = false
FIREBALLS_ACTIVE = false
ICE_ACTIVE = false

WALKING_SPEED = 350
local active_direction = 's'
local fireball_timer = 0
local tick = 5

check_tile = 0

function Wizard:init(map)

    self.y = map.tileWidth * 28
    self.x = map.tileWidth * 45

    self.dx = 0
    self.dy = 0
    self.width = 32
    self.height = 32
    self.xOffset = 16
    self.yOffset = 22
    self.y1 = self.y + self.height
    self.x1 = self.x + self.width

    self.items = Items(self)
    self.fireball = Fireball(self)
    self.frostray = Frostray(self)
    self.map = map
 
    
    self.texture = love.graphics.newImage('master_graphics/Wizard_spritesheet.png')

    self.state = 'startup'
    self.direction = 's'
    self.frames = generateQuads(self.texture, 32, 32)
    self.currentFrame = nil
    
    -- table of relative directions to whichever direction the wizard is facing (conisdered north)
    -- enables diagonal movement and unbiased key response
    self.movements = {
        -- LEFT
        ['a'] = {
            north = 'a',
            south = 'd',
            east = 'w',
            west = 's',
            mod_xy = -1,
            xaxis = 1,
            yaxis = 0,
            mod_ex = -0.707,
            mod_ey = -0.707,
            mod_wx = -0.707,
            mod_wy = 0.707
        },
        -- RIGHT
        ['d'] = {
            north = 'd',
            south = 'a',
            east = 's',
            west = 'w',
            mod_xy = 1,
            xaxis = 1,
            yaxis = 0,
            mod_ex = 0.707,
            mod_ey = 0.707,
            mod_wx = 0.707,
            mod_wy = -0.707
        },
        -- UP
        ['w'] = {
            north = 'w',
            south = 's',
            east = 'd',
            west = 'a',
            mod_xy = -1,
            xaxis = 0,
            yaxis = 1,
            mod_ex = 0.707,
            mod_ey = -0.707,
            mod_wx = -0.707,
            mod_wy = -0.707
        },
        -- DOWN
        ['s'] = {
            north = 's',
            south = 'w',
            east = 'a',
            west = 'd',
            mod_xy = 1,
            xaxis = 0,
            yaxis = 1,
            mod_ex = -0.707,
            mod_ey = 0.707,
            mod_wx = 0.707,
            mod_wy = 0.707
        }
    } 

    self.animations = {
        ['idle'] = Animation({
            texture = self.texture,
            frames = {
                self.frames[1]
            }
        }),
        ['walking'] = Animation({
            texture = self.texture,
            frames = {
                self.frames[2], self.frames[3]
            },
            interval = 0.1
        }),
        ['casting_fire_charge'] = Animation({
            texture = self.texture,
            frames = {
                self.frames[5], self.frames[6]
            },
            interval = 0.7
        }),
        ['casting_fire_high'] = Animation({
            texture = self.texture,
            frames = {
                self.frames[7]
            }
        }),
        ['casting_fire_peak'] = Animation({
            texture = self.texture,
            frames = {
                self.frames[8], self.frames[9]
            },
            interval = 0.2
        }),
        ['casting_fire_release'] = Animation({
            texture = self.texture,
            frames = {
                self.frames[10], self.frames[11], self.frames[10], self.frames[11], self.frames[12]
            },
            interval = 0.08
        }),
        ['casting_frost_release'] = Animation({
            texture = self.texture,
            frames = {
                self.frames[10], self.frames[11], self.frames[10], self.frames[11], self.frames[12]
            },
            interval = 0.12
        }),
    }

    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()
    self.movement = self.movements['none']

    self.behaviours = {
        ['startup'] = function(dt)

            self.animation = self.animations['idle']

            if self:movement_func() then
                self.state = 'walking'
            end

            if love.keyboard.wasPressed('space') then
                self.state = 'casting_fire_charge'
            end

        end,

        ['idle'] = function(dt)

            fireball_timer = 0

            self.animations['casting_fire_charge']:restart()
            self.animation = self.animations['idle']

            if self:movement_func() then
                self.state = 'walking'
            end

            if love.keyboard.wasPressed('space') then
                if ICE_ACTIVE == true then
                    self.dx = 0
                    self.dy = 0
                    self.state = 'casting_frost_release'
                else
                   self.state = 'casting_fire_charge'
                end
            end

        end,

        ['walking'] = function(dt)

            fireball_timer = 0

            self.animation = self.animations['walking']

            if not self:movement_func() then
                self.dx = 0
                self.dy = 0
                self.state = 'idle'
            end

            if love.keyboard.wasPressed('space') then
                if ICE_ACTIVE == true then
                    self.dx = 0
                    self.dy = 0
                    self.state = 'casting_frost_release'
                else
                   self.state = 'casting_fire_charge'
                end
            end



        end,

        ['casting_fire_charge'] = function(dt)

            fireball_timer = fireball_timer + dt * tick

            self.dx = 0
            self.dy = 0                       
            self.animation = self.animations['casting_fire_charge']
    
            if love.keyboard.wasReleased('space') then
                self.state = 'idle'       
            elseif fireball_timer >= 6 and FIREBALLS_ACTIVE == true then
                
                self.state = 'casting_fire_high'

            elseif fireball_timer >= 1 and FIREBALLS_ACTIVE == false then

                self.state = 'idle'

            elseif self:movement_func() then
                self.state = 'walking'
            end

        end,

        ['casting_fire_high'] = function(dt)

            fireball_usage = 1
            fireball_scale = 1
            FIREBALL_SPEED = SMALL_FIREBALL_SPEED
            fireball_timer = fireball_timer + dt * tick

            self.animation = self.animations['casting_fire_high']

            if love.keyboard.wasReleased('space') then
                self.state = 'casting_fireball'
            elseif fireball_timer >= 12 then
                self.state = 'casting_fire_peak'
            elseif self:movement_func() then
                self.state = 'walking'
            end        
        end,

        ['casting_fire_peak'] = function(dt)

            fireball_usage = 3
            fireball_scale = 2
            FIREBALL_SPEED = BIG_FIREBALL_SPEED
            fireball_timer = fireball_timer + dt * tick
            
            self.animation = self.animations['casting_fire_peak']

            if love.keyboard.wasReleased('space') then 
                self.state = 'casting_fireball'
            elseif self:movement_func() then
                self.state = 'walking'
            end
        end,

        ['casting_fireball'] = function(dt)

            fireball_timer = 0

            local aim_x = MOUSE_X
            local aim_y = MOUSE_Y

            self.fireball:spawn_fireball(self.x + self.xOffset, self.y + self.yOffset, aim_x, aim_y, fireball_scale)
            remaining_fireballs = remaining_fireballs - fireball_usage

            self.state = 'casting_fire_release'
        end,

        ['casting_fire_release'] = function(dt)

            fireball_timer = fireball_timer + dt * tick
            self.animation = self.animations['casting_fire_release']

            if remaining_fireballs < 1 then
                FIREBALLS_ACTIVE = false
                for i, v in ipairs(Map_items) do
                    if v.item == BLANK_FIRE then
                        v.item = FIRE_POTION
                    end
                end 
            end

            if fireball_timer > 2 then
                self.state = 'idle'
            elseif self:movement_func() then
                self.state = 'walking'
            end

        end,
        ['casting_frost_release'] = function(dt)

            local aim_x = MOUSE_X
            local aim_y = MOUSE_Y
            CASTING_FROST = true
            self.frostray:spawn_frostray(self.x + self.xOffset, self.y + self.yOffset, aim_x, aim_y)

            -- if active_direction == 'd' then
            --     self.dx = -15
            -- elseif active_direction == 'a' then
            --     self.dx = 15
            -- elseif active_direction == 'w' then
            --     self.dy = 15
            -- elseif active_direction == 's' then
            --     self.dy = -15
            -- end

            self.animation = self.animations['casting_frost_release']
            ice_timer = ice_timer - dt
        
            if love.keyboard.wasReleased('space') then
                CASTING_FROST = false
                self.dx = 0
                self.dy = 0
                self.state = 'idle'     
            elseif self:movement_func() then
                CASTING_FROST = false
                self.state = 'walking'
            elseif ice_timer < 0 then
                CASTING_FROST = false
                ICE_ACTIVE = false
                for i, v in ipairs(Map_items) do
                    if v.item == BLANK_ICE then
                        v.item = ICE_POTION
                    end
                end
                self.state = 'idle'     
            end
            
        end
    }
end

function Wizard:update(dt)

    self.behaviours[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.fireball:fireball_update(dt)
    self.frostray:frostray_update(dt)


    self:check_map_tile_collisions()
    self:check_item_collisions()

    self:target_tiles()
    self:potion_mechanics()
        
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    self.y1 = self.y + self.height
    self.x1 = self.x + self.width

end


-- Mechanics

function Wizard:movement_func()

    if love.keyboard.isDown('a') then
        active_direction = 'a'
    elseif love.keyboard.isDown('d') then
        active_direction = 'd'
    elseif love.keyboard.isDown('w') then
        active_direction = 'w'
    elseif love.keyboard.isDown('s') then
        active_direction = 's'
    end

    while love.keyboard.isDown(active_direction) do
    -- imagine that NORTH becomes the active direction
    -- calculates movements relative to the new NORTH, essentially enables diagonal movement

        self.state = 'walking'
            self.animation = self.animations['walking']
            self.direction = active_direction

            -- moving NORTH WEST
            if love.keyboard.isDown(self.movements[active_direction].west) then
                self.dx = WALKING_SPEED * self.movements[active_direction].mod_wx
                self.dy = WALKING_SPEED * self.movements[active_direction].mod_wy

            -- moveing NORTH EAST
            elseif love.keyboard.isDown(self.movements[active_direction].east) then
                self.dx = WALKING_SPEED * self.movements[active_direction].mod_ex
                self.dy = WALKING_SPEED * self.movements[active_direction].mod_ey

            else -- NORTH
                self.dx = WALKING_SPEED * self.movements[active_direction].xaxis * self.movements[active_direction].mod_xy
                self.dy = WALKING_SPEED * self.movements[active_direction].yaxis * self.movements[active_direction].mod_xy
            end

        return true
    end
    return false
end

function Wizard:potion_mechanics()
    if self:check_item_interactions(interact_item_rectangles) then
        if item_id == FIRE_POTION and FIREBALLS_ACTIVE == false then
            FIREBALLS_ACTIVE = true
            ICE_ACTIVE = false
            remaining_fireballs = 10
            for i, v in ipairs(Map_items) do
                if v.item == FIRE_POTION then
                    v.item = BLANK_FIRE
                elseif v.item == BLANK_ICE then
                    v.item = ICE_POTION
                end
            end 
        elseif item_id == ICE_POTION and ICE_ACTIVE == false then
            FIREBALLS_ACTIVE = false
            ICE_ACTIVE = true
            ice_timer = 7
            for i, v in ipairs(Map_items) do
                if v.item == ICE_POTION then
                    v.item = BLANK_ICE
                elseif v.item == BLANK_FIRE then
                    v.item = FIRE_POTION

                end
            end
        elseif item_id == BOOK1_CL then
                    self.items:placeItem(BOOK1_L, 31, 49, 6, -3, 0)
                    self.items:placeItem(BOOK1_R, 31, 49, 6 + 19, -3, 0)


        end
    end
end

-- MAP COLLISIONS
function Wizard:check_map_tile_collisions()

    self:check_U_collision()
    self:check_D_collision()
    self:check_L_collision()
    self:check_R_collision()

end

function Wizard:check_U_collision()
    
    if self.dy < 0 then

        if self.map:collides(self.map:tileAt(self.x, self.y - 1)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y - 1)) then
           
            self.dy = 0
            self.y = self.map:tileAt(self.x, self.y - 1).y * self.map.tileHeight

        end
    end
end

function Wizard:check_D_collision()
    
    if self.dy > 0 then
 
        if self.map:collides(self.map:tileAt(self.x, self.y1)) or
        self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y1)) then

        self.dy = 0
        self.y = (self.map:tileAt(self.x, self.y1).y - 1) * self.map.tileHeight - self.height

        end
    end
end

function Wizard:check_L_collision()
    
    if self.dx < 0 then

        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
           
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth

        end
    end
end

function Wizard:check_R_collision()
    
    if self.dx > 0 then
 
        if self.map:collides(self.map:tileAt(self.x1, self.y)) or
        self.map:collides(self.map:tileAt(self.x1, self.y + self.height - 1)) then

        self.dx = 0
        self.x = (self.map:tileAt(self.x1, self.y).x - 1) * self.map.tileWidth - self.width

        end
    end
end

-- MAP TILE INTERACTIONS
function Wizard:check_on_tile_type(tile_type)

    if self.map:tileAt(self.x, self.y).id == tile_type or           
        self.map:tileAt(self.x, self.y1).id == tile_type or      
        self.map:tileAt(self.x1, self.y).id == tile_type or      
        self.map:tileAt(self.x1, self.y1).id == tile_type then     
            
        return true
        
    else
        return false
    end
end

function Wizard:check_specific_tile(target_x, target_y)

    if (math.ceil(self.x / map.tileWidth) + 1 == target_x or (math.floor(self.x / map.tileWidth) + 1 == target_x)) and 
    (math.ceil(self.y / map.tileWidth) + 1 == target_y or math.floor(self.y / map.tileWidth) + 1 == target_y) then
        return true
    else
        return false
    end

end

function Wizard:target_tiles()

    if self:check_specific_tile(12, 30) and FIREBALLS_ACTIVE == true then

        self.map:setTile(12, 30, FIRE_TILE_ON)
        ON_FIRE_TILE = true
        
    else
        self.map:setTile(12, 30, FIRE_TILE_OFF)
        ON_FIRE_TILE = false
    end

    if self:check_specific_tile(49, 30) and ICE_ACTIVE == true then

        self.map:setTile(49, 30, ICE_TILE_ON)
        ON_ICE_TILE = true
        
    else
        self.map:setTile(49, 30, ICE_TILE_OFF)
        ON_ICE_TILE = false
    end

end


-- ITEM COLLISIONS + INTERACTIONS
function Wizard:check_item_collisions()

    if self:check_item_Up_collision(collide_item_rectangles) then
        self.dy = 0
        self.y = y_stop
    elseif self:check_item_Down_collision(collide_item_rectangles) then
        self.dy = 0
        self.y = y_stop
    elseif self:check_item_Left_collision(collide_item_rectangles) then
        self.dx = 0
        self.x = x_stop
    elseif self:check_item_Right_collision(collide_item_rectangles) then
        self.dx = 0
        self.x = x_stop
    end

end

function Wizard:check_item_interactions(interaction_table)

    if self:check_item_Up_collision(interaction_table) or
        self:check_item_Down_collision(interaction_table) or
        self:check_item_Left_collision(interaction_table) or
        self:check_item_Right_collision(interaction_table) then
        return true
    else 
        return false
    end
end

function Wizard:check_item_Up_collision(collide_type_table)

    if self.dy < 0 then

        for i, v in ipairs(collide_type_table) do
            if self.x < v.col_x1 - 3 and self.x1 > v.col_x0 + 3 and self.y < v.col_y1 + 1 and self.y1 > v.col_y1  then
                y_stop = v.col_y1
                item_id = v.item_id
                return y_stop, item_id, true
            end
        end
    end
    return false
end

function Wizard:check_item_Down_collision(collide_type_table)

    if self.dy > 0 then

        for i, v in ipairs(collide_type_table) do
            if self.x < v.col_x1 - 3 and self.x1 > v.col_x0 + 3 and self.y1 > v.col_y0 - 1 and self.y < v.col_y0 then
                y_stop = v.col_y0 - self.height
                item_id = v.item_id
                return y_stop, item_id, true
            end
        end
    end
    return false
end

function Wizard:check_item_Left_collision(collide_type_table)

    if self.dx < 0 then

        for i, v in ipairs(collide_type_table) do
            if self.y < v.col_y1 - 3 and self.y1 > v.col_y0 + 3 and self.x < v.col_x1 + 1 and self.x1 > v.col_x1 then
                x_stop = v.col_x1
                item_id = v.item_id
                return x_stop, item_id, true
            end
        end
    end
    return false
end

function Wizard:check_item_Right_collision(collide_type_table)

    if self.dx > 0 then
        for i, v in ipairs(collide_type_table) do
            if self.y < v.col_y1 - 3 and self.y1 > v.col_y0 + 3 and self.x1 > v.col_x0 - 1 and self.x < v.col_x0 then
                x_stop = v.col_x0 - self.width
                item_id = v.item_id
                return x_stop, item_id, true
            end
        end
    end
    return false
end

local x_scale = 1
local x_pos_shift = 0

function Wizard:render()


    if MOUSE_X - self.x - self.xOffset > 0 then
        x_scale = -1
        x_pos_shift = self.width
    else
        x_scale = 1
        x_pos_shift = 0
    end


        
    love.graphics.draw(self.texture, self.currentFrame, self.x + x_pos_shift, self.y, 0, x_scale, 1)
    if love.mouse.isDown(2) then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.line(self.x + self.xOffset, self.y + self.yOffset, MOUSE_X, MOUSE_Y)
    end

    love.graphics.setColor(1, 1, 1, 1)
    self.fireball:fireball_render()

    if CASTING_FROST == true then
        love.graphics.setColor(1, 1, 1, 1)
        self.frostray:frostray_render(self.x + self.xOffset, self.y + (self.yOffset - 16))
    end
    love.graphics.setFont(defaultfont)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("x: " ..string.format("%.0f", self.x), self.map.camX + 20, self.map.camY + 70)
    love.graphics.print("y: " ..string.format("%.0f", self.y), self.map.camX + 20, self.map.camY + 80)
    love.graphics.print("tile x: " ..string.format("%.1f", 1 + (self.x / map.tileWidth)), self.map.camX + 20, self.map.camY + 90)
    love.graphics.print("tile y: " ..string.format("%.1f", 1 + (self.y / map.tileWidth)), self.map.camX + 20, self.map.camY + 100)
    love.graphics.print("dx: " ..string.format("%.2f", self.dx), self.map.camX + 20, self.map.camY + 110)
    love.graphics.print("dy: " ..string.format("%.2f", self.dy), self.map.camX + 20, self.map.camY + 120)


    love.graphics.print("mouse x: " ..string.format("%.2f", MOUSE_X), self.map.camX + 20, self.map.camY + 140)
    love.graphics.print("mouse y: " ..string.format("%.2f", MOUSE_Y), self.map.camX + 20, self.map.camY + 150)
    love.graphics.print("diff x: " ..string.format("%.2f", MOUSE_X - self.x - self.xOffset), self.map.camX + 20, self.map.camY + 160)
    love.graphics.print("diff y: " ..string.format("%.2f", MOUSE_Y -self.y - self.yOffset), self.map.camX + 20, self.map.camY + 170)
    love.graphics.print("angle: " ..string.format((180 / math.pi)*(math.atan((MOUSE_Y - self.y - self.yOffset)/(MOUSE_X - self.x - self.xOffset)))), self.map.camX + 20, self.map.camY + 180)

    love.graphics.print("state: " ..tostring(self.state), self.map.camX + 20, self.map.camY + 190)
    love.graphics.print("direction: " ..tostring(self.direction), self.map.camX + 20, self.map.camY + 200)
    love.graphics.print("active_direction " ..tostring(active_direction), self.map.camX + 20, self.map.camY + 210)

    love.graphics.print("FIREBALLS_ACTIVE: " ..tostring(FIREBALLS_ACTIVE), self.map.camX + 20, self.map.camY + 230)
    love.graphics.print("remaining_fireballs: " ..tostring(remaining_fireballs), self.map.camX + 20, self.map.camY + 240)
    love.graphics.print("Fireball timer: " ..string.format("%.2f", fireball_timer), self.map.camX + 20, self.map.camY + 250)
    love.graphics.print("Fireball scale: " ..string.format(fireball_scale), self.map.camX + 20, self.map.camY + 260)

    love.graphics.print("ICE_ACTIVE: " ..tostring(ICE_ACTIVE), self.map.camX + 20, self.map.camY + 280)
    love.graphics.print("CASTING_FROST: " ..tostring(CASTING_FROST), self.map.camX + 20, self.map.camY + 290)
    love.graphics.print("ice_timer: " ..string.format("%.2f", ice_timer), self.map.camX + 20, self.map.camY + 300)

    love.graphics.print("active orbs: " ..string.format(ACTIVE_FB_ORBS), self.map.camX + 20, self.map.camY + 320)

end
