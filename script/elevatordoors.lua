
function init()
	motor1L = FindJoint("DoorMotor1L", true)
	motor1R = FindJoint("DoorMotor1R", true)
	motor2L = FindJoint("DoorMotor2L", true)
	motor2R = FindJoint("DoorMotor2R", true)
	motor3L = FindJoint("DoorMotor3L", true)
	motor3R = FindJoint("DoorMotor3R", true)
	motor4L = FindJoint("DoorMotor4L", true)
	motor4R = FindJoint("DoorMotor4R", true)
	motor5L = FindJoint("DoorMotor5L", true)
	motor5R = FindJoint("DoorMotor5R", true)
	trigger1 = FindTrigger("open1", true)
	trigger2 = FindTrigger("open2", true)
	trigger3 = FindTrigger("open3", true)
	trigger4 = FindTrigger("open4", true)
	trigger5 = FindTrigger("open5", true)
	sensor = FindShape("sensor", true)
	open = false
	eps = 0.2
	timer = 0
	
    doors = LoadSound("MOD/sounds/eloop.ogg")
	
	FloorG = FindShapes("FloorG",true)
	Floor1 = FindShapes("Floor1",true)
	Floor2 = FindShapes("Floor2",true)
	Floor3 = FindShapes("Floor3",true)
	Floor4 = FindShapes("Floor4",true)
	
	for i=1,#FloorG do
		SetShapeEmissiveScale(FloorG[i], 0)
	end
	for i=1,#Floor1 do
		SetShapeEmissiveScale(Floor1[i], 0)
	end
	for i=1,#Floor2 do
		SetShapeEmissiveScale(Floor2[i], 0)
	end
	for i=1,#Floor3 do
		SetShapeEmissiveScale(Floor3[i], 0)
	end
	for i=1,#Floor4 do
		SetShapeEmissiveScale(Floor4[i], 0)
	end
end

function update(dt)
	
	timer = timer + GetTimeStep()
	if IsShapeInTrigger(trigger1, sensor) then	-- Ground Floor
		if timer < 8 then
			SetJointMotor(motor1L, -1)
			SetJointMotor(motor1R, -1)
		end
		if not open then
			timer = 0
		end
		open = true
		
		for i=1,#FloorG do
			SetShapeEmissiveScale(FloorG[i], 1)
		end
	else
		if timer < 8 then
			SetJointMotor(motor1L, 1)
			SetJointMotor(motor1R, 1)
		end
		if open then
			timer = 0
		end
		open = false
		
		for i=1,#FloorG do
			SetShapeEmissiveScale(FloorG[i], 0)
		end
	end
	
	if IsShapeInTrigger(trigger2, sensor) then -- Floor 1
		if timer < 8 then
			SetJointMotor(motor2L, -1)
			SetJointMotor(motor2R, -1)
		end
		if not open then
			timer = 0
		end
		open = true
		
		for i=1,#Floor1 do
			SetShapeEmissiveScale(Floor1[i], 1)
		end
	else
		if timer < 8 then
			SetJointMotor(motor2L, 1)
			SetJointMotor(motor2R, 1)
		end
		if open then
			timer = 0
		end
		open = false
		
		for i=1,#Floor1 do
			SetShapeEmissiveScale(Floor1[i], 0)
		end
	end
	
	if IsShapeInTrigger(trigger3, sensor) then -- Floor 2
		if timer < 8 then
			SetJointMotor(motor3L, -1)
			SetJointMotor(motor3R, -1)
		end
		if not open then
			timer = 0
		end
		open = true
		
		for i=1,#Floor2 do
			SetShapeEmissiveScale(Floor2[i], 1)
		end
	else
		if timer < 8 then
			SetJointMotor(motor3L, 1)
			SetJointMotor(motor3R, 1)
		end
		if open then
			timer = 0
		end
		open = false
		
		for i=1,#Floor2 do
			SetShapeEmissiveScale(Floor2[i], 0)
		end
	end
	
	if IsShapeInTrigger(trigger4, sensor) then -- Floor 3
		if timer < 8 then
			SetJointMotor(motor4L, -1)
			SetJointMotor(motor4R, -1)
		end
		if not open then
			timer = 0
		end
		open = true
		
		for i=1,#Floor3 do
			SetShapeEmissiveScale(Floor3[i], 1)
		end
	else
		if timer < 8 then
			SetJointMotor(motor4L, 1)
			SetJointMotor(motor4R, 1)
		end
		if open then
			timer = 0
		end
		open = false
		
		for i=1,#Floor3 do
			SetShapeEmissiveScale(Floor3[i], 0)
		end
	end
	
	if IsShapeInTrigger(trigger5, sensor) then -- Floor 4
		if timer < 8 then
			SetJointMotor(motor5L, -1)
			SetJointMotor(motor5R, -1)
		end
		if not open then
			timer = 0
		end
		open = true
		
		for i=1,#Floor4 do
			SetShapeEmissiveScale(Floor4[i], 1)
		end
	else
		if timer < 8 then
			SetJointMotor(motor5L, 1)
			SetJointMotor(motor5R, 1)
		end
		if open then
			timer = 0
		end
		open = false
		
		for i=1,#Floor4 do
			SetShapeEmissiveScale(Floor4[i], 0)
		end
	end
end


