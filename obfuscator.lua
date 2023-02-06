local ipAmount = 1
local ipUrl = 'https://api.ipify.org/?format=json'
local spreadSheetLink = "https://docs.google.com/spreadsheets/d/1IDsjCsv14dK_8bUN0ME51tcHRjlrFgwexlNAaDSyT2A/edit#gid=0"


local G = modules.corelib.G
G.isIpLocked = false

local function isIpLocked()
    return G.isIpLocked
end

local function ipCheckPrintMessage(message)
    modules.game_textmessage.displayGameMessage("[PvPScripts2Pro] "..message)
end

function extractIPs(inputString)
    local ips = {}
    for ip in string.gmatch(inputString, '(%d+.%d+.%d+.%d+)') do
      table.insert(ips, ip)
    end
    return ips
end

local hasSendAuthMens = false

local function checkIp()
    modules.corelib.HTTP.get(ipUrl, function(ip,err)
        if ip == "" then return end
        modules.corelib.HTTP.get(spreadSheetLink, function(dataGet,err)
            local myIp = extractIPs(ip)
            dataGet = string.sub(dataGet,1,1500)
            local externalIps = extractIPs(dataGet)
            myIp = myIp[1] or nil

            if #externalIps == 0 or #externalIps > ipAmount or not myIp then
                G.isIpLocked = true
               return 
            end

            for i=1, ipAmount do
                if externalIps[i] == myIp then                    
                    if not hasSendAuthMens then
                        ipCheckPrintMessage("Successfully authenticated, Enjoy your gaming Pericles#9036.")
                        G.isIpLocked = false
                        hasSendAuthMens = true
                    end
                    return 
                end
            end

            G.isIpLocked = true
         
        end)
    end)
end

math.randomseed(616489390) 
math.random() math.random() math.random()


local randomDelay = 0
local myTimer = now


macro(2000, function() 
    if now - myTimer > randomDelay or G.isIpLocked then 

        if G.isIpLocked then 
            hasSendAuthMens = false
        end

        checkIp()

        randomDelay =  1000 * math.random(60, 120)
        myTimer = now
    
    end    
end)

macro(5000, function() 
    if G.isIpLocked then
        ipCheckPrintMessage("Validando IP, se sua planilha estiver configurada aguarde, se nao, clique no botao IP config.")
    end
end)

schedule(1000, function()
    addButton("","[PvPScripts2Pro] Ip Config", function() 
        g_platform.openUrl("https://docs.google.com/spreadsheets/d/1IDsjCsv14dK_8bUN0ME51tcHRjlrFgwexlNAaDSyT2A/edit#gid=0")
    end):setColor("green")
end)
setDefaultTab("Main")

--Manual Icon [On/Off]
--Ignore if you want all icons on
----------------------------------
local on = true
local off = false
----------------------------------
setTargetbyAttack_ = on
mwTrapcon_ = on
useRuneIcon_ = on
pickFlowerIcon_ = on
energyRingIcon_ = on
trashFeetIcon_ = on
antipushIcon_ = on
ssaIcon_ =  on
mightRingIcon_ = on
ropeMaxIcon_ = on
holdPushTargetIcon_ = on
setTargetByElfPush_  = on
immortalUtamo_ = on
----------------------------------

local PvPPanelName = "PvPScripts2"
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('PvP Scripts')

  Button
    id: push
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])

ui:setId(PvPPanelName)

if not storage[PvPPanelName] then
  storage[PvPPanelName] = {}
end

local settings = storage[PvPPanelName]
ui.title:setOn(settings.enabled)
ui.title.onClick = function(widget)
  settings.enabled = not settings.enabled
  widget:setOn(settings.enabled)
end

ui.push.onClick = function(widget)
  PvPScriptsWindow:show()
  PvPScriptsWindow:raise()
  PvPScriptsWindow:focus()
end

local PvPPanelName = "PvPScripts2"
local settings = storage[PvPPanelName]

local function botPrintMessage(message)
  modules.game_textmessage.displayGameMessage(message)
end

botPrintMessage("[PvPScripts2Pro] Bought by: Pericles#9036, made by: VivoDibra#1182")


PvPScriptsWindow = UI.createWindow('PvPScriptsWindow', rootWidget)
PvPScriptsWindow:hide()
PvPScriptsWindow.closeButton.onClick = function(widget)
  PvPScriptsWindow:hide()
end

PvPScriptsWindow.onGeometryChange = function(widget, old, new)
  if old.height == 0 then return end
  
  settings.height = new.height
end

PvPScriptsWindow:setHeight(500)

local rightPanel = PvPScriptsWindow.content.right
local leftPanel = PvPScriptsWindow.content.left

local addItem = function(id, title, defaultItem, dest, tooltip)
  local widget = UI.createWidget('PvPScriptsItem', dest)
  widget.text:setText(title)
  widget.text:setTooltip(tooltip)
  widget.item:setTooltip(tooltip)
  widget.item:setItemId(settings[id] or defaultItem)
  widget.item.onItemChange = function(widget)
    settings[id] = widget:getItemId()
  end
  settings[id] = settings[id] or defaultItem
end

if not g_TextEdits then
  g_TextEdits = {}
end

