function init()
	frame1 = math.random(0, 60)
	mblt_l = FindLights("mblt_l", true)
	mblt_r = FindLights("mblt_r", true)
	if mblt_l then
		for i,light in ipairs(mblt_l) do
			SetLightEnabled(light, false)
		end
	end
	
	if mblt_r then
		for i,light in ipairs(mblt_r) do
			SetLightEnabled(light, false)
		end
	end
end

function update(dt)
	t1 = frame1 % 100
	if not IsShapeBroken(GetLightShape(mblt_l)) and not IsShapeBroken(GetLightShape(mblt_r)) then
		frame1 = frame1 + 1
		if t1 == 0 then
			for i,light in ipairs(mblt_l) do
				SetLightEnabled(light, true)
			end
			for i,light in ipairs(mblt_r) do
				SetLightEnabled(light, false)
			end
		elseif t1 == 50 then
			for i,light in ipairs(mblt_l) do
				SetLightEnabled(light, false)
			end
			for i,light in ipairs(mblt_r) do
				SetLightEnabled(light, true)
			end
		end
	end
end