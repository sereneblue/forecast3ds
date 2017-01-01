local display = {}
local weather = require 'weather'
colors = require 'colors'

display.state = "start"
display.coord = ""
display.theme_color =  ""
display.color = 0
display.font = {
	px_20={
		A=14,B=14,C=13,D=13,E=13,F=12,G=14,
		H=14,I=4,J=12,K=13,L=12,M=16,N=14,
		O=15,P=13,Q=15,R=13,S=13,T=12,U=15,
		V=14,W=23,X=13,Y=12,Z=12,a=12,
		b=12,c=11,d=12,e=12,f=7,g=12,h=13,
		i=4,j=4,k=10,l=4,m=21,n=13,o=12,
		p=12,q=12,r=7,s=11,t=8,u=13,v=11,
		w=18,x=10,y=11,z=11,[":"]=3,["%"]=12,
		["/"]=7, ["."]=3,[","]=3,[" "]=5,["-"]=7,
		["0"]=11,["1"]=6,["2"]=11,["3"]=11,
		["4"]=10,["5"]=11,["6"]=11,["7"]=10,
		["8"]=12,["9"]=11
	},
	px_24={
		A=17,B=16,C=16,D=16,E=15,F=15,G=17,
		H=16,I=5,J=14,K=15,L=14,M=19,N=17,
		O=18,P=15,Q=18,R=16,S=16,T=14,U=18,
		V=16,W=28,X=15,Y=15,Z=15,a=15,
		b=15,c=13,d=15,e=15,f=8,g=15,h=15,
		i=5,j=5,k=12,l=5,m=26,n=15,o=15,
		p=15,q=15,r=8,s=13,t=9,u=15,v=13,
		w=22,x=12,y=13,z=13,[":"]=4,["%"]=15,
		["/"]=9, ["."]=3,[","]=3,[" "]=7,["-"]=9,
		["0"]=13,["1"]=8,["2"]=14,["3"]=14,
		["4"]=12,["5"]=13,["6"]=13,["7"]=12,
		["8"]=15,["9"]=13
	},
	px_150={
		["0"]=80,["1"]=48,["2"]=85,["3"]=85,
		["4"]=77,["5"]=84,["6"]=84,["7"]=78,
		["8"]=93,["9"]=84
	}
}

local weather_data = nil

-- blit twice
function display.blit_twice(call_function)
	call_function()
	Screen.flip()
	Screen.refresh()
	call_function()
end

-- display splash screen
function display.splash_screen()
	logo = Screen.loadImage("/3ds/forecast3ds/assets/img/splash.png")
	hero_font = Font.load("/3ds/forecast3ds/assets/Hero.ttf")

	Screen.drawImage(0, 0, logo, TOP_SCREEN)
	Screen.fillRect(0, 320, 0, 240, colors.bg, BOTTOM_SCREEN)

	Font.setPixelSizes(hero_font, 24)
	Font.print(hero_font, center("Loading...", 24, BOTTOM_SCREEN), 100, "Loading...", colors.white, BOTTOM_SCREEN)
	Screen.flip()

	Screen.freeImage(logo)
	Font.unload(hero_font)
end

-- determine whether to show setup or weather depending on settings
function display.loading()
	-- check for config
	if System.doesFileExist("/3ds/forecast3ds/assets/forecast.settings") then
		inputStream = io.open("/3ds/forecast3ds/assets/forecast.settings",FREAD)
		text = io.read(inputStream, 0, io.size(inputStream))
		display.coord, theme = text:match("([^|]+)|([^|]+)")
		display.color = tonumber(theme)
		display.splash_screen()
		wait()
		display.weather()
	else
		display.init()
	end
end

-- show keyboard to grab input
function display.keyboard()
	display.state = "input"
	fin = false
	cns = Console.new(TOP_SCREEN)
	Console.append(cns, display.coord)

	while fin ~= true do
		Screen.refresh()
		Screen.clear(TOP_SCREEN)
		Console.show(cns)

		local kbState = Keyboard.getState()
		if kbState ~= FINISHED then
			Keyboard.show()
			if kbState ~= NOT_PRESSED then
				Console.clear(cns)
				if kbState == PRESSED then
					input = Keyboard.getInput()
					Console.append(cns, input)
					display.coord = Keyboard.getInput()
				end
			end
		else
			Console.destroy(cns)
			fin = true
		end
		-- Flipping screens
		Screen.flip()
	end
	display.blit_twice(display.init)
end

-- choose theme
function display.valid_theme_selection(x, y)
	if x >= 10 and x <= 70 then
		if y > 100 and y <= 150 then
			display.color = 1
			display.theme_color = colors.theme[1].color
		elseif y > 160 and y <= 210 then
			display.color = 5
			display.theme_color = colors.theme[5].color
		end
		display.init()
	elseif x >= 90 and x <= 160 then
		if y >= 100 and y <= 150 then
			display.color = 2
			display.theme_color = colors.theme[2].color
		elseif y > 160 and y <= 210 then
			display.color = 6
			display.theme_color = colors.theme[6].color
		end
		display.init()
	elseif x >= 180 and x <= 240 then
		if y >= 100 and y <= 150 then
			display.color = 3
			display.theme_color = colors.theme[3].color
		elseif y > 160 and y <= 210 then
			display.color = 7
			display.theme_color = colors.theme[7].color
		end
		display.init()
	elseif x >= 260 and x <= 320 then
		if y >= 100 and y <= 150 then
			display.color = 4
			display.theme_color = colors.theme[4].color
		elseif y > 160 and y <= 210 then
			display.color = 8
			display.theme_color = colors.theme[8].color
		end
		display.init()
	end