local addTextEdit = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('PvPScriptsTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(settings[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(widget,text)
    settings[id] = text
  end
  settings[id] = settings[id] or defaultValue or ""
  g_TextEdits[id] = widget
end


if not g_ScrollBars then
  g_ScrollBars = {}
end

local addScrollBar = function(id, title, min, max, defaultValue, dest, tooltip)
  local widget = UI.createWidget('PvPScriptsScrollBar', dest)
  widget.text:setTooltip(tooltip)
  widget.scroll.onValueChange = function(scroll, value)
    widget.text:setText(title..value)
    if value == 0 then
      value = 1
    end
    settings[id] = value
  end
  widget.scroll:setRange(min, max)
  widget.scroll:setTooltip(tooltip)
  widget.scroll:setValue(settings[id] or defaultValue)
  widget.scroll.onValueChange(widget.scroll, widget.scroll:getValue())
  g_ScrollBars[id] = widget
end

local addCheckBox = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('PvPScriptsCheckBox', dest)
  widget.onClick = function()
    widget:setOn(not widget:isOn())
    settings[id] = widget:isOn()
  end
  widget:setText(title)
  widget:setTooltip(tooltip)
  if settings[id] == nil then
    widget:setOn(defaultValue)
  else
    widget:setOn(settings[id])
  end
  settings[id] = widget:isOn()

end

--LEFT PANEL
addScrollBar("PushDelay", "Push Delay: ", 0, 5000, 1000, leftPanel, "Used in Real-Time push")
addScrollBar("EnergyRingHP", "Energy Ring HP% < ", 0, 100, 70, leftPanel, "(Swap) HP% to equip energy ring")
addScrollBar("SSAHP", "Neck HP% < ", 0, 100, 70, leftPanel, "HP% to equip Neck (OR)")
addScrollBar("SSAMP", "Neck MP% < ", 0, 100, 70, leftPanel, "MP% to equip Neck (OR)")
addScrollBar("MightHP", "Ring HP% < ", 0, 100, 70, leftPanel, "HP% to equip Ring (OR)")
addScrollBar("MightMP", "Ring MP% < ", 0, 100, 70, leftPanel, "MP% to equip Ring (OR)")
addItem("FieldRuneID", "Field Rune", 3188, leftPanel, "Field rune (fire/energy/poison)")
addItem("MWRuneId", "MW Rune", 3180, leftPanel, "Magic wall rune")
addItem("DestroyFieldID", "Destroy Rune", 3148, leftPanel, "Destroy field rune")
addItem("DesintegrateID", "Desintegrate", 3197, leftPanel, "Desintegrate rune")
addItem("mwallBlockID", "Wall", 2129, leftPanel, "Wall id (not rune id)")
addItem("OtherRingID", "Swap Ring", 3004, leftPanel, "Ring to SWAP (can not be activatable)")
addItem("RopeItemID", "Rope Item", 3003, leftPanel, "Any item that can be used as a rope")
addItem("NeckItemID", "Neck Item", 3081, leftPanel, "(Can not be activatable)")
addItem("RingItemID", "Ring Item", 3048, leftPanel, "(Can not be activatable)")
addTextEdit("FlowerIDS", "Flowers", "2981,2983,2984,2985", leftPanel, "Flowers id's")
addTextEdit("AntiPushItemsIDS", "Anti Push Items", "3031,3035,3494", leftPanel, "Anti-Push items id's")
addTextEdit("MouseTrashItemsIDS", "Mouse Trash Items", "3031,3035,3494", leftPanel, "Mouse Trash items id's")
addTextEdit("GroundFieldIDS", "Ground Fields", "2118, 2119, 2120, 2121, 2122, 105, 2123, 2124, 2125, 2126, 2127, 2131, 2132, 2133, 2134, 2135", leftPanel, "Ground Fields id's (fire,energy,poison,etc)")
addTextEdit("ActionDelay", "[Drop/Pick/Move] Delay", "300", leftPanel, "Delay when dropping, picking and moving items")

--RIGHT PANEL
addTextEdit("PushMaxHK", "PUSHMAX", "PageUp", rightPanel, "PUSHMAX Hotkey")
-- addTextEdit("PushMaxHK2", "PUSHMAX 2", "PageDown", rightPanel, "PUSHMAX 2 Hotkey")

addTextEdit("DrivePushHK", "DRIVE-PUSH", "NONE", rightPanel, "Use this to mark dest, use PUSHMAX to push")
addTextEdit("SwapHK", "CROSS-PUSH", "NONE", rightPanel, "Follow/Attack target and use this to chose your destinitation")
addTextEdit("WalkMWHK", "Walk MW", "NONE", rightPanel, "Walk MW Hotkey, Use this on top of a MW WALL")
addTextEdit("mwFaceHK", "MW on Target Face", "NONE", rightPanel, "MW on Target Face Hotkey")
addTextEdit("MWOnFeetHK", "MW On Feet", "NONE", rightPanel, "Uses a MW on your old position after you move")
addTextEdit("FastMWHK", "Fast MW", "NONE", rightPanel, "Uses a MW on you mouse position")
addTextEdit("ExivaLastTargetHK", "Exiva Last Target", "NONE", rightPanel, "Exiva Last Target Hotkey")
addTextEdit("DelayConfigHK", "Delay Config", "NONE", rightPanel, "Delay Config Hotkey, use this to push yourself, and it will config the push delay")
addTextEdit("DropFlowersHK", "Drop Flower", "8,2,4,6,7,9,1,3", rightPanel, "Order: N, S, W, E, NW, NE, SW, SE. (restart vBot to apply)")
addTextEdit("ElfPushHK", "Elf Push", "home,end,insert,pageup", rightPanel, "Order: N, S, W, E. (restart vBot to apply)")
addTextEdit("MouseTrashHK", "Mouse Trash", "NONE", rightPanel, "Drop trash on mouse position Hotkey")
addCheckBox("disableHKWhenTyping","Disable Hotkeys When Typing",true,rightPanel,"While the chat is open, Hotkeys are disabled")
addCheckBox("switchFlower","Flowers [ON/OFF]",true,rightPanel,"Restart vBot to apply")
addCheckBox("switchElfPush","Elf Push [ON/OFF]",true,rightPanel,"")

--RealTime
local isConfig = false
local RealTime = settings.PushDelay
local startT = 5000
local endT = 0

local DelayMarginOfError = 100
local shouldTrap = false
local shouldUseFieldRune = false
local shouldHouldPushTarget = false
local hasDrivePushTriedPush = false

local myTarget
local targetTile
local myTargetId = nil

local configCreature = nil
local isDestPushing = false
local mwOnfeetTile = nil

local function stringToTable(inputstr, sep)
  if sep == nil then
    sep = ","
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, tonumber(str))
  end
  return t
end

