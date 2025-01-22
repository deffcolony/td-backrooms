function init()
	myLights = FindLights("mylight", true)
end

function tick()
    local r = 1
	local g = 1
	local b = 1 + math.sin(GetTime()*1)*6
	
	for i=1, #myLights do
	    SetLightColor(myLights[i], r, g, b)
	end
end	