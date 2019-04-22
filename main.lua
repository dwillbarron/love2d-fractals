local nuklear = require 'nuklear'
local overview = require 'overview'

local sh_mbrot;
local cv_checkers;
local cv_mbrot;
local num_shadertime = 0;
local iter_factor = 10;

local move_x = 0;
local move_y = 0;
local zoom_factor = 1;
local pause = {value = false}
local reset = false;
local colorPicker = {value = '#FF0000'}
local r = 0;
local g = 0;
local b = 0;
local debug = {value = false}

local dt = 0.01;

local window_w;
local window_h;
local short_dimension;

function input(name, ...)
	return ui1[name](ui1, ...)
end

function love.keypressed(key, scancode, isrepeat)
	input('keypressed', key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	input('keyreleased', key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
	input('mousepressed', x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	input('mousereleased', x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	input('mousemoved', x, y, dx, dy, istouch)
end

function love.textinput(text)
	input('textinput', text)
end

function love.wheelmoved(x, y)
	input('wheelmoved', x, y)
end

function love.load()
    love.window.setMode(800, 600, {resizable=true, vsync=true, minwidth=400, minheight=300})
    window_w = 800;
    window_h = 600;
    short_dimension = 600;
    ui1 = nuklear.newUI()
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

function love.update()
    local cx, cy;
    cx = love.mouse.getX() / window_w;
    cy = love.mouse.getY() / window_h;
    local mspd = 15*dt;
    if love.keyboard.isDown('up') then
        move_y = move_y - mspd / math.exp(zoom_factor);
    end
    
    if love.keyboard.isDown('down') then
        move_y = move_y + mspd / math.exp(zoom_factor);
    end
    if love.keyboard.isDown('left') then
        move_x = move_x - mspd / math.exp(zoom_factor);
    end
    if love.keyboard.isDown('right') then
        move_x = move_x + mspd / math.exp(zoom_factor);
    end
    if love.keyboard.isDown('1') then
        zoom_factor = zoom_factor + dt;
        overview.zoomfactor = overview.zoomfactor + dt;
    end
    if love.keyboard.isDown('2') then
        zoom_factor = zoom_factor - dt;
        overview.zoomfactor = overview.zoomfactor - dt;
    end
    if love.keyboard.isDown('r') then
        num_shadertime = 0;
    end
    if zoom_factor > 10 then zoom_factor = 10 end
    if zoom_factor < 1 then zoom_factor = 1 end
    if sh_ripple ~= nil then
        sh_ripple:send('t', num_shadertime);
    end
    if colorPicker ~= nil then
        r = tonumber(string.sub(colorPicker.value, 2, 3), 16);
        g = tonumber(string.sub(colorPicker.value, 4, 5), 16);
        b = tonumber(string.sub(colorPicker.value, 6, 7), 16);
    end
    if sh_mbrot ~= nil then
        sh_mbrot:send('t', num_shadertime);
        sh_mbrot:send('movexy', {move_x, move_y});
        sh_mbrot:send('shortside', short_dimension);
        sh_mbrot:send('zoomfactor', zoom_factor);
        sh_mbrot:send('iterfactor', iter_factor);
        sh_mbrot:send('r', r);
        sh_mbrot:send('g', g);
        sh_mbrot:send('b', b);
    end

    if reset then
        num_shadertime = 0;
    end

    if not pause.value then
        num_shadertime = num_shadertime + dt;
    end
    

    ui1:frameBegin()

        overview:drawUI(ui1);
        iter_factor = overview.iterations;
        zoom_factor = overview.zoomfactor;
        pause = overview.pause;
        reset = overview.reset;
        colorPicker = overview.colorPicker;
        dt = overview.speed;
        debug = overview.debug;
            
    ui1:frameEnd()
end

function mbrot_make()
    if (sh_mbrot == nil) then
        sh_mbrot = love.graphics.newShader('mbrot.glsl');
    end
end

function checkers()
    cv_checkers = love.graphics.newCanvas();
    love.graphics.setCanvas(cv_checkers);
    love.graphics.setColor(0, 0, 0, 1);
    love.graphics.rectangle('fill', 0, 0, 330, 330);
    love.graphics.setColor(1, 1, 1, 1);
    local i, j, flip;
    for i = 0, 30, 1 do
        flip = (math.fmod(i, 2) == 0);
        for j = 0, 30, 1 do
            if (flip) then
                love.graphics.rectangle('fill', i*30, j*30, 30, 30);
            end
            if (flip) then
                flip = false;
            else
                flip = true;
            end
        end
    end
    love.graphics.setCanvas();
end

function mbrot()
    if cv_mbrot == nil then
        cv_mbrot = love.graphics.newCanvas();
    end
    love.graphics.setCanvas(cv_mbrot);
    love.graphics.setShader(sh_mbrot);
    love.graphics.setColor(1,1,1,1);
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
    love.graphics.setShader();
    love.graphics.setCanvas();
end

function rmap()
    cv_rmap = love.graphics.newCanvas();
end

function love.draw()
    if cv_checkers == nil then
        checkers();
    end
    mbrot_make();
    mbrot();
    love.graphics.draw(cv_mbrot);
    if debug.value then
        love.graphics.print("zoom: " .. zoom_factor, 0, 0);
        love.graphics.print("(" .. move_x .. ", " .. move_y .. ")", 0, 16);
        love.graphics.print("pause: " .. tostring(pause.value), 0, 32);
        love.graphics.print("r: " .. r .. " g: " .. g .. " b: " .. b, 0, 48);
    end
    ui1:draw();
end