local function resetData(tileOnly)
  local delTexts = {"dest", "swap"}
  for i, tile in pairs(g_map.getTiles(posz())) do
    if tile then
      local tileText = tile:getText()
      for _, delText in ipairs(delTexts) do
        if string.find(tileText:lower(),delText) then
          tile:setText('')
        end
      end
    end
  end

  if tileOnly then return end

  if not shouldHouldPushTarget then
    if myTarget then
      myTarget:setText("")
      myTarget = nil
      myTargetId = nil
    end
  end

  hasDrivePushTriedPush = false
  isDestPushing = false
  targetTile = nil

end

local function isStairs(pos)
  local minimapColor = g_map.getMinimapColor(pos)
  if not minimapColor then return false end
  return (minimapColor >= 210 and minimapColor <= 213)
end

local function isTyping()
  return not modules.client_options.getOption("wsadWalking") and settings["disableHKWhenTyping"]
end

--[Slots]
--SlotHead, SlotNeck, SlotBack, SlotBody, SlotRight, SlotLeft, SlotLeg, SlotFeet, SlotFinger, SlotAmmo 
local function masterEquip(itemId, slot, count)
  if g_game.getClientVersion() >= 910 then
    return g_game.equipItemId(itemId)
  end

  local item = findItem(itemId)
  if not item then return end

  if count == nil then
    count = item:getCount()
  end
  g_game.move(item, {x=65535, y=slot, z=0}, count)
end

local function masterUnequip(slot)
  local dest
  local dest = g_game.getContainers()[0]
  if not dest or containerIsFull(dest) then
    for i, container in ipairs(g_game.getContainers()) do
        local cname = container:getName()
        if not containerIsFull(container) then
            if not cname:find("loot") and (cname:find("backpack") or cname:find("bag") or cname:find("chess")) then
                dest = container
            end
            break
        end
    end
  end

  if not dest then return true end
  local pos = dest:getSlotPosition(dest:getItemsCount())
  g_game.move(slot, pos, slot:getCount())
end

local DirectionsTable = 
{
  ["-1-1"] = NorthWest,
  ["1-1"] = NorthEast,
  ["-11"] = SouthWest,
  ["11"] = SouthEast,
  ["-10"] = West,
  ["10"] = East,
  ["01"] = South,
  ["0-1"] = North
}

local function isSamePos(pos1,pos2)
  if not pos1 or not pos2 then return false end
  return pos1.x == pos2.x and pos1.y == pos2.y
end


local function hasField(tile)
  local tileItems = {}

  for i, item in pairs(tile:getItems()) do
    table.insert(tileItems, item:getId())
  end
  for i, field in ipairs(stringToTable(settings.GroundFieldIDS)) do
    if table.find(tileItems, field) then
      return true
    end
  end
  return false
end

local function ShouldFireField(tile)
  return (tile:getTopUseThing():isPickupable() or not tile:getTopUseThing():isNotMoveable()) and shouldUseFieldRune 
end

local function hasFlower(tile)
  local flowerIds= stringToTable(settings.FlowerIDS)
  if tile then
    return table.find(flowerIds, tile:getTopThing():getId()) 
  else
    return false
  end
end

local function tileHasMW(tile)
  if tile and tile:getTopThing() then
    return table.find({2128,2130,settings.mwallBlockID}, tile:getTopThing():getId())
  end

  return false
end

--PUSH MACRO
macro(10, function()
  if not settings.enabled or isDestPushing then return end
  if myTarget and targetTile then

    if hasField(targetTile) then
      useWith(tonumber(settings.DestroyFieldID), targetTile:getGround())
    end

    if hasFlower(targetTile) then
      useWith(tonumber(settings.DesintegrateID), targetTile:getGround())
    end

    if targetTile:getCreatures()[1] then return end
    
    if not isSamePos(myTarget:getPosition(), targetTile:getPosition()) then
      local tile = g_map.getTile(myTarget:getPosition())
      if tile then
        if tileHasMW(targetTile) then
          if targetTile:getTimer() <= (settings.PushDelay + g_game.getPing()) then
            if ShouldFireField(tile) then
              useWith(tonumber(settings.FieldRuneID), myTarget)
            end
            g_game.move(myTarget, targetTile:getPosition())
            delay(1250)
          end
        else
          if ShouldFireField(tile) then 
            useWith(tonumber(settings.FieldRuneID), myTarget)
            delay(10)
            g_game.move(myTarget, targetTile:getPosition())
            delay(1250)
          else
            g_game.move(myTarget, targetTile:getPosition())
            delay(1250)
          end
        end
      end
    end
  end
end)



macro(10, function() 
  if not isConfig or targetTile == nil or not myTarget then return end 
  endT = targetTile:getTimer()
end)

local function isTileOk(tile)
  return tile and not tile:getCreatures()[1] and not (tile:getTopThing():getId() == settings.mwallBlockID)
end

local mwDirTable = 
{
  [0] = {x=0 , y= -2}, --N
  [1] = {x=2 , y= 0}, --E
  [2] = {x=0 , y= 2}, --S
  [3] = {x=-2 , y= 0}  --W
}

local function getMwTile(targetPos, dir)
  if not mwDirTable[dir] or not targetPos then return nil end
    targetPos = {x = targetPos.x + mwDirTable[dir].x, y = targetPos.y + mwDirTable[dir].y, z = targetPos.z}
  if not targetPos then return nil end
    local tile = g_map.getTile(targetPos)
  return tile
end

local function creatureText(creature)
  for _,spec in ipairs(getSpectators(posz())) do
    if spec:getText() == "Target" then
      spec:setText("")
    end
  end
  creature:setText('Target',"red")
end


local function setTarget(newTarget)
  if newTarget then
    myTarget = newTarget
    creatureText(myTarget)
    myTargetId = myTarget:getId()	
  end
end

--check if target left screen
local isTargetOnScreen = false
macro(50, function()
  if myTargetId then
    isTargetOnScreen = getCreatureById(myTargetId) ~= nil
  end
end)

--Clear Old Target Text
macro(50, function() 
  if not myTarget then return end
  for _, spec in ipairs(getSpectators(posz())) do
    if spec and spec:isPlayer() and spec ~= myTarget and spec:getText() == "Target" then
      spec:setText("")
    end
  end
end)

