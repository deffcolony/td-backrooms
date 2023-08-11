enableAllOld = false
disableAllOld = false

function init()
	triggerTag = GetStringParam("triggerTag")
	button = FindShape(triggerTag)

	lightTrig = HasTag(button, "lightTrig")

	onSound = LoadSound(GetStringParam("onSound", "MOD/sounds/onSound.ogg"))
	offSound = LoadSound(GetStringParam("offSound", "MOD/sounds/offSound.ogg"))
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
	--SetEnvironmentProperty("skyboxbrightness", 0.0)
end

function off()
	SetTag(button, "interact", "Light off") --and this
	SetBool("level.light."..triggerTag..".enabled", true) --and this
	--SetEnvironmentProperty("skyboxbrightness", 0.8)
end

function tick()
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