pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- main

function _init()
	init_map()
	snake={x=10,y=10,val=1}
	snake_body={}
	food = {x=5,y=5,val=2}
	vel_x=0
	vel_y=0
	counter=0
	movdelay=3.5
	score=0
	game_over=false
end


function _update60()
	counter+=1
	update_map(food)
	update_map(snake)
	update_map_list(snake_body)
	eat_food()
	eat_snake()
	if counter >= movdelay and not game_over then
		update_snake_body()
		move_snake()
		update_snake()
		counter=0
	end
end

function _draw()
	draw_screen()
	draw_map()
	clean_map()
	dev_print(tostring(game_over),10)
	dev_print("x:"..snake.x,80)
	dev_print("y:"..snake.y,100)
	size = #snake_body
	dev_print("body:"..size,50)
end

-->8
-- map functions

function update_map(obj)
	local x = obj.x
	local y = obj.y
	mapa[x][y].val = obj.val
end

function update_map_list(list)
	for k,l in pairs(list) do
		local x = l.x
		local y = l.y
		local val = l.val
		mapa[x][y].val = val
	end
end


function clean_map()
	for i=0,30 do
		for j=0,28 do
			mapa[i][j].val = 0
		end
	end
end



function init_map()
	mapa={}
	for i=0,30 do
		mapa[i]={}
		for j=0,28 do
			x1=2+4*i
			y1=10+4*j
			
			x2=5+4*i
			y2=13+4*j
			
			cx=(x1+x2)/2
			cy=(y1+y2)/2
			center={x=cx,y=cy}
			square={x1=x1,y1=y1,x2=x2,y2=y2}
			mapa[i][j]={center=center,square=square,val=0}
		end
	end
end
-->8
-- screen functions

function draw_screen()
	cls(3)
	print(score,1,1,0)
	line(1,7,126,7,0)
	rect(1,9,126,126,0)
end

function draw_map()
	for i=0,30 do
		for j=0,28 do
			if mapa[i][j].val == 1 then
				rectfill(mapa[i][j].square.x1,mapa[i][j].square.y1,mapa[i][j].square.x2,mapa[i][j].square.y2,0)
			elseif mapa[i][j].val == 2 then
				circ(mapa[i][j].center.x,mapa[i][j].center.y,1,0)
				--rectfill(mapa[i][j].square.x1,mapa[i][j].square.y1,mapa[i][j].square.x2,mapa[i][j].square.y2,3)
			end
		end
	end	
end


function dev_print(str,pos)
	print(str,pos,1,0)
end
-->8
-- snake functions

function update_snake()
	if snake.x+vel_x < 0 then
		snake.x=30
		snake.y+=vel_y
	elseif snake.x+vel_x > 30 then
		snake.x=0
		snake.y+=vel_y 
	elseif snake.y+vel_y < 0 then
		snake.x+=vel_x
		snake.y=28
	elseif snake.y+vel_y > 28 then
		snake.x+=vel_x
		snake.y=0
	else 
	snake.x+=vel_x
	snake.y+=vel_y
	end
end


function move_snake()
	-- left direction
	if btn(0) and vel_x != 1 then
			vel_x=-1
			vel_y=0
	end
	-- right direction
	if btn(1) and vel_x != -1 then
		vel_x=1
		vel_y=0
	end
	--up direction
	if btn(2) and vel_y != 1 then
		vel_y=-1
		vel_x=0
	end
	--down direction
	if btn(3) and vel_y != -1 then
		vel_y=1
		vel_x=0
	end
	
	--x=0,30 do
	--y=0,28 do

end

function eat_food()
	if snake.x == food.x and snake.y == food.y then
		local size = #snake_body
		add(snake_body,{x=food.x,y=food.y,val=1})
		food.x = flr(rnd(31))
		food.y = flr(rnd(29))
		score+=1
	end
end

function eat_snake()
	local size = #snake_body
	for i = size,1,-1 do
		local body_part = snake_body[i-1]
		if snake.x == body_part.x and snake.y == body_part.y then
			game_over=true 
		end
	end
end

function update_snake_body()
	local size = #snake_body
	for i = size, 1, -1 do
		snake_body[i] = snake_body[i-1]
	end
	if size>=0 then
		snake_body[0] = {x=snake.x,y=snake.y,val=1}
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000000000000000000220502705030050320503305033050320502f0401a030110300d0300b0500a0500905000000080500000009050090500a0500b05000000000000000000000000000000000000
