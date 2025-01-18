enableAllOld = false
disableAllOld = false

function init()
	triggerTag = GetStringParam("triggerTag")
	button = FindShape(triggerTag)

	lightTrig = HasTag(button, "lightTrig")
	
	trig = FindTrigger("boxx")

	onSound = LoadSound(GetStringParam("onSound", "MOD/sounds/env/lights/BTN_light_switch_on.ogg"))
	offSound = LoadSound(GetStringParam("offSound", "MOD/sounds/env/lights/BTN_light_switch_off.ogg"))
	volume = GetFloatParam("volume", 0.5)

	if button == 0 then 
		DebugPrint("can't find trigger")
		DebugPrint(triggerTag)
	end
	if onSound == 0 then DebugPrint("can't find on sound") end
	if offSound == 0 then DebugPrint("can't find off sound") end
	SetTag(button, "interact", "light on")

	enableAllOld = GetBool("level.light.enableAll")
	disableAllOld = GetBool("level.light.disableAll")

	SetBool("level.light."..triggerTag..".enabled", true) --reverse
end

isOn = false

function on()
	SetTag(button, "interact", "Light on") --and this
	SetBool("level.light."..triggerTag..".enabled", false) --and this
	SetEnvironmentProperty("skyboxbrightness", 0.0)
end

function off()
	SetTag(button, "interact", "Light off") --and this
	SetBool("level.light."..triggerTag..".enabled", true) --and this
	SetEnvironmentProperty("skyboxbrightness", 0.8)
end

function rnd(mi, ma)
	local v = math.random(0,1000) / 1000
	return mi + (ma-mi)*v
end

function tick()

    local active = IsPointInTrigger(trig, GetPlayerTransform().pos)
	--isOn = not isOn
	if active then
	    off()
		isOn = not isOn
		ShakeCamera(0.6)
	    SetCameraDof(rnd(0,30))
        SetTimeScale(0.3)
        --PointLight(GetPlayerTransform().pos, 0.9,0.9,rnd(0.1,0.7), 1)		
	end	

	if not IsShapeBroken(button) then
		if GetPlayerInteractShape() == button and InputPressed("interact") then
			isOn = not isOn
			if isOn then
				PlaySound(onSound, GetShapeWorldTransform(button).pos, volume)
				on()
			else
				PlaySound(offSound, GetShapeWorldTransform(button).pos, volume)
				off()
			end
		end

		if lightTrig then
			if GetBool("level.light.enableAll") ~= enableAllOld then
				enableAllOld = not enableAllOld
				isOn = true
				on()
			elseif GetBool("level.light.disableAll") ~= disableAllOld then
				disableAllOld = not disableAllOld
				isOn = false
				off()
			end
		end
	else
		RemoveTag(button, "interact")
	end
end