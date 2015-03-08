-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
TestAddon = {}
 
-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
TestAddon.name = "TestAddon"
 
-- Next we create a function that will initialize our addon

function TestAddon:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  TestAddonIndicator:ClearAnchors()
  TestAddonIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end


function TestAddon:Initialize()
  self.inCombat = IsUnitInCombat("player")
  
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
  
  self.savedVariables = ZO_SavedVars:NewAccountWide("TestAddonSavedVariables", 1, nil, {})
  
  self:RestorePosition()
end

function TestAddon.OnPlayerCombatState(event, inCombat)
  -- The ~= operator is "not equal to" in Lua.
  if inCombat ~= TestAddon.inCombat then
    -- The player's state has changed. Update the stored state...
    TestAddon.inCombat = inCombat
 
    TestAddonIndicator:SetHidden(not inCombat)
 
  end
end

function TestAddon.OnIndicatorMoveStop()
  TestAddon.savedVariables.left = TestAddonIndicator:GetLeft()
  TestAddon.savedVariables.top = TestAddonIndicator:GetTop()
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function TestAddon.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == TestAddon.name then
    TestAddon:Initialize()
  end
end
 
-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(TestAddon.name, EVENT_ADD_ON_LOADED, TestAddon.OnAddOnLoaded)