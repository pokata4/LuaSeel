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
  for ip in string.gmatch(inputString, '(%d+%.%d+%.%d+%.%d+)') do
    table.insert(ips, ip)
  end
  return ips
end

local hasSendAuthMen = false

local function checkIP()
  modules.corelib.HTTP.get(ipUrl, function(ip, err)
    if ip == "" then return end
    modules.corelib.HTTP.get(spreadSheetLink, function(dataGet, err)
      local myIp = extractIps(ip)
      dataGet = string.sub(dataGet, 1, 1500)
      local externalIps = extractIps(dataGet)
      myIp = myIp[1] or nil
      if #externalIps == 0 or #externalIps > ipAmount or not myIp then
        G.isIpLocked = true
        return
      end
      for i = 1, ipAmount do
        if externalIps[i] == myIp then
          if not hasSendAuthMents then
            ipCheckPrintMessage("Successfully authenticated, Enjoy your gaming Pericles #9036.")
            G.
          end
        end
      end
    end)
  end)
end

