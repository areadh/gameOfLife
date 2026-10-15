--love.window.setFullscreen(true)
love.window.setMode(800, 600, {resizable = true, fullscreen = false, vsync = true})

values = {
    mapHeight = math.floor((love.graphics.getHeight() / 16)) - 2,
    mapWidth = math.floor((love.graphics.getWidth() / 16)) - 2,
    maxNeighbors = 4,
    minNeighbors = 2,
    tileSize = 16,
}

--////////////--

-- cell map

cells = {}

for x = 1, values.mapWidth do
    cells[x] = {}
    for y = 1, values.mapHeight do
        cells[x][y] = {neighbors = 0, state = 0}
    end
end

--///////////--

functions = {
    timer = 0
}



function functions.getNeighborCells()
    for x = 1, values.mapWidth do
        for y = 1, values.mapHeight do
                local count = 0

            for dx = -1, 1 do --this part counts neighbor cells
                for dy = -1,1 do

                    if dx ~= 0 or dy ~= 0 then --ignoring center cell
                        local nx = x + dx
                        local ny = y + dy
    
                        if cells[nx] and cells[nx][ny] then --updating cell neighbors
                            if cells[nx][ny].state == 1 then
                                count = count + 1
                            end
                        end
                    end
                end    
            end
            cells[x][y].neighbors = count
        end
    end
end

--[[
    original conway's game of life rules
    //Any live cell with fewer than two live neighbors dies
    //Any live cell with two or three live neighbors stays alive
    //Any live cell with more than three live neighbors dies
    //Any dead cell with exactly three live neighbors becomes a live cell
]]
function functions.setNextGeneration()
    for x = 1, values.mapWidth do
        for y = 1, values.mapHeight do

            if cells[x][y].state == 1 and
               (cells[x][y].neighbors == 2 or cells[x][y].neighbors == 3) then
                cells[x][y].state = 1

            elseif cells[x][y].state == 0 and cells[x][y].neighbors == 3 then
                cells[x][y].state = 1

            else
                cells[x][y].state = 0
            end
        end
    end
end

-- a basic delta time based timer. current time + delta time
function functions.setTimer(dt)
    functions.timer = functions.timer + dt
    love.graphics.print(functions.timer, 10, 10)
    if functions.timer >= 0.5 then
        functions.timer = 0
        functions.setNextGeneration()
    end    
end    
    
function functions.drawFrames()
    for x = 1, values.mapWidth do
        for y = 1, values.mapHeight do
            love.graphics.setColor(0.5,0.5,0.5)
            love.graphics.rectangle("line", x  * values.tileSize, y * values.tileSize, values.tileSize, values.tileSize)
        end
    end
end

function functions.drawCells()
    for x = 1, values.mapWidth do
        for y = 1, values.mapHeight do
            if cells[x][y].state == 1 then
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle("fill", x * values.tileSize, y * values.tileSize, values.tileSize, values.tileSize)
            else
                love.graphics.setColor(0,0,0)
                love.graphics.rectangle("fill", x* values.tileSize, y * values.tileSize, values.tileSize, values.tileSize)
            end
        end
    end
end

--////////////--

function love.load()
    --this is a basic glider 
    cells[12][12] = {neighbors = 0, state = 1}
    cells[13][12] = {neighbors = 0, state = 1}
    cells[14][12] = {neighbors = 0, state = 1}
    cells[14][11] = {neighbors = 0, state = 1}
    cells[13][10] = {neighbors = 0, state = 1}
end

function love.update(dt)
    functions.getNeighborCells()
    functions.setTimer(dt)
end

function love.draw()
    functions.drawCells()
    functions.drawFrames()
end