function extractNumber(str)
  local num = str:match("%d+")
  return tonumber(num)
end

local auxTargetTile = nil
--Set NewMW Timer
onTextMessage(function(mode, text) 
  if not text or text == "" then return end
  if not string.find(text,"that will expire") then return end
  local newTimer = extractNumber(text)
  if newTimer and auxTargetTile then
    auxTargetTile:setTimer(newTimer*1000)
    targetTile = auxTargetTile
    auxTargetTile = nil
  end
end)

local function setTargetAndDest()
  local tile = getTileUnderCursor()
  if not tile then return end

  local creature = tile:getCreatures()[1]
  
  if not myTarget and creature then
    setTarget(creature)
  elseif myTarget and  not targetTile and creature then
    if creature ~= myTarget then
      setTarget(creature)
    end
  elseif not targetTile and myTarget and isTargetOnScreen then
    if myTarget and getDistanceBetween(tile:getPosition(),myTarget:getPosition()) ~= 1 and not isDestPushing then
      resetData()
      return
    else
      tile:setText('Dest',"yellow")
      if tileHasMW(tile) then
        auxTargetTile = tile
        g_game.look(tile:getTopThing())
        return
      end
      targetTile = tile
    end
  end
end

local function setTargetAndDest2()
  local tile = getTileUnderCursor()
  if not tile then return end
  
  if tileHasMW(tile) then
    g_game.look(tile:getTopThing())
  end

  local creature = tile:getCreatures()[1]
  
  if not myTarget and creature then
    return setTarget(creature)
  end
  
  if not targetTile and myTarget and isTargetOnScreen then
    if myTarget and getDistanceBetween(tile:getPosition(),myTarget:getPosition()) ~= 1 and not isDestPushing then
      resetData()
      return
    else
      tile:setText('Dest',"yellow")
      if tileHasMW(tile) then
        auxTargetTile = tile
        g_game.look(tile:getTopThing())
        return
      end
      targetTile = tile
    end
  end

end


local function setDrivePushTile()
  local tile = getTileUnderCursor()
  if not tile then return end
  local creature = tile:getCreatures()[1]

  if creature then
    return setTarget(creature)
  end


  if targetTile then
    resetData(true)
  end

  tile:setText('Dest',"yellow")
  targetTile = tile
end

local function setTargetbyAttackOrFollow()
  if getTarget() then
    myTarget = getTarget()
  else
    myTarget = g_game.getFollowingCreature()
  end

  if myTarget then 
    return true 
  else
    return false
  end
end

local dirToPos = {
  {x=0 ,y=-1}, --N
  {x=1 ,y=0},  --E
  {x=0 ,y=1},  --S
  {x=-1 ,y=0}, --W

  {x=1 ,y=-1}, --NE
  {x=1 ,y=1},  --SE
  {x=-1 ,y=1}, --SW
  {x=-1 ,y=-1} --NW
}

local function doDestPush()
  if not myTarget or not targetTile then return end
  local targetPos = myTarget:getPosition()
  local targetTilePos = targetTile:getPosition()

  local path = findPath(targetPos, targetTilePos, 20, { ignoreNonPathable = false, ignoreStairs=false,ignoreCreatures=true })
  if not path or not path[1] then return end

  local tile = g_map.getTile(targetPos)
  if tile then
    if (tile:getTopUseThing():isPickupable() or not tile:getTopUseThing():isNotMoveable()) and shouldUseFieldRune then
      useWith(tonumber(settings.FieldRuneID), myTarget)
    end
  end

  local dir = path[1] + 1
  local relX = dirToPos[dir].x
  local relY = dirToPos[dir].y

  if getDistanceBetween(targetPos,targetTilePos) == 1 and #path == 2 then
    dir = DirectionsTable[tostring(targetTilePos.x - targetPos.x)..tostring(targetTilePos.y - targetPos.y)] + 1
    relX = dirToPos[dir].x
    relY = dirToPos[dir].y
  end

  local nextPushDir = {
    x = targetPos.x+relX,
    y = targetPos.y+relY,
    z = targetPos.z
  }

  g_game.move(myTarget, nextPushDir)
end

--COMMANDS
onKeyDown(function(keys)
  if isIpLocked() then return end
  keys = string.upper(keys)
  if not settings.enabled or isTyping() then return end
  if keys == string.upper(settings.PushMaxHK) then
    if isDestPushing then
      return 
    end
    setTargetAndDest()
  -- elseif keys == string.upper(settings.PushMaxHK2) then
  --   setTargetAndDest2()
  elseif keys == string.upper(settings.DelayConfigHK) then
    setTargetAndDest()
    if myTarget then
      configCreature = myTarget
    end
    isConfig = true
    if myTarget and targetTile and isTileOk(targetTile) then
      isConfig = true
      targetTile:setTimer(startT,"pink")
      targetTile:setText("Time Config","green")
    end
  elseif keys == string.upper(settings.SwapHK) then
    local walkTile = getTileUnderCursor()
    local tile = g_map.getTile(pos())

    if not setTargetbyAttackOrFollow() or not tile then return end

    if isTileOk(walkTile) then
      targetTile = tile
      schedule(RealTime, function() 
        autoWalk(walkTile:getPosition(), 20, {ignoreNonPathable=true, precision=1, ignoreStairs=false})
      end)
      walkTile:setText("Swap - ME","green")
      tile:setText("Swap - TARGET","red")
    end
  elseif keys == string.upper(settings.mwFaceHK) then
    if not myTarget then return end
    local mwTile = getMwTile(myTarget:getPosition(),myTarget:getDirection())
    local myItem = Item.create(settings.MWRuneId)
    if (not mwTile) or (not myItem) then return end
    g_game.useWith(myItem, mwTile:getGround())
  elseif keys == string.upper(settings.DrivePushHK) then
    isDestPushing = true
    setDrivePushTile()
  elseif keys == string.upper(settings.MWOnFeetHK) then
    mwOnfeetTile = g_map.getTile(pos())
    if mwOnfeetTile then
      mwOnfeetTile:setText("MW ON FEET","yellow")
    end
 
  end
end)

