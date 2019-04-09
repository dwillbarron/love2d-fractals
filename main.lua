local sh_mbrot;
local cv_checkers;
local cv_mbrot;
local num_shadertime = 0;

local move_x = 0;
local move_y = 0;
local zoom_factor = 1;

local last_dt;

local window_w;
local window_h;
local short_dimension;

function love.load()
    love.window.setMode(800, 600, {resizable=true, vsync=true, minwidth=400, minheight=300})
    window_w = 800;
    window_h = 600;
    short_dimension = 600;
end

function love.resize(w, h)
    if cv_mbrot ~= nil then
        cv_mbrot:release()
        cv_mbrot = nil
    end
    window_w = w
    window_h = h
    if (w < h) then short_dimension = w else short_dimension = h end
end

function love.update(dt)
    last_dt = dt
    local cx, cy;
    cx = love.mouse.getX() / window_w;
    cy = love.mouse.getY() / window_h;
    local mspd = 10*dt;
    if love.keyboard.isDown('up') then
        move_y = move_y - mspd / math.exp(zoom_factor)
    end
    
    if love.keyboard.isDown('down') then
        move_y = move_y + mspd / math.exp(zoom_factor)
    end
    if love.keyboard.isDown('left') then
        move_x = move_x - mspd / math.exp(zoom_factor)
    end
    if love.keyboard.isDown('right') then
        move_x = move_x + mspd / math.exp(zoom_factor)
    end
    if love.keyboard.isDown('1') then
        zoom_factor = zoom_factor + dt;
    end
    if love.keyboard.isDown('2') then
        zoom_factor = zoom_factor - dt;
    end
    if zoom_factor > 10 then zoom_factor = 10 end
    if zoom_factor < 1 then zoom_factor = 1 end
    if sh_ripple ~= nil then
        sh_ripple:send('t', num_shadertime)
    end
    if sh_mbrot ~= nil then
        sh_mbrot:send('t', num_shadertime)
        sh_mbrot:send('movexy', {move_x, move_y})
        sh_mbrot:send('shortside', short_dimension)
        sh_mbrot:send('zoomfactor', zoom_factor);
    end
    num_shadertime = num_shadertime + dt;
end

function mbrot_make()
    if (sh_mbrot == nil) then
        sh_mbrot = love.graphics.newShader('mbrot.glsl')
    end
end

function checkers()
    cv_checkers = love.graphics.newCanvas()
    love.graphics.setCanvas(cv_checkers)
    love.graphics.setColor(0, 0, 0, 1);
    love.graphics.rectangle('fill', 0, 0, 330, 330);
    love.graphics.setColor(1, 1, 1, 1);
    local i, j, flip;
    for i = 0, 30, 1 do
        flip = (math.fmod(i, 2) == 0)
        for j = 0, 30, 1 do
            if (flip) then
                love.graphics.rectangle('fill', i*30, j*30, 30, 30)
            end
            if (flip) then
                flip = false
            else
                flip = true
            end
        end
    end
    love.graphics.setCanvas()
end

function mbrot()
    if cv_mbrot == nil then
        cv_mbrot = love.graphics.newCanvas()
    end
    love.graphics.setCanvas(cv_mbrot)
    love.graphics.setShader(sh_mbrot)
    love.graphics.setColor(1,1,1,1);
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
    love.graphics.setShader()
    love.graphics.setCanvas()
end


function rmap()
    cv_rmap = love.graphics.newCanvas()
end

function love.draw()
    if cv_checkers == nil then
        checkers();
    end
    mbrot_make()
    mbrot()
    love.graphics.draw(cv_mbrot);
    love.graphics.print(last_dt*1000 .. "ms", 0, 0);
    love.graphics.print("zoom: " .. zoom_factor, 0, 16);
    love.graphics.print("(" .. move_x .. ", " .. move_y .. ")", 0, 32);
end