
function init()
	tv = FindShape(tv)
	screen = FindShape(screen)
end


function tick()
	if IsShapeBroken(tv) then
        Delete(screen)
	end
end