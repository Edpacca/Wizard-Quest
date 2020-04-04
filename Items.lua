Items = Class{}

HEALTH_POTION = 1
MANA_POTION = 2
SPEED_POTION = 3   
FIRE_POTION = 4
ICE_POTION = 5
BOOK_L = 6
BOOK_R = 7
BOOK_CL1 = 8
BOOK_CL2 = 9
BLANK_FIRE = 10
BLANK_ICE = 11


function Items:init(map)

    self.potion_spritesheet = love.graphics.newImage('Graphics/Map/Potions.png')
    self.potion_sprites = generateQuads(self.potion_spritesheet, 19, 24)
    
    self.itemWidth = 19
    self.itemHeight = 24

    Map_items = {}
    
    item_collidables = {
        BOOK_L, BOOK_R
    }

    collide_item_rectangles = {}
    interact_item_rectangles = {}

    item_interact = {BOOK_CL1, FIRE_POTION, ICE_POTION}

    self:placeItem(FIRE_POTION, 7, 30, 4, 6, 0)
    self:placeItem(ICE_POTION, 54, 30, 4, 6, 0)
    self:placeItem(BOOK_L, 15, 28, 32 - 19, 6, 0)
    self:placeItem(BOOK_R, 16, 28, 0, 6, 0)
    self:placeItem(BOOK_L, 45, 28, 32 - 19, 6, 0)
    self:placeItem(BOOK_R, 46, 28, 0, 6, 0)
    self:placeItem(BOOK_L, 28, 28, 32 - 19, 6, 0)
    self:placeItem(BOOK_R, 29, 28, 0, 6, 0)

    self:generate_collide_rectangles(item_collidables, collide_item_rectangles)
    self:generate_collide_rectangles(item_interact, interact_item_rectangles)

end


function Items:placeItem(item_id, tile_x, tile_y, fine_x, fine_y, rotation)

    table.insert(Map_items, {item = item_id, item_x = ((tile_x - 1) * 32) + fine_x, 
                                    item_y = ((tile_y - 1) * 32) + fine_y, 
                                    item_angle = rotation * (math.pi / 180)})

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