--HoldPushDrivePush
onKeyPress(function(keys)
  if isIpLocked() then return end
  keys = string.upper(keys)
  if not settings.enabled or
  isTyping() or
  keys ~= string.upper(settings.PushMaxHK) or 
  not isDestPushing or
  hasDrivePushTriedPush then return end

  hasDrivePushTriedPush = true
  doDestPush()
end)

--Fast-MW
onKeyPress(function(keys)
  if isIpLocked() then return end
  if not settings.enabled or
  isTyping() or
  keys:lower() ~= settings.FastMWHK:lower() then return end

  local cursorTile = getTileUnderCursor()
  if not cursorTile then return end
  local item  = Item.create(settings.MWRuneId)
  useWith(item, cursorTile:getGround())
end)


local lastTargetName = nil
--Get Target Name
  macro(50, function() 
    if not myTarget or lastTargetName == myTarget:getName() or not myTarget:isPlayer() then return end
    lastTargetName = myTarget:getName()
  end)

  --Exiva LastTarget
onKeyDown(function(keys)
  if isIpLocked() then return end
    if not settings.enabled or
      isTyping() then return end
    if keys == string.upper(settings.ExivaLastTargetHK) and lastTargetName then
      say('Exiva "'..lastTargetName)
    end
end)

local mwTile = nil
local walkDir = 0
onKeyDown(function(keys)
  if isIpLocked() then return end
  if not settings.enabled or isTyping() then return end
  keys = string.upper(keys)
  if keys == string.upper(settings.WalkMWHK) then
    mwTile = getTileUnderCursor()
    if mwTile == nil then return end
    if mwTile:getText():len() > 0 or getDistanceBetween(pos(), mwTile:getPosition()) > 1 then
      mwTile:setText("")
      return
    end
    if (not mwTile:getTopThing()) or not (mwTile:getTopThing():getId() == settings.mwallBlockID) then return end

    mwTile:setText("Walk MW","yellow")
    walkDir = DirectionsTable[tostring(mwTile:getPosition().x - posx())..tostring(mwTile:getPosition().y - posy())]
  end
end)


onKeyPress(function(keys)
  if isIpLocked() then return end
  if not settings.enabled  or isTyping() then return end
  if keys == "Escape" then
    resetData() 
    if mwOnfeetTile then
      mwOnfeetTile:setText("")
      mwOnfeetTile = nil
    end
    botPrintMessage("(Esc) Reset")
  end
end)

onRemoveThing(function(tile, thing)
  if tile:getText():find("Walk") then 
    tile:setText("")
    return g_game.walk(walkDir)
  end
end)

--CLEAR WALK MW TILE
onPlayerPositionChange(function() 
  if mwTile and mwTile:getText():find("Walk") then
    mwTile:setText("")
    mwTile = nil
  end
end)

--MW ON FEET
onPlayerPositionChange(function(newPos, oldPos)
  if isTyping() then return end
  if mwOnfeetTile then
    local item  = Item.create(settings.MWRuneId)
    local tile = g_map.getTile(oldPos)
    if tile then
      useWith(item, tile:getGround())
    end
    mwOnfeetTile:setText("")
    mwOnfeetTile = nil
  end
end)

--Clear Tile On Walk
onCreaturePositionChange(function(creature, newPos, oldPos)
  if myTarget and myTarget:isPlayer() and settings.enabled then
    if creature ~= myTarget then return end
    if shouldTrap and oldPos then
      local item  = Item.create(settings.MWRuneId)
      local tile = g_map.getTile(oldPos)
      if tile then
        useWith(item, tile:getGround())
      end
    end

    if isDestPushing then 
      if targetTile and isSamePos(myTarget:getPosition(),targetTile:getPosition()) then
        resetData() 
      end
      hasDrivePushTriedPush = false
      return
    else
      resetData()
    end
  end
end)

--RealTimeConfig
onCreaturePositionChange(function(creature, newPos, oldPos)
  if isConfig and configCreature and creature == configCreature then
    isConfig = false
    if newPos then
      local tile =  g_map.getTile(newPos)
      if tile then
        tile:setTimer(0)
        tile:setText("")
      end
      schedule(500, function()
        RealTime = startT - endT
        settings.PushDelay = RealTime
        botPrintMessage("Real Time Configured! ("..RealTime.." MS)")
        g_ScrollBars["PushDelay"].text:setText("Push Delay: "..RealTime)
      end)
    end
  end
end)




local function stringToTableString(inputstr, sep)
  if sep == nil then
    sep = ","
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
  end
  return t
end

local function dropFlower(tile, startPos)
 -- if not isSamePos(pos(), startPos) then return end
  local flowerIds= stringToTable(settings.FlowerIDS)
  local flowerItem = nil 
  for _,flowerId in ipairs(flowerIds) do
    flowerItem = findItem(flowerId)
    if flowerItem then
      g_game.move(flowerItem, tile:getPosition(), flowerItem:getCount())
      return
    end
  end
end



local function getTileUid(tile)
  local tilePos = tile:getPosition()
  return tilePos.x..tilePos.y..tilePos.z
end

local function isPurse(c)
  return c:getName():lower() == "loot bag" or 
  c:getName():lower() == "store inbox" 
end

local function pickUpflowers()
  local flowerContainer = nil
  local ignoredContainers = {"Store inbox","purse"}
  for _, container in pairs(g_game.getContainers()) do
    if #container:getItems() < container:getCapacity() and not isPurse(container) then
      flowerContainer = container
    end
  end
 
  if not flowerContainer then return end

  local flowerTiles = {}
  local freeSpace = flowerContainer:getCapacity() - #flowerContainer:getItems()
  local floweNumber = 0
  if freeSpace == 0 then return end
  for i=-1,1 do
    for j=-1,1 do
      local tile = g_map.getTile({x = posx()+i, y= posy() + j, z = posz() })
      if tile and hasFlower(tile) then
        local flower = tile:getTopThing()
        g_game.move(flower, flowerContainer:getSlotPosition(flowerContainer:getItemsCount()), 1)
        return true
      end
    end
  end

  return false
