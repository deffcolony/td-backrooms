on = false
timerOn = 0.0
timerOff = 0.0
blinksTimer = 0.0
trigerOn = false

timeOld = 0.0

function init()
	triggerTag = GetStringParam("buttonTag")

	light = FindLight("light")
	body = FindShape("body")
	startVolume = GetFloatParam("volume", 0.2)
	workVolume = GetFloatParam("volume", 0.1)

	SetLightEnabled(light, false)

	local r = math.random(1, 6)
	startSound = LoadLoop(string.format("MOD/sounds/lampStarts%d.ogg", r))
	workSound = LoadLoop(GetStringParam("lampWorkSound", "MOD/sounds/lampWorks.ogg"), 1.5)
end

function rnd(mi, ma)
    return math.random(0, 1000)/1000*(ma-mi)+mi
end	

function updateTimers()
	if blinksTimer > 0 then 
		blinksTimer = blinksTimer - (GetTime() - timeOld)
	end
	if timerOn > 0 then 
		timerOn = timerOn - (GetTime() - timeOld)
	end
	if timerOff > 0 then 
		timerOff = timerOff - (GetTime() - timeOld)
	end
	
	timeOld = GetTime()
end

function lightOn()
	if not on and blinksTimer == -100 then
 		blinksTimer = math.random(5, 50)/10
 	end

 	if not on then
		PlayLoop(startSound, GetLightTransform(light).pos, startVolume)
		if  timerOff <= 0 and timerOff ~= -100 then
			timerOff = -100
			SetLightEnabled(light, true)
			timerOn = math.random(4, 20)/100
		end

		if timerOn <= 0 and timerOn ~= -100 then
			timerOn = -100
			SetLightEnabled(light, false)
			timerOff = math.random(2, 20)/50
			SetEnvironmentProperty("skyboxbrightness", rnd(0.0, 0.8))
		end

		if blinksTimer <= 0 then
			SetLightEnabled(light, true)
			on = true
			SetEnvironmentProperty("skyboxbrightness", 0.8)
		end
	else
		if GetBool("level.light.noiseEnabled") then PlayLoop(workSound, GetLightTransform(light).pos, workVolume) end
	end
end
function lightOff()
	SetLightEnabled(light, false)
	on = false
	timerOff = 0
	timerOn = 0
	blinksTimer = -100
end

function tick()
	if IsShapeBroken(body) then
		lightOff()
	else
		if GetBool("level.light."..triggerTag..".enabled") then
			lightOn()
		else
			lightOff()
		end
	end
	updateTimers()
end