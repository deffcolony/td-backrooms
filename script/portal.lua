
function init()
	portal = FindBody("portal")
	transitionTimer = 0
end

function rnd(mi, ma)
	local v = math.random(0,1000) / 1000
	return mi + (ma-mi)*v
end

function tick(dt)

	if transitionTimer > 0 then

		local amount = math.min(-0.02*transitionTimer^2+.32*transitionTimer,1)
		local spamt = math.min(-0.05*transitionTimer^2+1*transitionTimer + .2*(5*math.sin(GetTime())),1)
		local spamt2 = math.min(-0.02*transitionTimer^2+.33*transitionTimer,1)

		ParticleReset()
		ParticleEmissive(-1)
		ParticleRadius(rnd(0.1,0.2), 0.5, "smooth")
		-- local m = rnd(.6,.9)
		ParticleColor(rnd(.4,.3),rnd(.15,.2),rnd(.1,.15))
		ParticleTile(3)
		ParticleType("smoke")
		ParticleGravity(0)
	    ParticleAlpha(1,0)
		ParticleCollide(0)
		ParticleStretch(1)
		ParticleRotation(rnd(-1,1))
		for i = 1, math.random(10,20)*amount do
			local pos = GetRandomPortalPos(amount)
			PointLight(pos,rnd(.8,1),rnd(.7,.9),rnd(.5,.8),5*amount)
			SpawnParticle(pos,RSV(1),rnd(1,3))
		end

		local sp = LoadSprite("")
		DrawSprite(sp,Transform(TransformToParentPoint(GetBodyTransform(portal),Vec(.1,2.05,0)),QuatEuler(0,90,0)), 2.3*(1+3*spamt),4.1*(1+4*spamt), 10,20,10,.2*spamt, true, false)
		DrawSprite(sp,Transform(TransformToParentPoint(GetBodyTransform(portal),Vec(.11,2.05,0)),QuatEuler(0,-90,0)), 2.3*(1+3*spamt2),4.1*(1+4*spamt2), 10,20,10,.5*spamt2, true, false)
		DrawSprite(sp,Transform(TransformToParentPoint(GetBodyTransform(portal),Vec(.12,2.05,0)),QuatEuler(0,90,0)), 2.3*(1+3*spamt2),4.1*(1+4*spamt2), 10,20,10,spamt2, true, false)

		local tp = GetRandomPortalPos()
		local dist = VecLength(VecSub(GetCameraTransform().pos,tp))
		ShakeCamera(math.min(3*amount/dist),.8))

		transitionTimer = transitionTimer - dt

	else

		tipPos = TransformToParentPoint(GetBodyTransform(portal), Vec(0, rnd(0.1,4.2), rnd(-1.15,1.15)))
		tipPos2 = TransformToParentPoint(GetBodyTransform(portal), Vec(0, rnd(0.2,3.9), rnd(-1.1,1.1)))
		tipPos3 = TransformToParentPoint(GetBodyTransform(portal), Vec(0, rnd(0.1,4.1), rnd(-1.0,1.0)))
		tipPos4 = TransformToParentPoint(GetBodyTransform(portal), Vec(0, rnd(0.15,4.0), rnd(-1.12,1.12)))
		
		local ParticleLife1 = 1
		
		ParticleReset()
		ParticleEmissive(0.1)
		ParticleRadius(rnd(0.03,0.4), 0.1, "smooth")
		ParticleColor(0.9,0.9,rnd(0.2,0.6))
		ParticleTile(1)
		ParticleType("smoke")
		ParticleGravity(0)
	    ParticleAlpha(rnd(0.03,0.35))
		ParticleCollide(0)
		ParticleStretch(100)
		ParticleRotation(-1)
		
		for i=1,1 do 
		    --SpawnParticle(tipPos, Vec(0,rnd(-0.3,0.3),rnd(-0.3,0.3)), ParticleLife1)
			SpawnParticle(tipPos2, Vec(0,0,0), ParticleLife1)
			SpawnParticle(tipPos3, Vec(0,0,0), ParticleLife1)
			--PointLight(tipPos3, 0.9,0.9,rnd(0.1,0.7), 0.03)
		end


		ParticleReset()
		ParticleEmissive(0.1)
		ParticleRadius(rnd(0.03,0.7), 0.1, "smooth")
		ParticleColor(0.9,0.9,rnd(0.1,0.7))
		ParticleTile(3)
		ParticleType("smoke")
		ParticleGravity(0)
	    ParticleAlpha(rnd(0.03,0.15))
		ParticleCollide(0)
		ParticleStretch(100)
		ParticleRotation(1)
		
		for i=1,1 do 
		    SpawnParticle(tipPos4, Vec(0,0,0), ParticleLife1)
			--SpawnParticle(tipPos2, Vec(0,rnd(-0.3,0.3),rnd(-0.3,0.3)), ParticleLife1)
			SpawnParticle(tipPos3, Vec(0,0,0), ParticleLife1)
			--PointLight(tipPos3, 0.9,0.9,rnd(0.1,0.7), 0.03)
		end	

		if InputPressed("n") then
			transitionTimer = 20
		end

	end

end

function GetRandomPortalPos(tim)
	if tim == nil then tim = .4 end
	return TransformToParentPoint(GetBodyTransform(portal), Vec(-.4+.6*tim, rnd(0.1,4.2), rnd(-1.15,1.15)))
end

function RSV(r)
	local theta = math.random() * 2 * math.pi
	local phi = math.acos(2 * math.random() - 1)

	local x = r * math.sin(phi) * math.cos(theta)
	local y = r * math.sin(phi) * math.sin(theta)
	local z = r * math.cos(phi)

	return Vec(x, y, z)
end