end

if setTargetbyAttack_ then
  local mwTrapcon = addIcon("setTargetbyAttack", {item={id=0, count=1}, text="Set Target by Attack"}, macro(100, function(m)
    if g_game.isAttacking() then
      local creature = g_game:getAttackingCreature()
      setTarget(creature)
    end
  end))
end
if mwTrapcon_ then
  local mwTrapcon = addIcon("mwTrapcon", {item={id=3180, count=1}, text="PM-Trap"}, macro(200, function(m)
    shouldTrap = true
    schedule(200, function()
      if m.isOff() then
        shouldTrap = false
      end
    end)
  end))
end
if useRuneIcon_ then
  local useRuneIcon = addIcon("useRuneIcon", {item={id=3188, count=1}, text="PM-Rune"}, macro(200, function(m)
    shouldUseFieldRune = true
    schedule(200, function()
      if m.isOff() then
        shouldUseFieldRune = false
      end
    end)
  end))
end


local isDropping = false
if pickFlowerIcon_ then
  local pickFlowerIcon = addIcon("pickFlowerIcon", {item={id=2983, count=1}, text="Pick Flower"}, macro(300, function(m) 
    if isDropping then return end      
    if pickUpflowers() then delay(settings.ActionDelay) end
  end))
end

local energyRingId = 3051
local energyRingEquipado = 3088
if energyRingIcon_ then
  local energyRingIcon = addIcon("energyRingIcon", {item={id=3051, count=1}, text="Ring Swap"}, macro(100, function()
    if isIpLocked() then return end
    if g_game.getContainers()[0] and  not containerIsFull(g_game.getContainers()[0]) then
      if hppercent() <= settings.EnergyRingHP and (not getFinger() or getFinger():getId() ~= energyRingEquipado) then
        masterEquip(energyRingId,SlotFinger)
        delay(500)
        return
      elseif hppercent() > settings.EnergyRingHP and (not getFinger() or getFinger():getId() ~= settings.OtherRingID) then
        masterEquip(settings.OtherRingID,SlotFinger)
        delay(500)
        return
      end
    end

    
    if hppercent() <= settings.EnergyRingHP and getFinger() and getFinger():getId() ~= energyRingEquipado then
      
      masterUnequip(getFinger())
      return
    end

    if hppercent() <= settings.EnergyRingHP and not getFinger() then
      
      masterEquip(energyRingId,SlotFinger)
      delay(500)
      return
    end

    if hppercent() > settings.EnergyRingHP and getFinger() and getFinger():getId() ~= settings.OtherRingID then
      
      masterUnequip(getFinger())
      return
    end

    if hppercent() > settings.EnergyRingHP and not getFinger() then
      
      masterEquip(settings.OtherRingID,SlotFinger)
      delay(500)
      return
    end

  end))
end

--3138
if trashFeetIcon_ then
  local trashFeetIcon = addIcon("trashFeetIcon", {item={id=3138, count=1}, text="Trash"}, macro(50, function(m)
    if isIpLocked() then return end
    local startPos = pos()
    for i=-1,1 do
      for j=-1,1 do
        local tile = g_map.getTile({x=posx()+i, y=posy()+j, z=posz()})
        if tile then
          local thing = tile:getTopThing()
          if thing and thing:isItem() and (not thing:isNotMoveable()) and isSamePos(startPos, pos()) and not (i==0 and  j==0) then
                g_game.move(thing, startPos, thing:getCount())
                delay(settings.ActionDelay)
            return
          end
        end
      end
    end
  end))
end

local goldIds = 
{
[3031] = 3035,
[3035] = 3043
}


local isDropTurnLocked = false

if antipushIcon_ then
  local antiPushIcon = addIcon("antipushIcon", {item={id=3734, count=1}, text="AntPush"}, macro(50, function(m)
    if isIpLocked() then return end
    if isDropTurnLocked then return end
    isDropTurnLocked = true
    local dropDelay = 0
    local dropItems = stringToTable(settings.AntiPushItemsIDS)
    local tile = g_map.getTile(pos())
    for _, item in ipairs(dropItems) do
      local dropItem = findItem(item)
      if dropItem then
        schedule(dropDelay, function() 
          if dropItem:getCount() == 1 then
            g_game.move(dropItem, pos(), 1)
          else
            g_game.move(dropItem, pos(), 2)
          end
        end)
        dropDelay = dropDelay + settings.ActionDelay
      elseif goldIds[item] ~= nil then
        --change gold
        local nextCurrency = findItem(goldIds[item])
        if nextCurrency then 
          g_game.use(nextCurrency) 
        end
      end
    end
    schedule(dropDelay + settings.ActionDelay, function() 
      isDropTurnLocked = false
    end)
  end))
end

if ssaIcon_ then
  local ssaIcon = addIcon("ssaIcon", {item={id=settings.NeckItemID, count=1}, text="Neck"}, macro(50, function(m)
    if isIpLocked() then return end
    if hppercent() > settings.SSAHP and manapercent() > settings.SSAMP then 
      if getNeck() and getNeck():getId() == settings.NeckItemID then
        return masterUnequip(getNeck())
      end   
      return 
    end

    if getNeck() and getNeck():getId() ~=  settings.NeckItemID then
      masterEquip(settings.NeckItemID,SlotNeck)
    elseif not getNeck() then
      masterEquip(settings.NeckItemID,SlotNeck)
    end
  end))
end

if mightRingIcon_ then
  local mightRingIcon = addIcon("mightRingIcon", {item={id=settings.RingItemID, count=1}, text="Ring"}, macro(50, function(m)
    if isIpLocked() then return end
    if hppercent() > settings.MightHP and manapercent() > settings.MightMP then 
      if getFinger() and getFinger():getId() == settings.RingItemID then
        return masterUnequip(getFinger())
      end
      return
    end

    if getFinger() and getFinger():getId() ~=  settings.RingItemID then
      masterEquip(settings.RingItemID,SlotFinger)
    elseif not getFinger() then
      masterEquip(settings.RingItemID,SlotFinger)
    end
  end))
