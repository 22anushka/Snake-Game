Game = Class {}


function Game:init()
    self.snake_x = 0
    self.snake_y = 0

    offset_x = ((VIRTUAL_WIDTH - INNER_BOX_X) / 2)
    offset_y = ((VIRTUAL_HEIGHT - INNER_BOX_Y) / 2)

    Game:add_apple()
    
    self.tail_length = 0
    
    self.old_x = 0
    self.old_y = 0

    self.dx = 0
    self.dy = 0

    self.old_dx = self.dx
    self.old_dy = self.dy

    x = 0
    y = 0

    left = false
    right = false
    down = false
    up = false

    tail = {}

    -- https://opengameart.org/content/grass-pixel-art
    -- by txturs
    self.grass_texture = love.graphics.newImage('graphics/grass.png')
    self.grass_frame = generateQuads(self.grass_texture, INNER_BOX_X, INNER_BOX_Y)

    self.apple = love.graphics.newImage('graphics/apple.png')
    self.apple_frame = generateQuads(self.apple, SIZE, SIZE)
    
    self.snake = love.graphics.newImage('graphics/sneku.png')
    self.snake_frame = generateQuads(self.snake, SIZE, SIZE)

    self.sounds = {
        -- 'eat' from https://github.com/eugeneloza/SnakeGame
        ['eat'] = love.audio.newSource('sounds/eat.wav', 'static'),
        ['death'] = love.audio.newSource('sounds/empty-block.wav', 'static') -- from cs50 mario games track
    }
    
end

function Game:add_apple()
    -- randomize apple's position
    self.apple_x = math.random(0, (INNER_BOX_X / SIZE) - 1)
    self.apple_y = math.random(0, (INNER_BOX_Y / SIZE) - 1)
end


function Game:update(dt)

    
    self.old_x = self.snake_x
    self.old_y = self.snake_y
    self.old_dx = self.dx
    self.old_dy = self.dy
    self.snake_x = self.snake_x + self.dx 
    self.snake_y = self.snake_y + self.dy 

    if self.snake_x == self.apple_x and self.snake_y == self.apple_y then
        self.sounds['eat']:play()
        Game:add_apple()
        self.tail_length = self.tail_length + 1
        table.insert(tail, {0, 0, 0, 0})
        if mode == 'challenge' then
            -- speed increases by 10% of present speed value
            value = value - (0.1 * value)
        end
    end

    if self.tail_length > 0 then
        -- swapping in such a way so that the tail FOLLOWS movement of the head and attaches behind previous tail
        -- saves most recent previous position after eating the apple
        -- recent positions i.e v[] is given value of the previous body's old position to join to it 

        for _, v in ipairs(tail) do
            i = v[1]
            j = v[2]
            k = v[3]
            l = v[4]
            v[1] = self.old_x
            v[2] = self.old_y
            v[3] = self.old_dx
            v[4] = self.old_dy
            self.old_x = i
            self.old_y = j
            self.old_dx = k
            self.old_dy = l
        end
    end

    -- if the snake collides with itself end game    
    for _,v in ipairs(tail) do
        if self.snake_x == v[1] and self.snake_y == v[2] then
            self.sounds['death']:play()
            Game_state = 'end'
            self.dx = 0
            self.dy = 0
        end
    end

    -- if snake crosses boundaries, end game
    if self.snake_x < 0 or self.snake_x >= INNER_BOX_X / SIZE or 
        self.snake_y < 0 or self.snake_y  >= INNER_BOX_Y / SIZE then
        self.sounds['death']:play()
        Game_state = 'end'
        self.snake_x = self.snake_x - self.dx
        self.snake_y = self.snake_y - self.dy
        self.dx = 0
        self.dy = 0
    end

    if self.tail_length >= (INNER_BOX_X / SIZE) * (INNER_BOX_Y / SIZE) - 2 then
        Game_state = 'victory'
        self.dx = 0
        self.dy = 0
        return
    end
        
    if time[1] >= 25 then
        Game_state = 'end'
    end

end

function Game:render()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("SCORE: ".. tostring(self.tail_length), offset_x + 2, 2)

    love.graphics.print(string.format("TIME: %02d:%02d:%02d ", time[1], time[2], time[3]), INNER_BOX_X - offset_x - 80, 2)

    local start_x = 0
    local start_y = 0

    --[[ orientation in radians
        adding size by 2 as part of offseting it by size/2 i.e making the origin as size/2
        multiplying twice by self.dy for direction rotation with respect to previous state previous state
    ]] 
    
    -- resets the colour 
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.draw(self.grass_texture, self.grass_frame[1], offset_x, offset_y)


    love.graphics.draw(self.apple, self.apple_frame[1], (self.apple_x * SIZE) + offset_x,
        (self.apple_y * SIZE) + offset_y)
    

    -- snake
    if self.dx == 0 and self.dy == 0 and Game_state == 'play' then
        love.graphics.draw(self.snake, self.snake_frame[3], (self.snake_x * SIZE) + offset_x, (self.snake_y * SIZE) + offset_y)
    end
    
    love.graphics.draw(self.snake, self.snake_frame[3], (self.snake_x * SIZE) + offset_x + SIZE / 2,
        (self.snake_y * SIZE) + offset_y + SIZE/2, ((3.14 / 2) * self.dy * self.dy), self.dx + self.dy, 1, SIZE/2 , SIZE / 2)

    if self.tail_length < 1 then
        love.graphics.draw(self.snake, self.snake_frame[1], (self.old_x * SIZE) + offset_x + SIZE/2, (self.old_y * SIZE) + offset_y + SIZE/2,
        ((3.14/2) * (self.old_dy)  * (self.old_dy)), self.dx + self.dy, 1, SIZE / 2, SIZE / 2)  
    end
    
    -- position of character, rotation angle,times enlargement (x,y), point flipping positions from
    for _, v in ipairs(tail) do
        love.graphics.draw(self.snake, self.snake_frame[1], (self.old_x * SIZE) + offset_x + SIZE/2, (self.old_y * SIZE) + offset_y + SIZE/2,
            ((3.14 / 2) * self.old_dy  * self.old_dy), self.old_dx + self.old_dy, 1, SIZE / 2, SIZE / 2)
        love.graphics.draw(self.snake, self.snake_frame[2], (v[1] * SIZE) + offset_x + SIZE / 2, (v[2] * SIZE) + offset_y + SIZE / 2,
            ((3.14 / 2) * v[4] * v[4]), v[3] + v[4], 1, SIZE/2, SIZE/2)     
    end

    
end


