display = require 'display'

-- Main Loop
while true do

	-- Clear top screen
	Screen.waitVblankStart()
	Screen.refresh()

	if display.state == "start" then
		display.loading()
	elseif display.state == "setup" then
		if display.coord ~= "" and display.theme_color ~= "" and Controls.check(Controls.read(), KEY_A) then
			display.save_and_continue()
		end
		x,y = Controls.readTouch()
		if x >= 10 and x <= 310 and y >= 25 and y <= 55 then
			display.keyboard()
		else
			display.valid_theme_selection(x, y)
		end
	elseif display.state == "error" then
		if Controls.check(Controls.read(), KEY_X) then
			display.weather()
		end
	end

	if Controls.check(Controls.read(), KEY_HOME) then
		System.exit()
	end
end

