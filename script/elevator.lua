-- Controls an elevator on a prismatic joint with two buttons
-- The elevator continues at given speed until reaching the joint limit or the timer runs out

pTimer = GetFloatParam("timer", 3.9)
pSpeed = GetFloatParam("speed", 2.0)

function init()
	motor = FindJoint("motor",true)
	limitMin, limitMax = GetJointLimits(motor)
	down = FindShapes("down",true)
	up = FindShapes("up",true)
	musicLoop = LoadLoop("MOD/snd/elevatormusic.ogg")
	speaker = FindShape("Speaker",true)

	
	clickUp = LoadSound("clickup.ogg")
	clickDown = LoadSound("clickdown.ogg")
	chime = LoadSound("elevator-chime.ogg")
	motorSound = LoadLoop("MOD/sounds/eloop.ogg")
	cabin = FindBody("cabin",true)
	
	for i=1,#down do
		SetTag(down[i], "interact", "Down")
		SetShapeEmissiveScale(down[i], 0)
	end

	for i=1,#up do
		SetTag(up[i], "interact", "Up")
		SetShapeEmissiveScale(up[i], 0)
	end
	
	SetTag(speaker, "music")
	
	downPressed = false
	downTimer = 0
	upPressed = false
	upTimer = 0
	currentClicked = null
	motorTimer = 0.1
	
end

function press(shape)
	local t = GetShapeLocalTransform(shape)
	PlaySound(clickUp, TransformToParentPoint(GetBodyTransform(GetShapeBody(shape)), t.pos))
	t.pos[1] = t.pos[1] + 0.00
	SetShapeLocalTransform(shape, t)
	motorTimer = 5
	if downPressed then
		for i=1,#down do
			SetShapeEmissiveScale(down[i], 1)
			RemoveTag(down[i], "interact")
			RemoveTag(up[i], "interact")
		end
	end
	if upPressed then
		for i=1,#up do
			SetShapeEmissiveScale(up[i], 1)
			RemoveTag(up[i], "interact")
			RemoveTag(down[i], "interact")
		end
	end
end


function unpress(shape)
	local t = GetShapeLocalTransform(shape)
	PlaySound(clickUp, TransformToParentPoint(GetBodyTransform(GetShapeBody(shape)), t.pos))
	t.pos[1] = t.pos[1] - 0.00
	SetShapeLocalTransform(shape, t)
	if downPressed then
		for i=1,#down do
			SetShapeEmissiveScale(down[i], 0)
			SetTag(down[i], "interact", "Down")
			SetTag(up[i], "interact", "Up")
		end
	end
	if upPressed then
		for i=1,#up do
			SetShapeEmissiveScale(up[i], 0)
			SetTag(up[i], "interact", "Up")
			SetTag(down[i], "interact", "Down")
		end
	end
end


function tick(dt)
	downTimer = downTimer - dt
	upTimer = upTimer - dt
	local motorPos = GetBodyTransform(cabin).pos
	
	--Music
	if IsShapeBroken(speaker) then
		RemoveTag(speaker, "music")
		return
	end
	if HasTag(speaker, "music") then
		local pos = GetShapeWorldTransform(speaker).pos
		PlayLoop(musicLoop, pos)
	end
	-- EndMusic
	
	for i=1,#down do
		if GetPlayerInteractShape() == down[i] and InputPressed("interact") and not upPressed then
			upTimer = 0
			downTimer = pTimer
			if not downPressed then
				downPressed = true
				press(down[i])
				currentClicked = down[i]
			end
		end
	end

	for i=1,#up do
		if GetPlayerInteractShape() == up[i] and InputPressed("interact") and not downPressed then
			downTimer = 0
			upTimer = pTimer
			if not upPressed then
				upPressed = true
				press(up[i])
				currentClicked = up[i]
			end
		end
	end
	
	if downTimer <= 0 then
		downTimer = 0
		if downPressed then
			PlaySound(chime,motorPos)
			unpress(currentClicked)
		end
		downPressed = false
	end
	if upTimer <= 0 then
		upTimer = 0
		if upPressed then
			PlaySound(chime,motorPos)
			unpress(currentClicked)
		end
		upPressed = false
	end

	local eps = 0.01
	if motorTimer > 0 then
		if downPressed and motorTimer > 0.1 then
			SetJointMotor(motor, pSpeed)
			PlayLoop(motorSound,motorPos, 0.6)
			if GetJointMovement(motor) < limitMin+eps then
				downTimer = 0.0			
			end
		elseif upPressed and motorTimer > 0.1 then
			SetJointMotor(motor, -pSpeed)
			PlayLoop(motorSound,motorPos, 0.6)
			if GetJointMovement(motor) > limitMax-eps then
				upTimer = 0.0			
			end
		else
			SetJointMotor(motor, 0.0)
			motorTimer = 0.0
		end
		motorTimer = motorTimer - dt
	end
end

