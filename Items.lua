Items = Class{}

HEALTH_POTION = 1
MANA_POTION = 2
SPEED_POTION = 3   
FIRE_POTION = 4
ICE_POTION = 5
BOOK1_L = 6
BOOK1_R = 7
BOOK1_CL = 8
BOOK2_CL = 9
BOOK2_L = 10
BOOK2_L = 11

TABLE1A = 12
TABLE2A = 13
TABLE3A = 14
TABLE1B = 44
TABLE2B = 45
TABLE3B = 46

BLANK_FIRE = 20
BLANK_ICE = 21
BLANK_BOOK = 22



function Items:init(map)

    self.potion_spritesheet = love.graphics.newImage('master_graphics/Map/Potions.png')
    self.potion_sprites = generateQuads(self.potion_spritesheet, 19, 24)
    
    self.itemWidth = 19
    self.itemHeight = 24

    Map_items = {}
    
    item_collidables = {
        TABLE1A, TABLE2A, TABLE3A
    }

    collide_item_rectangles = {}
    interact_item_rectangles = {}

    item_interact = {BOOK1_CL, FIRE_POTION, ICE_POTION}

    self:placeItem(TABLE1A, 30, 49, 0, 0, 0)
    self:placeItem(TABLE2A, 30, 49, 19, 0, 0)
    self:placeItem(TABLE2A, 30, 49, 19 + 19, 0, 0)
    self:placeItem(TABLE3A, 30, 49, 19 + 19 + 19, 0, 0)
    self:placeItem(TABLE1B, 30, 49, 0, 24, 0)
    self:placeItem(TABLE2B, 30, 49, 19, 24, 0)
    self:placeItem(TABLE2B, 30, 49, 19 + 19, 24, 0)
    self:placeItem(TABLE3B, 30, 49, 19 + 19 + 19, 24, 0)

    self:placeItem(TABLE1A, 45, 32, 0, -6, 0)
    self:placeItem(TABLE1B, 45, 32, 0, 24 - 6, 0)
    self:placeItem(TABLE3A, 45, 32, 19, -6, 0)
    self:placeItem(TABLE3B, 45, 32, 19, 24 - 6, 0)


    self:placeItem(BOOK2_CL, 45, 32, 6, -9, 0)

    self:placeItem(FIRE_POTION, 7, 30, 4, 6, 0)
    self:placeItem(ICE_POTION, 54, 30, 4, 6, 0)
    self:placeItem(FIRE_POTION, 30, 49, 4, -6, 0)
    self:placeItem(BOOK1_CL, 31, 49, 6, -3, 0)


    -- self:placeItem(BOOK_L, 15, 28, 32 - 19, 6, 0)
    -- self:placeItem(BOOK_R, 16, 28, 0, 6, 0)
    -- self:placeItem(BOOK_L, 45, 28, 32 - 19, 6, 0)
    -- self:placeItem(BOOK_R, 46, 28, 0, 6, 0)
    -- self:placeItem(BOOK_L, 28, 28, 32 - 19, 6, 0)
    -- self:placeItem(BOOK_R, 29, 28, 0, 6, 0)

    self:generate_collide_rectangles(item_collidables, collide_item_rectangles)
    self:generate_collide_rectangles(item_interact, interact_item_rectangles)

end


function Items:placeItem(item_id, tile_x, tile_y, fine_x, fine_y, rotation)

    table.insert(Map_items, {item = item_id, item_x = ((tile_x - 1) * 32) + fine_x, 
                                    item_y = ((tile_y - 1) * 32) + fine_y, 
                                    item_angle = rotation * (math.pi / 180)})

end

function Items:placeTable(x, y, fx, fy)

    self:placeItem(TABLE1A, x, y, fx, fy, 0)
    self:placeItem(TABLE2A, x, y, fx + 19, fy, 0)
    self:placeItem(TABLE3A, x, y, fx + 19 + 19, fy, 0)
    self:placeItem(TABLE1B, x, y, fx, fy + 24, 0)
    self:placeItem(TABLE2B, x, y, fx + 19, fy + 24, 0)
    self:placeItem(TABLE3B, x, y, fx + 19 + 19, fy + 24, 0)
end

function Items:generate_collide_rectangles(collidable_list, collidable_table)

    for i, v in ipairs(collidable_list) do
        for ii, vv in ipairs(Map_items) do
            if v == vv.item then
                -- if v.item_angle == 0 then
                table.insert(collidable_table, {item_id = vv.item, col_x0 = vv.item_x, col_y0 = vv.item_y,
                                            col_x1 = vv.item_x + self.itemWidth, 
                                            col_y1 = vv.item_y + self.itemHeight})
                -- elseif item_angle / (math.pi / 180) == 180 then
                --     table.insert(item_rectangles, {col_x1 = v.item_x, col_y1 = v.item_y,
                --                                 col_x0 = v.item_x + self.itemWidth, 
                --                                 col_y0 = v.item_y + self.itemHeight})

                -- elseif item_angle / (math.pi / 180) == 90 then
                --     table.insert(item_rectangles, {col_x0 = v.item_x, col_y1 = v.item_y,
                --                                 col_x1 = v.item_x + self.itemWidth, 
                --                                 col_y0 = v.item_y + self.itemHeight})
                -- elseif item_angle / (math.pi / 180) == 270 then
                --     table.insert(item_rectangles, {col_x1 = v.item_x, col_y1 = v.item_y,
                --                                 col_x0 = v.item_x + self.itemWidth, 
                --                                 col_y0 = v.item_y + self.itemHeight})
                
            end
        end
    end
end


function Items:update(dt)

end

function Items:render()

    for i, v in ipairs(Map_items) do
        love.graphics.draw(self.potion_spritesheet, self.potion_sprites[v.item], v.item_x, v.item_y, v.angle)
    end

end