-- =============================================================================
--  bGroupCount
--    by: BurstBiscuit
-- =============================================================================

require "math"
require "table"
require "unicode"

require "lib/lib_Callback2"
require "lib/lib_ChatLib"
require "lib/lib_Debug"
require "lib/lib_HudManager"
require "lib/lib_InterfaceOptions"
require "lib/lib_Slash"

Debug.EnableLogging(false)


-- =============================================================================
--  Variables
-- =============================================================================

local FRAME = Component.GetFrame("Main")
local COUNT = Component.GetWidget("Count")


-- =============================================================================
--  Functions
-- =============================================================================

function Notification(message)
    ChatLib.Notification({text = "[bGroupCount] " .. tostring(message)})
end

function UpdateGroupCount()
    if (Platoon.IsInPlatoon()) then
        COUNT:SetText("Platoon (" .. tostring(#Platoon.GetRoster().members) .. "/" .. tostring(Platoon.GetMaxPlatoonSize()) .. ")")
        FRAME:Show(true)

    elseif (Squad.IsInSquad()) then
        COUNT:SetText("Squad (" .. tostring(#Squad.GetRoster().members) .. "/" .. tostring(Squad.GetMaxSquadSize()) .. ")")
        FRAME:Show(true)

    else
        FRAME:Show(false)
    end
end

function OnHudShow(show, duration)
    FRAME:ParamTo("alpha", tonumber(show), duration)
end

function OnSlashCommand()
    Notification("Showing test values for the text frame")

    Callback2.FireAndForget(function()
        COUNT:SetText("Test (" .. math.random(1, tonumber(Platoon.GetMaxPlatoonSize())) .. "/" .. tostring(Platoon.GetMaxPlatoonSize()) .. ")")
        FRAME:Show(true)
    end, nil, 1)

    Callback2.FireAndForget(function()
        UpdateGroupCount()
    end, nil, 11)
end


-- =============================================================================
--  Events
-- =============================================================================

function OnComponentLoad()
    -- Register the frame with InterfaceOptions to save position
    InterfaceOptions.SetCallbackFunc(nil)
    InterfaceOptions.AddMovableFrame({
        frame       = FRAME,
        label       = "bGroupCount",
        scalable    = true
    })

    -- Register with lib_HudManager
    HudManager.BindOnShow(OnHudShow)

    -- Register the slash command
    LIB_SLASH.BindCallback({
        slash_list  = "bgroupcount",
        description = "bGroupCount",
        func        = OnSlashCommand
    })
end

function OnSquadRosterUpdate(args)
    Debug.Event(args)
    UpdateGroupCount()
end
