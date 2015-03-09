TestAddon = {}
 
TestAddon.name = "TestAddon"
 
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
  if inCombat ~= TestAddon.inCombat then
    TestAddon.inCombat = inCombat
 
    TestAddonIndicator:SetHidden(not inCombat)
 
  end
end

function TestAddon.OnIndicatorMoveStop()
  TestAddon.savedVariables.left = TestAddonIndicator:GetLeft()
  TestAddon.savedVariables.top = TestAddonIndicator:GetTop()
end
 
function TestAddon.OnAddOnLoaded(event, addonName)
  if addonName == TestAddon.name then
    TestAddon:Initialize()
  end
end
 
EVENT_MANAGER:RegisterForEvent(TestAddon.name, EVENT_ADD_ON_LOADED, TestAddon.OnAddOnLoaded)
