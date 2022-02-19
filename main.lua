WINDOW_WIDTH = 640
WINDOW_HEIGHT = 640

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 640

INNER_BOX_X = 600
INNER_BOX_Y = 600

SIZE = 30


-- adapted from https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'
-- adapted from https://github.com/Ulydev/push
push = require 'push'

require 'Util'
require 'Game'

--[[
    Runs when the game first starts up to initialize the game
    (only once)
    Screen dimensions, and vsync is responsible for frame rate
]]
function love.load()
    -- sets screen title
    love.window.setTitle('Snake')

    smallFont = love.graphics.newFont('font.ttf', 18)
    victoryFont = love.graphics.newFont('font.ttf', 34)
    
    math.randomseed(os.time())

    -- for crisp non-blur graphics while upscaling and downscaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    time = {0, 0, 0} -- hour, min, second
    total_time = 0
    time_init = 0
    mode = 'null'
    value = 20

    Game_state = 'menu'

    speed = value

    game = Game()


    -- x, y, dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })


end

-- allows game screen to resize appropriately to window
function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if Game_state == 'start' then 
            if mode == 'easy' then
                value = 20
            elseif mode == 'medium' or mode == 'challenge' then
                value = 10
            elseif mode == 'hard' then 
                value = 5
            end
            Game_state = 'play'
            time = {0, 0, 0}
            time_init = os.time()
        elseif Game_state == 'end' or Game_state == 'victory' then 
            Game_state = 'menu'
            game:init()
        end
    end

    if Game_state == 'menu' then
        if key == '1' then
            mode = 'easy'
            Game_state = 'start'
        elseif key == '2' then
            mode = 'medium'
            Game_state = 'start'
        elseif key == '3' then
            mode = 'hard'
            Game_state = 'start'
        elseif key == '4' then
            mode = 'challenge'
            Game_state = 'start'
        end
    end

    if key == 'right'  then
        if not left then
            right = true
            left = false
            up = false
            down = false
            game.dx = 1
            game.dy = 0
        end
    elseif key == 'left' then
        if not right then 
            right = false
            left = true
            up = false
            down = false
            game.dx = -1
            game.dy = 0
        end
    elseif key == 'up' then
        if not down then
            right = false
            left = false
            up = true
            down = false
            game.dx = 0
            game.dy = -1
        end
    elseif key == 'down' then
        if not up then
            right = false
            left = false
            up = false
            down = true
            game.dx = 0
            game.dy = 1
        end
    end
end


function love.update(dt)
    
    math.randomseed(os.time())

    -- speed of the game. lesser the speed, more number of times game:update is called, hence the faster it is
    if Game_state == 'play' then 
        speed = speed - 1
        Display_time()
        if speed < 0 then
            game:update()
            speed = value
        end
    end

    
end


function love.draw()
    push:apply('start')
    
    love.graphics.setFont(smallFont)

    --screen colour in background
    love.graphics.clear(0, 0, 0, 255/255)

    
    love.graphics.setColor(1, 1, 1, 255/255)
    
    if Game_state == 'menu' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("WELCOME TO THE SNAKE GAME!", offset_x, INNER_BOX_Y / 2 - 34, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("Press 1, 2, or 3 to choose a level", offset_x, INNER_BOX_Y / 2 - 12, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("1) EASY", offset_x, INNER_BOX_Y / 2 + 10, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("2) MEDIUM", offset_x, INNER_BOX_Y / 2 + 28, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("3) HARD", offset_x, INNER_BOX_Y / 2 + 45, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("4) CHALLENGE", offset_x, INNER_BOX_Y / 2 + 62, INNER_BOX_X + offset_x, 'center' )
    elseif Game_state == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("WELCOME TO THE SNAKE GAME!", offset_x,INNER_BOX_Y / 2 - 34 , INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("Press ENTER to play or ESCAPE to exit", offset_x, INNER_BOX_Y / 2 - 12,INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("left: <-  right: ->  up: ^ down: v  (arrow keys)", offset_x, INNER_BOX_Y / 2 + 8,INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("Press right: -> and begin", offset_x, INNER_BOX_Y / 2 + 28, INNER_BOX_X + offset_x, 'center')
    end
    
    
    if Game_state == 'play' then 
        game:render()
    end

    if Game_state == 'end' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("GAME OVER!", offset_x, INNER_BOX_Y / 2 - 50, INNER_BOX_X + offset_x, 'center')
        if time[1] >= 25 then
            love.graphics.printf("TIME EXPIRED", offset_x, INNER_BOX_Y / 2 - 80, INNER_BOX_X + offset_x, 'center')
        end
        love.graphics.setFont(smallFont)
        love.graphics.printf("SCORE: ".. tostring(game.tail_length), offset_x,INNER_BOX_Y / 2 - 14 , INNER_BOX_X + offset_x, 'center')
        love.graphics.printf(string.format("TIME: %02d:%02d:%02d ", time[1], time[2], time[3]), offset_x, INNER_BOX_Y / 2 + 4, INNER_BOX_X + offset_x,'center')
        love.graphics.printf("Press ENTER to play again or ESCAPE to exit", offset_x, INNER_BOX_Y / 2 + 22,INNER_BOX_X + offset_x, 'center')
    elseif Game_state == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("GAME COMPLETE!", offset_x, INNER_BOX_Y / 2 - 34, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("VICTORY!!", offset_x, INNER_BOX_Y / 2, INNER_BOX_X + offset_x, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("SCORE: ".. tostring(game.tail_length),  offset_x, INNER_BOX_Y / 2 + 25, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf(string.format("TIME: %02d:%02d:%02d ", time[1], time[2], time[3]), offset_x, INNER_BOX_Y / 2 + 42, INNER_BOX_X + offset_x, 'center')
        love.graphics.printf("Press ENTER to play again or ESCAPE to exit", offset_x, INNER_BOX_Y / 2 + 54, INNER_BOX_X + offset_x, 'center')
    end

    push:apply('end')
end

function Display_time()
    total_time = (os.time() - time_init) -- number of seconds elapsed
    time[3] = total_time % 60
    time[2] = math.floor((total_time / 60) % 60)
    time[1] = math.floor((total_time / (60*60)) % 60)
end
