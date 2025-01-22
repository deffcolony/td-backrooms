function init()
    screen = FindScreen("")
    shape = GetScreenShape(screen)
    interactName = ""
    reqJoints = FindJoints("required")

    if (not HasTag(shape, "interact")) then
        SetTag(shape, "interact", "Use")
        interactName = "Use"
    else
        interactName = GetTagValue(shape, "interact")
    end
end

function tick(dt)
    isBroken = isBroken or IsShapeBroken(shape)

    if (isBroken) then
        RemoveTag(shape, "interact")
        if (IsScreenEnabled(screen)) then
            SetScreenEnabled(screen, false)
        end
    else
        isBroken = IsAnyJointBroken(reqJoints)

        if (GetPlayerScreen() ~= screen and (InputDown("pause") or InputDown("interact"))) then
            SetTag(shape, "interact", interactName)
        end
        
        if (GetPlayerInteractShape() == shape and InputPressed("interact")) then
            SetPlayerScreen(screen)
            RemoveTag(shape, "interact")
        end
    end
end

function IsAnyJointBroken(j)
    for i, v in pairs(j) do
        if (IsJointBroken(v)) then
            return true;
        end
    end
    return false;
end