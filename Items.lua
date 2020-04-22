Items = Class{}

IS_READING_BOOK = {}
for i = 1, 4 do
    IS_READING_BOOK[i] = false
end

-- unique IDs
firepotion_left = 100
icepotion_right = 101
firepotion_bottom = 102
book_open_bottom_L = 103
book_open_bottom_R = 104
icebook_right = 105
book_open_right_L = 106
book_open_right_R = 107
middlebook = 108
middlebook_open_L = 109
middlebook_open_R = 110

t1 = 111
t2 = 112
t3 = 113
tn = 114


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

    -- place tables first

    self:placeItem(TABLE1A, 28, 36, 0, -6, 0, t3)
    self:placeItem(TABLE1B, 28, 36, 0, 24 - 6, 0, t3)
    self:placeItem(TABLE3A, 28, 36, 19, -6, 0, t3)
    self:placeItem(TABLE3B, 28, 36, 19, 24 - 6, 0, t3)

    self:placeItem(TABLE1A, 45, 32, 0, -6, 0, t2)
    self:placeItem(TABLE1B, 45, 32, 0, 24 - 6, 0, t2)
    self:placeItem(TABLE3A, 45, 32, 19, -6, 0, t2)
    self:placeItem(TABLE3B, 45, 32, 19, 24 - 6, 0, t2)

    self:placeItem(TABLE1A, 30, 49, 0, 0, 0, t1)
    self:placeItem(TABLE2A, 30, 49, 19, 0, 0, t1)
    self:placeItem(TABLE2A, 30, 49, 19 + 19, 0, 0, t1)
    self:placeItem(TABLE3A, 30, 49, 19 + 19 + 19, 0, 0, t1)
    self:placeItem(TABLE1B, 30, 49, 0, 24, 0, t1)
    self:placeItem(TABLE2B, 30, 49, 19, 24, 0, t1)
    self:placeItem(TABLE2B, 30, 49, 19 + 19, 24, 0, t1)
    self:placeItem(TABLE3B, 30, 49, 19 + 19 + 19, 24, 0, t1)

    -- Potions
    self:placeItem(ICE_POTION, 54, 30, 4, 6, 0, icepotion_right)
    self:placeItem(FIRE_POTION, 7, 30, 4, 6, 0, firepotion_left)
    self:placeItem(FIRE_POTION, 30, 49, 4, -6, 0, firepotion_bottom)

    -- bottom chamber book
    self:placeItem(BOOK1_CL, 31, 49, 6 + 10, -3, 0, firebook_bottom, -1)
    self:placeItem(BLANK_BOOK, 31, 49, 6, -3, 0, book_open_bottom_L)
    self:placeItem(BLANK_BOOK, 31, 49, 6 + 19, -3, 0, book_open_bottom_R)

    -- right chamber book
    self:placeItem(BOOK2_CL, 45, 32, 0 + 10, -6, 0, icebook_right)
    self:placeItem(BLANK_BOOK, 45, 32, 0, -6, 0, book_open_right_L)
    self:placeItem(BLANK_BOOK, 45, 32,  0 + 19, -6, 0, book_open_right_R)

    -- centre chamber book
    self:placeItem(BOOK3_CL, 28, 36, 0 + 10, -6, 0, middlebook)
    self:placeItem(BLANK_BOOK, 28, 36, 0, -6, 0, middlebook_open_L)
    self:placeItem(BLANK_BOOK, 28, 36,  0 + 19, -6, 0, middlebook_open_R)

    -- Load table of collidable items with the item coodinates
    self:generate_collide_rectangles(item_collidables, collide_item_rectangles)
    self:generate_collide_rectangles(item_interact, interact_item_rectangles)

end


function Items:placeItem(item_id, tile_x, tile_y, fine_x, fine_y, rotation, unique_item_id, scale)

    table.insert(Map_items, {item = item_id, item_x = ((tile_x - 1) * 32) + fine_x, 
                                    item_y = ((tile_y - 1) * 32) + fine_y, 
                                    item_angle = rotation * (math.pi / 180), unique_id = unique_item_id})

end

function Items:placeTable( tile_x, tile_y, fine_x, fine_y)

    self:placeItem(TABLE1A, tile_x, tile_y, fine_x, fine_y, 0, tn)
    self:placeItem(TABLE2A, tile_x, tile_y, fine_x + 19, fine_y, 0, tn)
    self:placeItem(TABLE3A, tile_x, tile_y, fine_x + 19 + 19, fine_y, 0, tn)
    self:placeItem(TABLE1B, tile_x, tile_y, fine_x, fine_y + 24, 0, tn)
    self:placeItem(TABLE2B, tile_x, tile_y, fine_x + 19, fine_y + 24, 0, tn)
    self:placeItem(TABLE3B, tile_x, tile_y, fine_x + 19 + 19, fine_y + 24, 0, tn)

end

function Items:generate_collide_rectangles(collidable_list, collidable_table)

    for i, v in ipairs(collidable_list) do
        for ii, vv in ipairs(Map_items) do
            if v == vv.item then
                -- if v.item_angle == 0 or if v.item_angle == 180 then
                table.insert(collidable_table, {item_id = vv.item, col_x0 = vv.item_x, col_y0 = vv.item_y,
                                            col_x1 = vv.item_x + self.itemWidth, 
                                            col_y1 = vv.item_y + self.itemHeight})
                -- elseif item_angle / (math.pi / 180) == 90 or item_angle / (math.pi / 180) == 270 then
                --     table.insert(item_rectangles, {col_x0 = v.item_x, col_y1 = v.item_y,
                --                                 col_x1 = v.item_x + self.itemWidth, 
                --                                 col_y0 = v.item_y + self.itemHeight})               
            end
        end
    end
end

function Items:render()

    for i, v in ipairs(Map_items) do
        love.graphics.draw(self.potion_spritesheet, self.potion_sprites[v.item], v.item_x, v.item_y, v.item_angle)
    end

end