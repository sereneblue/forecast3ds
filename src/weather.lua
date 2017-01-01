JSON = (loadfile "JSON.lua")()

local weather = {}

weather.type = {}
weather.type['chanceflurries'] = Screen.loadImage("/3ds/forecast3ds/assets/img/chance_flurries.png")
weather.type['chancerain'] = Screen.loadImage("/3ds/forecast3ds/assets/img/chance_rain.png")
weather.type['chancesleet'] = Screen.loadImage("/3ds/forecast3ds/assets/img/chance_sleet.png")
weather.type['chancesnow'] = Screen.loadImage("/3ds/forecast3ds/assets/img/chance_snow.png")
weather.type['chancestorms'] = Screen.loadImage("/3ds/forecast3ds/assets/img/chance_storms.png")
weather.type['chancetstorms'] = Screen.loadImage("/3ds/forecast3ds/assets/img/tstorms.png")
weather.type['clear'] = Screen.loadImage("/3ds/forecast3ds/assets/img/clear.png")
weather.type['flurries'] = Screen.loadImage("/3ds/forecast3ds/assets/img/flurries.png")
weather.type['fog'] = Screen.loadImage("/3ds/forecast3ds/assets/img/fog.png")
weather.type['hazy'] = Screen.loadImage("/3ds/forecast3ds/assets/img/fog.png")
weather.type['mostlycloudy'] = Screen.loadImage("/3ds/forecast3ds/assets/img/partlycloudy.png")
weather.type['mostlysunny'] = Screen.loadImage("/3ds/forecast3ds/assets/img/partlysunny.png")
weather.type['partlycloudy'] = Screen.loadImage("/3ds/forecast3ds/assets/img/partlycloudy.png")
weather.type['partlysunny'] = Screen.loadImage("/3ds/forecast3ds/assets/img/partlysunny.png")
weather.type['sleet'] = Screen.loadImage("/3ds/forecast3ds/assets/img/sleet.png")
weather.type['rain'] = Screen.loadImage("/3ds/forecast3ds/assets/img/rain.png")
weather.type['sunny'] = Screen.loadImage("/3ds/forecast3ds/assets/img/sunny.png")
weather.type['snow'] = Screen.loadImage("/3ds/forecast3ds/assets/img/snow.png")
weather.type['tstorms'] = Screen.loadImage("/3ds/forecast3ds/assets/img/tstorms.png")
weather.type['cloudy'] = Screen.loadImage("/3ds/forecast3ds/assets/img/cloudy.png")

function weather.get_forecast(coord)
	if (Network.isWifiEnabled()) then
		url = "http://api.wunderground.com/api/09145f7aba064a8e/conditions/q/" .. coord .. ".json"
		current = JSON:decode(Network.requestString(url))
		url = "http://api.wunderground.com/api/09145f7aba064a8e/forecast10day/q/" .. coord .. ".json"
		response = JSON:decode(Network.requestString(url))

		if current and response then
			if contains(current.current_observation.display_location.country_iso3166) then
				units = "fahrenheit"
				wind = "Wind: " .. current.current_observation.wind_mph .. " mph"
			else
				units = "celsius"
				wind = "Wind: " .. current.current_observation.wind_kph .. " kph"
			end

			-- filter out unsupported characters :(
			if current.current_observation.display_location.city:match("%W") then
				city = current.current_observation.station_id .. " Weather Station, " .. current.current_observation.display_location.country_iso3166
			else
				city = current.current_observation.display_location.city
			end

			return {
				success=true,
				current={
					city=city,
					temp=tostring(math.floor(current.current_observation["temp_".. units:sub(1,1)])),
					weather=current.current_observation.weather,
					hi_lo="H: " .. response.forecast.simpleforecast.forecastday[1].high[units] .. " / L: " .. response.forecast.simpleforecast.forecastday[1].low[units],
					humidity="Humidity: " .. current.current_observation.relative_humidity,
					wind=wind,
					units=units:sub(1,1):upper()
				},
				forecast={
					[1]={
						day=response.forecast.simpleforecast.forecastday[1].date.weekday_short,
						hi=response.forecast.simpleforecast.forecastday[1].high[units],
						lo=response.forecast.simpleforecast.forecastday[1].low[units],
						forecast=response.forecast.simpleforecast.forecastday[1].icon
					},
					[2]={
						day=response.forecast.simpleforecast.forecastday[2].date.weekday_short,
						hi=response.forecast.simpleforecast.forecastday[2].high[units],
						lo=response.forecast.simpleforecast.forecastday[2].low[units],
						forecast=response.forecast.simpleforecast.forecastday[2].icon
					},
					[3]={
						day=response.forecast.simpleforecast.forecastday[3].date.weekday_short,
						hi=response.forecast.simpleforecast.forecastday[3].high[units],
						lo=response.forecast.simpleforecast.forecastday[3].low[units],
						forecast=response.forecast.simpleforecast.forecastday[3].icon
					},
					[4]={
						day=response.forecast.simpleforecast.forecastday[4].date.weekday_short,
						hi=response.forecast.simpleforecast.forecastday[4].high[units],
						lo=response.forecast.simpleforecast.forecastday[4].low[units],
						forecast=response.forecast.simpleforecast.forecastday[4].icon
					},
					[5]={
						day=response.forecast.simpleforecast.forecastday[5].date.weekday_short,
						hi=response.forecast.simpleforecast.forecastday[5].high[units],
						lo=response.forecast.simpleforecast.forecastday[5].low[units],
						forecast=response.forecast.simpleforecast.forecastday[5].icon
					}
				}
			}
		else
			return {success=false}
		end
	else
		return {success=false}
	end
end

function contains(val)
	countries = {"US", "BS", "BZ", "KY", "PW", "PR", "GU", "VI"}
	for i=1,#countries do
		if countries[i] == val then
			return true
		end
	end
	return false
end

return weather