end

-- init setup
function display.init()
	display.state = "setup"
	hero_font = Font.load("/3ds/forecast3ds/assets/Hero.ttf")
	logo = Screen.loadImage("/3ds/forecast3ds/assets/img/logo.png")
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.drawImage(0, 0, logo, TOP_SCREEN)
	Screen.freeImage(logo)
	Screen.fillRect(0, 320, 0, 240, colors.bg, BOTTOM_SCREEN)
	Screen.fillRect(10, 310, 25, 55, colors.white, BOTTOM_SCREEN)
	Screen.flip()

	-- color boxes
	for x=1,4 do
		x1 = 10 + (80 *(x-1))
		Screen.fillRect(x1, x1 + 60, 100, 125, colors.theme[x]['light'], BOTTOM_SCREEN)
		Screen.fillRect(x1, x1 + 60, 125, 150, colors.theme[x]['dark'], BOTTOM_SCREEN)
	end

	for x=5,8 do
		x1 = 10 + (80 *(x-5))
		Screen.fillRect(x1, x1 + 60, 160, 185, colors.theme[x]['light'], BOTTOM_SCREEN)
		Screen.fillRect(x1, x1 + 60, 185, 210, colors.theme[x]['dark'], BOTTOM_SCREEN)
	end
	Screen.flip()

	Font.setPixelSizes(hero_font, 20)
	Font.print(hero_font, 10, 3, "Enter your city's long & lat:", colors.white, BOTTOM_SCREEN)
	Font.print(hero_font, 15, 35, display.coord, colors.black, BOTTOM_SCREEN)
	Font.print(hero_font, 10, 75, "Pick your theme", colors.white, BOTTOM_SCREEN)
	Font.print(hero_font, 10, 220, "Press (A) to continue when done", colors.white, BOTTOM_SCREEN)

	Font.print(hero_font, 10, 200, "Long & lat : " .. display.coord, colors.white, TOP_SCREEN)
	Font.print(hero_font, 10, 220, "Theme : " .. display.theme_color, colors.white, TOP_SCREEN)
	Font.unload(hero_font)
	Screen.flip()
end