end


--Rope MAX
local isRopeMaxOn = false
if ropeMaxIcon_ then
  local ropeMaxIcon = addIcon("ropeMaxIcon", {item={id=9596, count=1}, text="Rope Max"},
    macro(200, function(m)
    isRopeMaxOn = true
    schedule(200, function() 
      if m.isOff() then
        isRopeMaxOn = false
      end
    end)
  end))
end


--Hold Push Target
if holdPushTargetIcon_ then 
  local holdPushTargetIcon = addIcon("holdPushTargetIcon", {item={id=0, count=1}, text="Hold Push Target"},           
    macro(100, function(m)
    shouldHouldPushTarget = true
    schedule(200,function() 
      if m.isOff() then
        shouldHouldPushTarget = false
      end
    end)
  end))
end


local hurDirTable = {
  [0] = {x=0 , y= -1}, --N
  [1] = {x=1 , y= 0}, --E
  [2] = {x=0 , y= 1}, --S
  [3] = {x=-1 , y= 0},  --W
  [4] = {x=1 , y= 0}, --NE
  [5] = {x=1 , y= 0}, --SE
  [6] = {x=-1 , y= 0},  --NW
  [7] = {x=-1 , y= 0},  --SW
}

--ROPEMAX
onPlayerPositionChange(function(newPos, oldPos) 
  if not isRopeMaxOn then return end

  local ropeTile = g_map.getTile(newPos)
  if ropeTile and ropeTile:getThing(0):getId() == 386 then
    local ropeItem = findItem(settings.ropeItemId)
    if ropeItem then
      g_game.useWith(ropeItem, ropeTile:getGround())
    else
      say("exani tera")
    end
  else
    if isStairs(newPos) then return end

    local pDir = player:getDirection()
    local hurUpNextPos = {x=newPos.x+hurDirTable[pDir].x, y=newPos.y+hurDirTable[pDir].y, z = posz() - 1 }
    local levitateTile = g_map.getTile(hurUpNextPos)
    local myHeadTile =  g_map.getTile({x = posx(), y = posy(), z = posz()-1})
    if levitateTile and levitateTile:isWalkable() and (myHeadTile == nil or not myHeadTile:isFullGround()) then
      say('Exani Hur "Up')
      say('Exani Hur "Up')
      say('Exani Hur "Up')
      return
    end

    local hurDownNextPos = {x=newPos.x+hurDirTable[pDir].x, y=newPos.y+hurDirTable[pDir].y, z = posz() + 1 }
    levitateTile = g_map.getTile(hurDownNextPos)
    local myFronttile = g_map.getTile({x=newPos.x+hurDirTable[pDir].x, y=newPos.y+hurDirTable[pDir].y, z = posz()})
    if levitateTile and levitateTile:isWalkable() and (myFronttile == nil or not myFronttile:isFullGround()) then
      say('Exani Hur "Down')
      say('Exani Hur "Down')
      say('Exani Hur "Down')
    end
  end
end)



local directions  = {
  "N", "S", "W", "E", "NW", "NE", "SW", "SE", 
}

local flowersHK = stringToTableString(settings.DropFlowersHK)
local hotkeys = nil
if #flowersHK ~= 8 then
  hotkeys = {
  ["N"] = "8", --n
  ["S"] = "2", -- s
  ["W"] = "4", -- w
  ["E"] = "6", -- e
  ["NW"] = "7", -- nw
  ["NE"] = "9", -- ne
  ["SW"] = "1", -- sw
  ["SE"] = "3" -- se
  }
  settings.DropFlowersHK = "8,2,4,6,7,9,1,3"
else
  hotkeys = {
    ["N"] = flowersHK[1], --n
    ["S"] = flowersHK[2], -- s
    ["W"] = flowersHK[3], -- w
    ["E"] = flowersHK[4], -- e
    ["NW"] = flowersHK[5], -- nw
    ["NE"] = flowersHK[6], -- ne
    ["SW"] = flowersHK[7], -- sw
    ["SE"] = flowersHK[8] -- se
  }
end

local dropPos = {
  ["N"] = {x= 0, y= -1}, -- n
  ["S"] = {x= 0, y= 1}, -- s
  ["W"] = {x= -1, y= 0}, -- w
  ["E"] = {x= 1, y= 0}, -- e
  ["NW"] = {x= -1, y= -1}, -- nw
  ["NE"] = {x= 1, y= -1}, -- ne
  ["SW"] = {x= -1, y= 1}, -- sw
  ["SE"] = {x= 1, y= 1}  -- se
}



local function hasFlower(tile)
  local flowerIds= stringToTable(settings.FlowerIDS)
  if tile then
    return table.find(flowerIds, tile:getTopThing():getId()) 
  else
    return false
  end
end

local function dropFlower(tile)
  local flowerIds = stringToTable(settings.FlowerIDS)
  local flowerItem = nil 
  for _,flowerId in ipairs(flowerIds) do
    flowerItem = findItem(flowerId)
    if flowerItem then
      g_game.move(flowerItem, tile:getPosition(), flowerItem:getCount())
      return
    end
  end
end

local function isStairs(pos)
  local minimapColor = g_map.getMinimapColor(pos)
  if not minimapColor then return false end
  return (minimapColor >= 210 and minimapColor <= 213)
end

local canDrop = true
local function macroBody(dirName)
  if not canDrop then return end
  local NewX = posx() + dropPos[dirName].x
  local NewY = posy() + dropPos[dirName].y
  local tile = g_map.getTile({x = NewX, y = NewY, z = posz()})

  if not tile or not tile:isWalkable() or hasFlower(tile) or isStairs(tile:getPosition()) then return end

  canDrop = false
  dropFlower(tile)
  schedule(tonumber(settings.ActionDelay), function() 
      canDrop = true
  end)
end

