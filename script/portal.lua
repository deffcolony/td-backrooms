
function init()
	portal = FindBody("portal")
end

function rnd(mi, ma)
	local v = math.random(0,1000) / 1000
	return mi + (ma-mi)*v
end

function tick(dt)

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

end