-- save and continue from setup
function display.save_and_continue()
	-- save input
	fileStream = io.open("/3ds/forecast3ds/assets/forecast.settings",FCREATE)
	offset = 0
	io.write(fileStream, offset, display.coord .. "|", #display.coord + 1)
	offset = #display.coord + 1
	io.write(fileStream, offset, tostring(display.color), 1)
	io.close(fileStream)

	-- check weather
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.flip()
	display.weather()
end

-- show weather
function display.weather()
	display.state = "weather"
	hero_font = Font.load("/3ds/forecast3ds/assets/Hero.ttf")
	weather_data = weather.get_forecast(display.coord)
	if weather_data.success then
		Screen.clear(TOP_SCREEN)
		Screen.clear(BOTTOM_SCREEN)
		Screen.fillRect(0, 400, 0, 240, colors.theme[display.color].light, TOP_SCREEN)
		Screen.fillRect(0, 400, 75, 230, colors.theme[display.color].dark, TOP_SCREEN)
		Screen.flip()

		-- top screen
		Font.setPixelSizes(hero_font, 24)
		Font.print(hero_font, center(weather_data.current.city, 24, TOP_SCREEN), 15, weather_data.current.city, colors.white, TOP_SCREEN)
		Font.print(hero_font, center("5 DAY FORECAST", 24, TOP_SCREEN), 45, "5 DAY FORECAST", colors.white, TOP_SCREEN)

		Font.setPixelSizes(hero_font, 23)
		Font.print(hero_font, 20, 80, weather_data.forecast[1].day, colors.white, TOP_SCREEN)
		Font.print(hero_font, 100, 80, weather_data.forecast[2].day, colors.white, TOP_SCREEN)
		Font.print(hero_font, 180, 80, weather_data.forecast[3].day, colors.white, TOP_SCREEN)
		Font.print(hero_font, 260, 80, weather_data.forecast[4].day, colors.white, TOP_SCREEN)
		Font.print(hero_font, 340, 80, weather_data.forecast[5].day, colors.white, TOP_SCREEN)
		Screen.flip()

		Screen.drawImage(15, 110, weather.type[weather_data.forecast[1].forecast], TOP_SCREEN)
		Screen.drawImage(95, 110, weather.type[weather_data.forecast[2].forecast], TOP_SCREEN)
		Screen.drawImage(175, 110, weather.type[weather_data.forecast[3].forecast], TOP_SCREEN)
		Screen.drawImage(255, 110, weather.type[weather_data.forecast[4].forecast], TOP_SCREEN)
		Screen.drawImage(335, 110, weather.type[weather_data.forecast[5].forecast], TOP_SCREEN)
		Screen.flip()

		Font.setPixelSizes(hero_font, 28)
		Font.print(hero_font, 20, 170, temp_formatter(weather_data.forecast[1].hi), colors.white, TOP_SCREEN)
		Font.print(hero_font, 100, 170, temp_formatter(weather_data.forecast[2].hi), colors.white, TOP_SCREEN)
		Font.print(hero_font, 180, 170, temp_formatter(weather_data.forecast[3].hi), colors.white, TOP_SCREEN)
		Font.print(hero_font, 260, 170, temp_formatter(weather_data.forecast[4].hi), colors.white, TOP_SCREEN)
		Font.print(hero_font, 340, 170, temp_formatter(weather_data.forecast[5].hi), colors.white, TOP_SCREEN)

		Font.print(hero_font, 20, 200, temp_formatter(weather_data.forecast[1].lo), colors.theme[display.color].lo, TOP_SCREEN)
		Font.print(hero_font, 100, 200, temp_formatter(weather_data.forecast[2].lo), colors.theme[display.color].lo, TOP_SCREEN)
		Font.print(hero_font, 180, 200, temp_formatter(weather_data.forecast[3].lo), colors.theme[display.color].lo, TOP_SCREEN)
		Font.print(hero_font, 260, 200, temp_formatter(weather_data.forecast[4].lo), colors.theme[display.color].lo, TOP_SCREEN)
		Font.print(hero_font, 340, 200, temp_formatter(weather_data.forecast[5].lo), colors.theme[display.color].lo, TOP_SCREEN)
		Screen.flip()

		-- bottom screen
		Screen.fillRect(0, 320, 0, 240, colors.theme[display.color].light, BOTTOM_SCREEN)
		Screen.flip()

		-- top screen
		temp = weather_data.current.temp
		Font.setPixelSizes(hero_font, 150)
		Font.print(hero_font, center(temp, 150, BOTTOM_SCREEN), 0, temp, colors.white, BOTTOM_SCREEN)

		Font.setPixelSizes(hero_font, 50)
		-- font doesn't have degree symbol unfortunately :/
		if weather_data.current.units == "F" then
			Font.print(hero_font, calc_height(temp), 10, "F", colors.white, BOTTOM_SCREEN)
		else
			Font.print(hero_font, calc_height(temp), 10, "C", colors.white, BOTTOM_SCREEN)
		end

		Font.setPixelSizes(hero_font, 20)
		Font.print(hero_font, center(weather_data.current.weather, 20, BOTTOM_SCREEN), 130, weather_data.current.weather, colors.white, BOTTOM_SCREEN)
		Font.print(hero_font, center(weather_data.current.hi_lo, 20, BOTTOM_SCREEN), 160, weather_data.current.hi_lo, colors.white, BOTTOM_SCREEN)
		Font.print(hero_font, center(weather_data.current.humidity, 20, BOTTOM_SCREEN), 180, weather_data.current.humidity, colors.white, BOTTOM_SCREEN)
		Font.print(hero_font, center(weather_data.current.wind, 20, BOTTOM_SCREEN), 200, weather_data.current.wind, colors.white, BOTTOM_SCREEN)
		Font.unload(hero_font)

		Screen.flip()
	else
		display.state = "error"
		logo = Screen.loadImage("/3ds/forecast3ds/assets/img/logo.png")
		error_occured = Screen.loadImage("/3ds/forecast3ds/assets/img/error.png")
		Screen.drawImage(0, 0, logo, TOP_SCREEN)
		Screen.drawImage(0, 0, error_occured, BOTTOM_SCREEN)
		Screen.freeImage(logo)
		Screen.freeImage(error_occured)
		Screen.flip()
	end
end

-- format weather on top screen
function temp_formatter(temp)
	temp = tonumber(temp)
	if temp >= 0 and temp < 10 then
		return "  " .. temp
	elseif temp < 0 or (temp > 10 and temp < 100) then
		return " " .. temp
	else
		return "" .. temp
	end
end

-- center text, a godsend with html5's canvas
function center(text, size, screen)
	x = 0
	if screen == TOP_SCREEN then
		screen_size = 400
	else
		screen_size = 320
	end
	pixel = "px_" .. tostring(size)
	for c in text:gmatch"." do
	    x = x + display.font[pixel][c]
	end
	return math.floor((screen_size - x)/2)
end

-- calculate height for F or C, no degree symbol in the Hero font
function calc_height(temp)
	x = 0
	for c in temp:gmatch"." do
	    x = x + display.font.px_150[c]
	end
	return math.floor((320 - x)/2) + x
end

-- splash screen wait to show Weather Underground Logo usage
function wait()
	timer = Timer.new()
	while Timer.getTime(timer) < 2500 do
		-- just wait
	end
	Timer.destroy(timer)
end

return display