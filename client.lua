local show3DText = false
local playersDroppedCombat = {}

RegisterCommand('showcombat', function()
    if show3DText then
        show3DText = false
        lib.notify({
            title = 'Notification',
            description = 'Shutting down players who have disconnected',
            type = 'error'
        })
    else
        show3DText = true
        lib.notify({
            title = 'Notification',
            description = 'Starting disconnected players',
            type = 'success'
        })
        DisplayCombatLog()
        Wait(5*60*1000)
        show3DText = false
        lib.notify({
            title = 'Notification',
            description = 'Shutting down players who have disconnected',
            type = 'error'
        })
    end
end)

RegisterNetEvent("olifka_combatlog", function(id, crds, identifier, reason, name)
    local curid = #playersDroppedCombat + 1
    playersDroppedCombat[curid] = {
        id = id,
        reason = reason,
        identifier = identifier,
        crds = crds,
        name = name
    }

    SetTimeout(2*60*1000, function()
        playersDroppedCombat[curid] = nil
    end)
end)

function DisplayCombatLog()
    CreateThread(function()
        while show3DText do
            Wait(0)
            local pcoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(playersDroppedCombat) do
                local crds = v.crds
                if #(vec3(crds.x, crds.y, crds.z) - vec3(pcoords.x, pcoords.y, pcoords.z)) < 15.0 then
                    DrawText3DCombatLogSecond(crds.x, crds.y, crds.z+0.15, "Player ["..v.name.."] disconnected the game")
                    DrawText3DCombatLog(crds.x, crds.y, crds.z, "ID: "..v.id.." - ("..v.identifier..")\nReason: "..v.reason)
                end
            end
        end
    end)
end

function DrawText3DCombatLogSecond(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextProportional(1)
    SetTextColour(255,0,0, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3DCombatLog(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextProportional(1)
    SetTextColour(255,255,255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end