local nameGone = 20

function init()
	RegisterTool("backrooms", "BACKROOMS", "MOD/vox/empty.vox", 2)
	SetBool("game.tool.backrooms.enabled", true)
	
	trig = FindTrigger("trig")

	
	--SetInt("game.tool.notool.ammo", 101)
	--[[hitsnd = {}
	for i=0, 5 do
		hitsnd[i] = LoadSound("metal/hit-s"..i..".ogg")
	end

	animrec = 0
	cooldown = 0
	recoil = 0
	
	maxCooldown = 13
	
	holeSize = 0.05
	
	if GetInt("savegame.mod.breakstrength") == 1 then
		canBreakLight = holeSize
		canBreakMedium = 0
		canBreakHeavy = 0
	elseif GetInt("savegame.mod.breakstrength") == 2 then
		canBreakLight = holeSize
		canBreakMedium = holeSize
		canBreakHeavy = 0
	elseif GetInt("savegame.mod.breakstrength") == 3 then
		canBreakLight = holeSize
		canBreakMedium = holeSize
		canBreakHeavy = holeSize
	else
		SetInt("savegame.mod.breakstrength", 3)
		canBreakLight = holeSize
		canBreakMedium = holeSize
		canBreakHeavy = holeSize
	end
	--]]
	--DebugPrint(ListKeys("game.tool.notool.name"))
	--DebugPrint(GetString("game.tool.notool.name"))
end

function tick(dt)

    --local active = IsPointInTrigger(trig, GetPlayerTransform().pos)

    if not switched1 then
	    RegisterTool("backrooms", "BACKROOMS", "MOD/vox/empty.vox", 2)
        SetString("game.player.tool", "backrooms")
		switched1 = true
    end
	
	if switched1 then
	    SetString("game.tool.backrooms.name", "BACKROOMS")
	end	

	if GetString("game.player.tool") == "backrooms" then
		SetString("game.tool.backrooms.ammo.display", "")
		SetBool('hud.aimdot', false)
		if nameGone > 0 then
			nameGone = nameGone-1
		else
			SetString("game.tool.backrooms.name", "")
		end
	else
		nameGone = 90
	end
end

--[[function tick( dt )
	if GetString("game.player.tool") == "brasshammer"then
		if GetBool("game.player.canusetool") then
			t = GetCameraTransform()
			transform = TransformToParentVec(t, Vec(0, 0, -1))
			hit, dist, normal, shape = QueryRaycast(t.pos, transform, 3)
			
			if InputPressed("lmb") and hit and cooldown == 0 then
				cooldown = maxCooldown
				
				local pos = VecAdd(t.pos, VecScale(transform, dist))
				
				hit2, point, n, s = QueryClosestPoint(pos, 0.2)
				if(hit2) then
					MakeHole(point, canBreakLight, canBreakMedium, canBreakHeavy, false)
					--MakeHole(point, holeSize, holeSize, holeSize, false)
				end
				
				PlaySound(hitsnd[math.random(0,#hitsnd)], t.pos, 0.7)
			end
			
			if cooldown > 0 then
				cooldown = cooldown - 1
			end
		end
		
		if GetToolBody() ~= 0 then
			local swing = cooldown/maxCooldown
			local t = Transform()
			t.pos = Vec(0,0,swing*-0.3)
			t.rot = QuatEuler(swing*-40,0,0)
			SetToolTransform(t)
		end
	else
		cooldown = 0
	end
end--]]