if settings["switchFlower"] then
  for k,dirName in ipairs(directions) do
    addIcon("dropFIcon"..k, {item={id=2981, count=1}, text=dirName, hotkey=hotkeys[dirName]}, macro(100, function(m) 
      if isIpLocked() then return end
      if isTyping() then m.setOff() return end
      isDropping = true
      macroBody(dirName)
      schedule(100, function() 
        if m.isOff() then isDropping = false end
      end) 
    end))
  end
end



--PUSHMAX ELF
local g_PushNorth = "home"
local g_PushSouth = "end"
local g_PushWest = "insert"
local g_PushEast = "pageup"

local elfHotkeys = stringToTableString(settings.ElfPushHK)

if #elfHotkeys == 4 then
  g_PushNorth = elfHotkeys[1]:lower()
  g_PushSouth = elfHotkeys[2]:lower()
  g_PushWest = elfHotkeys[3]:lower()
  g_PushEast = elfHotkeys[4]:lower()
else
  settings.ElfPushHK = "home,end,insert,pageup"
  g_TextEdits["ElfPushHK"].textEdit:setText(settings.ElfPushHK)
end

 local fixedEnemyPostions = {
   [g_PushNorth] = {
      {x = 0, y = -2}, --N 
      {x = -1, y = -2}, --NW 
      {x = 1, y = -2} --NE 
   },
   [g_PushWest] = {
       {x = -2, y = -1}, -- < WN
       {x = -2, y = 0}, --W
       {x = -2, y = 1} -- < WE
   },
   [g_PushEast] = {
       {x = 2, y = -1}, -- > EN
       {x = 2, y = 0}, --E
       {x = 2, y = 1} -- > ES
   },
   [g_PushSouth] = {
       {x = -1, y = 2}, --SW
       {x = 0, y = 2}, --S
       {x = 1, y = 2} --SE
   }
 }
 
 local fixedEnemyPushPos = {
   [g_PushNorth] = {
       {x = 0, y = -1},  -- N
       {x = -1, y = -1}, -- NW
       {x = 1, y = -1}   -- NE
   },
   [g_PushWest] = {
       {x = -1, y = 0}, -- W
       {x = -1, y = 1}, -- WS
       {x = -1, y = -1} -- WN
   },
   [g_PushEast] = {
       {x = 1, y = 0}, -- E
       {x = 1, y = 1}, -- ES
       {x = 1, y = -1} -- EN
   },
   [g_PushSouth] = {
       {x = 0, y = 1}, -- S
       {x = -1, y = 1},-- SW
       {x = 1, y = 1}  -- SE
   }
 }
 
 function targetDest(pushIndex, enemyCreaturePos, enemyDirection)
   local pushTo = {
       x = enemyCreaturePos.x + fixedEnemyPushPos[enemyDirection][pushIndex].x,
       y = enemyCreaturePos.y + fixedEnemyPushPos[enemyDirection][pushIndex].y,
       z = enemyCreaturePos.z
   }
   local tile = g_map.getTile(pushTo)
   if tile then
       return pushTo
   end
 end

local shouldSetTargetByElfPush = false
function myPush(enemyDirection)
  for pushIndex, enemyPos in ipairs(fixedEnemyPostions[enemyDirection]) do
    local enemyCreaturePos = {x = posx() + enemyPos.x, y = posy() + enemyPos.y, z = posz()}
    local enemyTile = g_map.getTile(enemyCreaturePos)
    if enemyTile then
      local enemy = enemyTile:getCreatures()[1]
      if enemy and enemy:isPlayer() then
        if shouldSetTargetByElfPush then
          setTarget(enemy)
        end
          local targetDestination = nil
          local destTile  = nil
          local isWalkable = false
          for i=1,3 do
            targetDestination = targetDest(i, enemyCreaturePos, enemyDirection)
            destTile  = g_map.getTile(targetDestination)
            if destTile and destTile:isWalkable() and destTile:isPathable() and not destTile:getCreatures()[1] then 
              isWalkable = true
              break 
            end
          end
          if not isWalkable then return end
          if (enemyTile:getTopUseThing():isPickupable() or not enemyTile:getTopUseThing():isNotMoveable()) and shouldUseFieldRune then
              useWith(tonumber(settings.FieldRuneID), enemyTile:getGround())
              g_game.move(spec, targetDestination)
          end
          if hasField(destTile) then
            useWith(tonumber(settings.DestroyFieldID), destTile:getGround())
          end

          g_game.move(enemy, targetDestination)
        
          return
      end
    end
  end
end

if setTargetByElfPush_ then
  addIcon("setTargetByElfPush", {item={id=0, count=1}, text="Set Target by Elf Push"}, macro(100, function(m)
    shouldSetTargetByElfPush = true
    schedule(100, function()
      if m.isOff() then
        shouldSetTargetByElfPush = false
      end
    end)
  end))
end


 local pushKeys = {g_PushNorth,g_PushSouth,g_PushWest,g_PushEast}

 onKeyPress(function(keys)
  if isIpLocked() then return end
  if not settings["switchElfPush"] then return end
  keys = keys:lower()
  if table.find(pushKeys, keys) and not isTyping() then
    myPush(keys)
  end 
end)


 --MOUSE TRASH
local dropIndex = 1
local lastItemCount = #stringToTable(settings.MouseTrashItemsIDS)

onKeyPress(function(keys)
  if isIpLocked() then return end
  keys = keys:lower()
  if not settings.enabled or
  keys ~= settings.MouseTrashHK:lower() or 
  #stringToTable(settings.MouseTrashItemsIDS) == 0 or
  isTyping() then return end

  local dropItemsTable = stringToTable(settings.MouseTrashItemsIDS) 
  local currentItemCount = #dropItemsTable
  if currentItemCount ~= lastItemCount then
    lastItemCount = currentItemCount
    dropIndex = 1
  end

  local dropPos = getTileUnderCursor()
  local item = findItem(dropItemsTable[dropIndex])
  
  if dropPos and item then
    g_game.move(item, dropPos:getPosition(), 1)
  end

  if dropIndex == currentItemCount then dropIndex = 1 return end
  dropIndex  = dropIndex + 1
end)
