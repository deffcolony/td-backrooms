motorSpeed = 1.0		-- How fast the elevator is going
motorStrength = 1000	-- How strong the motor is
epsilon = 0.01			-- Stop elevator when within 1 cm from target position


function init()	
	--Find handles
	up = FindShape("down")
	down = FindShape("up")
	up2 = FindShape("down2")
	down2 = FindShape("up2")
	up3 = FindShape("down3")
	down3 = FindShape("up3")	
	joint = FindJoint("joint")
	elevator = FindBody("elevator")
	--door = FindBody("door")

	--This is how far the elevator can travel down and up
	limitDown, limitUp = GetJointLimits(joint)

	--Load sounds
	clickSound = LoadSound("clickdown.ogg")
	motorSound = LoadLoop("heavy_motor")
	roomSound = LoadLoop("MOD/sounds/teleport.ogg", 5)

	stuckTimer = 0.0
	motor = 0
	avgSpeed = 0
end


function tick(dt)

    --SetBodyTransform(door, Vec(0, 100, 0))

    PlayLoop(roomSound, GetBodyTransform(soundbody).pos, 2)

	--Up button
	if GetPlayerInteractShape() == up and InputPressed("interact") then
		PlaySound(clickSound)
		--SetEnvironmentProperty("skyboxbrightness", 0.8)
		if motor == 1 then
			motor = 0
		else
			motor = 1
		end
	end
	
	--Down button
	if GetPlayerInteractShape() == down and InputPressed("interact") then
		PlaySound(clickSound)
		--SetEnvironmentProperty("skyboxbrightness", 0.8)
		if motor == -1 then
			motor = 0
		else
			motor = -1
		end
	end


	if GetPlayerInteractShape() == up2 and InputPressed("interact") then
		PlaySound(clickSound)
		--SetEnvironmentProperty("skyboxbrightness", 0.8)
		if motor == 1 then
			motor = 0
		else
			motor = 1
		end
	end
	
	if GetPlayerInteractShape() == down2 and InputPressed("interact") then
		PlaySound(clickSound)
		--SetEnvironmentProperty("skyboxbrightness", 0.8)
		if motor == -1 then
			motor = 0
		else
			motor = -1
		end
	end

	if GetPlayerInteractShape() == up3 and InputPressed("interact") then
		PlaySound(clickSound)
		--SetEnvironmentProperty("skyboxbrightness", 0.8)
		if motor == 1 then
			motor = 0
		else
			motor = 1
		end
	end
	
	if GetPlayerInteractShape() == down3 and InputPressed("interact") then
		PlaySound(clickSound)
		--SetEnvironmentProperty("skyboxbrightness", 0.8)
		if motor == -1 then
			motor = 0
		else
			motor = -1
		end
	end

	--Measure sliding average elevator speed to see if elevator is stuck
	--A sliding average will filter out spikes that can occur due to physics glitches
	avgSpeed = avgSpeed*0.9 + math.abs(GetBodyVelocity(elevator)[2])*0.1
	if motor ~= 0 and avgSpeed < motorSpeed*0.5 then
		stuckTimer = stuckTimer + dt
		if stuckTimer > 5.0 then
			stop()
		end
	else
		stuckTimer = 0
	end
	
	--Joint control
	if motor == 1 then
		--Elevator is going up. Stop if we're at the top.
		SetJointMotorTarget(joint, limitUp, motorSpeed, motorStrength)
		PlayLoop(motorSound, GetBodyTransform(elevator).pos)
		if GetJointMovement(joint) > limitUp-epsilon then
			stop()
		end
	elseif motor == -1 then
		--Elevator is going down. Stop if we're at the bottom.
		SetJointMotorTarget(joint, limitDown, motorSpeed, motorStrength)
		PlayLoop(motorSound, GetBodyTransform(elevator).pos)
		if GetJointMovement(joint) < limitDown+epsilon then
			stop()
		end
	else
		--Elevator not moving. Hold in position.
		SetJointMotor(joint, 0, motorStrength)
	end
	
	--Make buttons light up when going up/down
	if motor == 1 then SetShapeEmissiveScale(up, 1) else SetShapeEmissiveScale(up, 0) end
	if motor == -1 then SetShapeEmissiveScale(down, 1) else SetShapeEmissiveScale(down, 0) end
	if motor == 1 then SetShapeEmissiveScale(up2, 1) else SetShapeEmissiveScale(up2, 0) end
	if motor == -1 then SetShapeEmissiveScale(down2, 1) else SetShapeEmissiveScale(down2, 0) end
	if motor == 1 then SetShapeEmissiveScale(up3, 1) else SetShapeEmissiveScale(up3, 0) end
	if motor == -1 then SetShapeEmissiveScale(down3, 1) else SetShapeEmissiveScale(down3, 0) end	
end


function stop()
	PlaySound(clickSound)
	motor = 0
end


