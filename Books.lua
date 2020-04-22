
------------------------------------------------------------------------------------------------------------------------
-- Game initialisers
mouse_img = love.graphics.newImage('master_graphics/Map/pointer.png')

sounds = {
    ['tile1'] = love.audio.newSource('master_sounds/WQ_tile1.wav', 'static'),
    ['tile2'] = love.audio.newSource('master_sounds/WQ_tile2.wav', 'static'),
    ['tile3'] = love.audio.newSource('master_sounds/WQ_tile3.wav', 'static'),
    ['knock'] = love.audio.newSource('master_sounds/WQ_knock.wav', 'static'),
    ['scroll'] = love.audio.newSource('master_sounds/WQ_scroll.wav', 'static'),
    ['fireball'] = love.audio.newSource('master_sounds/WQ_fireball.wav', 'static'),
    ['firecharge'] = love.audio.newSource('master_sounds/WQ_firecharge.wav', 'static'),
    ['firecharge_big'] = love.audio.newSource('master_sounds/WQ_firecharge_big.wav', 'static'),
    ['firehit'] = love.audio.newSource('master_sounds/WQ_firehit.wav', 'static'),
    ['nocast'] = love.audio.newSource('master_sounds/WQ_nocast.wav', 'static'),
    ['frostray'] = love.audio.newSource('master_sounds/WQ_frostray.wav', 'static'),
    ['magic_swoosh'] = love.audio.newSource('master_sounds/WQ_magic1.wav', 'static'),
    ['magic_chord'] = love.audio.newSource('master_sounds/WQ_magic_hit_chord.wav', 'static'),
    ['orb1'] = love.audio.newSource('master_sounds/WQ_magic_hit1.wav', 'static'),
    ['orb2'] = love.audio.newSource('master_sounds/WQ_magic_hit2.wav', 'static'),
    ['orb3'] = love.audio.newSource('master_sounds/WQ_magic_hit3.wav', 'static'),
    ['orb4'] = love.audio.newSource('master_sounds/WQ_magic_hit4.wav', 'static'),
    ['orb5'] = love.audio.newSource('master_sounds/WQ_magic_hit5.wav', 'static'),
    ['portcullis'] = love.audio.newSource('master_sounds/WQ_portcullis.wav', 'static'),
    ['potion_grab'] = love.audio.newSource('master_sounds/WQ_potion_cork.wav', 'static'),
    ['potion_gone'] = love.audio.newSource('master_sounds/WQ_potiongone.wav', 'static'),
    ['wiz_cast'] = love.audio.newSource('master_sounds/wizard_cast.wav', 'static'),
    ['wiz_nocast'] = love.audio.newSource('master_sounds/wizard_nocast.wav', 'static'),
    ['wiz_ooh1'] = love.audio.newSource('master_sounds/wizard_ooh1.wav', 'static'),
    ['wiz_ooh2'] = love.audio.newSource('master_sounds/wizard_ooh2.wav', 'static'),
    ['wiz_hit1'] = love.audio.newSource('master_sounds/wizard_hit1.wav', 'static'),
    ['wiz_hit2'] = love.audio.newSource('master_sounds/wizard_hit2.wav', 'static'),
    ['wiz_hit3'] = love.audio.newSource('master_sounds/wizard_hit3.wav', 'static')
}
------------------------------------------------------------------------------------------------------------------------
-- WIZARD tile check initialisations
ON_ICE_TILE = false
ON_FIRE_TILE = false
FIREBALLS_ACTIVE = false
ICE_ACTIVE = false
check_tile = 0
------------------------------------------------------------------------------------------------------------------------
-- Book text list
BOOK_TEXT = {}

BOOK_TEXT[1] = [[               Fire potions give you the fireball spell.       
Hold space to charge up a fireball, and release to cast.
Fire causes damage, and interacts with certain materials . . .
]]

BOOK_TEXT[2] = [[ Frost spells will affect some materials, and slow down enemies.
Hold space to cast a frost-ray, use the mouse pointer to aim.
Remember, you can only drink one type of potion at a time. . . 
]]

BOOK_TEXT[3] = [[                             Welcome traveller. 
Solve the puzzles to open the portcullis to the next chamber. . .
         { TIP - Hold right click to find the mouse pointer }
]]
------------------------------------------------------------------------------------------------------------------------
-- Tile ID list
TILE_EMPTY = 40

DIRT = 1
DIRT_COLLIDABLE = 39
SQUARE = 21
WALL = 4
WALL_TORCH = 5
WALL_WINDOW = 25
PILLAR = 24
PILLAR_2 = 28
WALL_TL = 14
WALL_TR = 15
WALL_BL = 34
WALL_BR = 35

BOOKSHELF = 36

WOOD_H = 16
WOOD_V = 17
WOOD_H_BURNT = 37
WOOD_V_BURNT = 38
WOOD_H_FROZEN = 18
WOOD_V_FROZEN = 19

ALCOVE_ORB_OFF_N = 10
ALCOVE_ORB_OFF_S = 12
ALCOVE_ORB_OFF_E = 6
ALCOVE_ORB_OFF_W = 8
ALCOVE_ORB_ON_N = 11
ALCOVE_ORB_ON_S = 13
ALCOVE_ORB_ON_E = 7
ALCOVE_ORB_ON_W = 9

FLOOR_ORB_OFF = 26
FLOOR_ORB_ON = 27

FIRE_TILE_OFF = 2
FIRE_TILE_ON = 3
ICE_TILE_OFF = 22
ICE_TILE_ON = 23
-----------------------------------------------------------------------------------------------------------------------
-- Item ID list
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
BOOK2_R = 11
BOOK3_L = 15
BOOK3_R = 16
BOOK3_CL = 17

TABLE1A = 12
TABLE2A = 13
TABLE3A = 14
TABLE1B = 44
TABLE2B = 45
TABLE3B = 46

BLANK_FIRE = 20
BLANK_ICE = 21
BLANK_BOOK = 22
-----------------------------------------------------------------------------------------------------------------------