local colors = {}

colors.black = Color.new(0, 0, 0)
colors.white = Color.new(255, 255, 255)
colors.bg = Color.new(15, 106, 115)

-- color schemes
-- red
colors.theme = {}
colors.theme[1] = {}
colors.theme[1]['color'] = "Red"
colors.theme[1]['light'] = Color.new(230, 74, 60)
colors.theme[1]['dark'] = Color.new(191, 56, 44)
colors.theme[1]['lo'] = Color.new(240, 162, 158)

-- blue
colors.theme[2] = {}
colors.theme[2]['color'] = "Blue"
colors.theme[2]['light'] = Color.new(52, 151, 217)
colors.theme[2]['dark'] = Color.new(42, 129, 184)
colors.theme[2]['lo'] = Color.new(152, 203, 235)

-- teal 
colors.theme[3] = {}
colors.theme[3]['color'] = "Teal"
colors.theme[3]['light'] = Color.new(26, 186, 154)
colors.theme[3]['dark'] = Color.new(22, 158, 131)
colors.theme[3]['lo'] = Color.new(139, 217, 200)

-- green
colors.theme[4] = {}
colors.theme[4]['color'] = "Green"
colors.theme[4]['light'] = Color.new(47, 204, 112)
colors.theme[4]['dark'] = Color.new(40, 173, 96)
colors.theme[4]['lo'] = Color.new(150, 227, 179)

-- orange
colors.theme[5] = {}
colors.theme[5]['color'] = "Orange"
colors.theme[5]['light'] = Color.new(230, 125, 34)
colors.theme[5]['dark'] = Color.new(209, 80, 0)
colors.theme[5]['lo'] = Color.new(240, 185, 144)

-- purple
colors.theme[6] = {}
colors.theme[6]['color'] = "Purple"
colors.theme[6]['light'] = Color.new(153, 89, 181)
colors.theme[6]['dark'] = Color.new(140, 68, 171)
colors.theme[6]['lo'] = Color.new(202, 171, 217)

-- dark blue
colors.theme[7] = {}
colors.theme[7]['color'] = "Dark Blue"
colors.theme[7]['light'] = Color.new(51, 72, 92)
colors.theme[7]['dark'] = Color.new(43, 61, 79)
colors.theme[7]['lo'] = Color.new(117, 131, 143)

-- grey
colors.theme[8] = {}
colors.theme[8]['color'] = "Grey"
colors.theme[8]['light'] = Color.new(38, 38, 38)
colors.theme[8]['dark'] = Color.new(31, 31, 31)
colors.theme[8]['lo'] = Color.new(107, 107, 107)

return colors