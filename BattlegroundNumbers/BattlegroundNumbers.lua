-- some code came from BattlegroundEnemies AddOn, big thanks to BGE devs!
BINDING_HEADER_BGNUMBERS = "Battleground Nameplate Numbers"
_G["BINDING_NAME_CLICK MainFrame:LeftButton"] = "Select Next Enemy Target"
local Data = {}
Data.Classes = {}
local BattlegroundNumbers = CreateFrame("Frame", "BattlegroundNumbers")
BattlegroundNumbers:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
BattlegroundNumbers:Hide()
BattlegroundNumbers:RegisterEvent("ADDON_LOADED")
BattlegroundNumbers:RegisterEvent("PLAYER_LOGIN")
BattlegroundNumbers:RegisterEvent("PLAYER_ENTERING_WORLD")
BattlegroundNumbers:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
BattlegroundNumbers:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
local MainFrame = CreateFrame("Button", "MainFrame",nil,"SecureActionButtonTemplate")

local function isCommonBG()
    return C_PvP.IsBattleground()
end

local function isArena()
    return C_PvP.IsArena()
end

local function addonEnabled()
    local inInstance, instanceType = IsInInstance()
    if BattlegroundNumbers.db == nil or (inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == nil)) then
        return false
    end
    return BattlegroundNumbers.db.profile.Enabled
end

local dummyPlayer = {
    name = "Dummy",
    role = "HEALER",
    spec = "HOLY",
    classTag = "PRIEST",
    number = "2",
    specNumber = "1"
}
local EnemyList = {}
local EnemyMap = {}

local function getUpdatedEnemyList()
    if isCommonBG() then
        local PlayerSortingTable = {}
        local MyBgFaction = GetBattlefieldArenaFaction()  -- returns the playered faction 0 for horde, 1 for alliance
        local EnemyFaction = -1
        if MyBgFaction == 0 then -- i am Horde
            EnemyFaction = 1 --Enemy is Alliance
        else
            EnemyFaction = 0 --Enemy is Horde
        end
        local numScores = GetNumBattlefieldScores()
        for i = 1, numScores do
            local name,_,_,_,_,faction,race, _, classTag,_,_,_,_,_,_,specName = GetBattlefieldScore(i)
            --name = name-realm, faction = 0 or 1, race = localized race e.g. "Mensch",classTag = e.g. "PALADIN", spec = localized specname e.g. "holy"
            --locale dependent are: race, specName
            
            if faction and name and race and classTag and specName then
                if faction == EnemyFaction then
                    table.insert(PlayerSortingTable, {
                        PlayerName = name, 
                        PlayerClass = classTag,
                        PlayerSpec = specName,
                        PlayerRoleNumber = Data.Classes[classTag][specName].roleNumber,
                    })
                end
            end
        end

        local BlizzardsSortOrder = {} 
        for i = 1, #CLASS_SORT_ORDER do -- Constants.lua
            BlizzardsSortOrder[CLASS_SORT_ORDER[i]] = i --key = ENGLISH CLASS NAME, value = number
        end

        local function PlayerSortingByRoleClassName(playerA, playerB)-- a and b are playerButtons
            if playerA.PlayerRoleNumber == playerB.PlayerRoleNumber then
                if BlizzardsSortOrder[ playerA.PlayerClass ] == BlizzardsSortOrder[ playerB.PlayerClass ] then
                    if playerA.PlayerName < playerB.PlayerName then return true end
                elseif BlizzardsSortOrder[ playerA.PlayerClass ] < BlizzardsSortOrder[ playerB.PlayerClass ] then return true end
            elseif playerA.PlayerRoleNumber < playerB.PlayerRoleNumber then return true end
        end

        table.sort(PlayerSortingTable, PlayerSortingByRoleClassName)

        local ClassCounter = {}
        local SpecCounter = {}
        -- mapping order of classes and stuff
        for i = 1, #PlayerSortingTable do
            local player = PlayerSortingTable[i]
            local classTag = player.PlayerClass
            local name = player.PlayerName
            local role = player.PlayerRoleNumber
            local spec = player.PlayerSpec
            local classspec = classTag .. spec
            local roleStr = ""
            if role == 1 then
                roleStr = "HEALER"
            end
            if role == 2 then
                roleStr = "TANK"
            end
            if role == 3 then
                roleStr = "DPS"
            end
            if ClassCounter[classTag] == nil then
                ClassCounter[classTag] = 1
            end
            if SpecCounter[classspec] == nil then
                SpecCounter[classspec] = 1
            end
            EnemyMap[name] = {
                name = name,
                role = roleStr,
                spec = spec,
                classTag = classTag,
                number = ClassCounter[classTag],
                specNumber = SpecCounter[classspec]
            }
            ClassCounter[classTag] = ClassCounter[classTag] + 1
            SpecCounter[classspec] = SpecCounter[classspec] + 1
        end

        return PlayerSortingTable
    end
    return {}
end

local name = nil

local function nextTarget(self, button, down)
    if addonEnabled() then
        if isCommonBG() and UnitAffectingCombat("player") == false then
            local enemies = EnemyList
            if #enemies > 0 then
                local currName = GetUnitName("target", true)
                if currName == nil then 
                    currName = name 
                end
                local found = false
                for i = 1, #enemies do
                    local player = enemies[i]
                    if found then
                        name = player.PlayerName
                        break;
                    end
                    if player.PlayerName == currName then
                        found = true
                    end
                    if i == #enemies then
                        name = enemies[1].PlayerName
                    end
                end
                MainFrame:SetAttribute(
                    'macrotext1',
                    '/cleartarget\n'..
                    "/targetexact " .. name
                )
            end
        else 
            if isCommonBG() and UnitAffectingCombat("player") then
                print("|cffFF0000BattleGroundNumbers|r - this functionality cannot be used in combat")
            end
        end
    end
end

local function getArenaNum(unit)
    for i=1,5 do
        if UnitIsUnit(unit,"arena"..i) then
            return i
        end
    end
    return 0
end

do
    MainFrame:SetScript("OnMouseDown", nextTarget)
    MainFrame:RegisterForClicks("AnyDown")
    MainFrame:SetAttribute('type1','macro')
	local roleNameToRoleNumber = {
		["DAMAGER"] = 3,
		["HEALER"] = 1,
		["TANK"] = 2
    }
	
	for classID = 1, MAX_CLASSES do --example classes[EnglishClass][SpecName].
		local _, classTag = GetClassInfo(classID)
		Data.Classes[classTag] = {}
		for i = 1, GetNumSpecializationsForClassID(classID) do
			
			local specID,maleSpecName,_,icon,role = GetSpecializationInfoForClassID(classID, i, 2) -- male version
			Data.Classes[classTag][maleSpecName] = {roleNumber = roleNameToRoleNumber[role], roleID = role, specID = specID,}
			
			-- BGE: if specName == "Танцующий с ветром" then specName = "Танцующая с ветром" end -- fix for russian bug, fix added on 2017.08.27
			local specID,specName,_,icon,role = GetSpecializationInfoForClassID(classID, i, 3) -- female version	
			if not Data.Classes[classTag][specName] then --there is a female version of that specName
				Data.Classes[classTag][specName] = Data.Classes[classTag][maleSpecName]
			end
		end
	end
end

local function capitalize(str)
    -- from http://lua-users.org/wiki/StringRecipes
    local function tchelper(first, rest)
        return first:upper()..rest:lower()
     end
     return str:gsub("(%a)([%w_']*)", tchelper)
end

local function changeNameplateName(F)
    if addonEnabled() and F.unit:find("nameplate") then
        local unitName = GetUnitName(F.unit, true)

        if BattlegroundNumbers.test.bg then
            local nameStr = BattlegroundNumbers.db.profile.EnemyNameplates_Format
            if nameStr ~= nil and nameStr ~= "" then
                local name = GetUnitName(F.unit)
                nameStr = string.gsub(nameStr, "NAME", name)
                nameStr = string.gsub(nameStr, "CLASS", dummyPlayer.classTag)
                nameStr = string.gsub(nameStr, "SPEC", dummyPlayer.spec)
                nameStr = string.gsub(nameStr, "SNUM", dummyPlayer.specNumber)
                nameStr = string.gsub(nameStr, "NUM", dummyPlayer.number)
                nameStr = string.gsub(nameStr, "ROLE", dummyPlayer.role)
                F.name:SetText(capitalize(nameStr))
            end

            local enableCustomEnemyColor = BattlegroundNumbers.db.profile.EnemyNameplates_Color_Enabled
            if enableCustomEnemyColor then
                local color = BattlegroundNumbers.db.profile.EnemyNameplates_Color
                F.name:SetTextColor(color[1],color[2],color[3],color[4])
            end
        elseif BattlegroundNumbers.test.arena then
            local nameStr = BattlegroundNumbers.db.profile.EnemyNameplates_Format_Arena
            if nameStr ~= nil and nameStr ~= "" then
                local name = GetUnitName(F.unit)
                nameStr = string.gsub(nameStr, "NAME", name)
                nameStr = string.gsub(nameStr, "CLASS", dummyPlayer.classTag)
                nameStr = string.gsub(nameStr, "SPEC", dummyPlayer.spec)
                nameStr = string.gsub(nameStr, "NUM", dummyPlayer.number)
                F.name:SetText(capitalize(nameStr))
            end

            local enableCustomEnemyColor = BattlegroundNumbers.db.profile.EnemyNameplates_Color_Enabled
            if enableCustomEnemyColor then
                local color = BattlegroundNumbers.db.profile.EnemyNameplates_Color
                F.name:SetTextColor(color[1],color[2],color[3],color[4])
            end
        else
            local custom = BattlegroundNumbers.db.profile.CustomUnits[unitName]
            if custom then
                if (custom.EnabledAllies and (UnitIsFriend("player",F.unit) or UnitCanAssist("player",F.unit))) or (custom.EnabledEnemies and (UnitIsEnemy("player",F.unit) or UnitCanAttack("player",F.unit))) then
                    if custom.HideUnit then
                        --F:GetParent():Hide()
                        --F.healthBar:Hide()
                        F.name:Hide()
                        for i=1, select("#", F:GetChildren()) do
                            local ChildFrame = select(i, F:GetChildren())
                            ChildFrame:Hide()
                        end
                    elseif custom.HideHealthBar then
                        F.healthBar:Hide()
                    end
                end
            end

            if isCommonBG() then
                local player = EnemyMap[unitName]
                if player then
                    local nameStr = BattlegroundNumbers.db.profile.EnemyNameplates_Format
                    if nameStr ~= nil and nameStr ~= "" then
                        nameStr = string.gsub(nameStr, "NAME", player.name)
                        nameStr = string.gsub(nameStr, "CLASS", player.classTag)
                        nameStr = string.gsub(nameStr, "SPEC", player.spec)
                        nameStr = string.gsub(nameStr, "SNUM", player.specNumber)
                        nameStr = string.gsub(nameStr, "NUM", player.number)
                        nameStr = string.gsub(nameStr, "ROLE", player.role)
                        F.name:SetText(capitalize(nameStr))
                    end
    
                    local enableCustomEnemyColor = BattlegroundNumbers.db.profile.EnemyNameplates_Color_Enabled
                    if enableCustomEnemyColor then
                        local color = BattlegroundNumbers.db.profile.EnemyNameplates_Color
                        F.name:SetTextColor(color[1],color[2],color[3],color[4])
                    end
                end
            end
    
            if isArena() then
                if UnitIsPlayer(F.unit) and UnitCanAttack("player",F.unit) then
                    local nameStr = BattlegroundNumbers.db.profile.EnemyNameplates_Format_Arena
                    if nameStr ~= nil and nameStr ~= "" then
                        local arenaNum = getArenaNum(F.unit)
                        if arenaNum > 0 then 
                            local specId = GetArenaOpponentSpec(arenaNum)
                            if specId and GetSpecializationRoleByID(specId) then 
                                local name = GetUnitName(F.unit)
                                local _, spec, _, _, _, class = GetSpecializationInfoByID(specId)
                                nameStr = string.gsub(nameStr, "NAME", name)
                                nameStr = string.gsub(nameStr, "CLASS", class)
                                nameStr = string.gsub(nameStr, "SPEC", spec)
                                nameStr = string.gsub(nameStr, "NUM", arenaNum)
                                F.name:SetText(capitalize(nameStr))
                            end
                        end
                    end
    
                    local enableCustomEnemyColor = BattlegroundNumbers.db.profile.EnemyNameplates_Color_Enabled
                    if enableCustomEnemyColor then
                        local color = BattlegroundNumbers.db.profile.EnemyNameplates_Color
                        F.name:SetTextColor(color[1],color[2],color[3],color[4])
                    end
                end
            end
    
            -- Allies Displays
            if UnitIsPlayer(F.unit) and UnitIsFriend("player",F.unit) then
                local displayHBAlways = BattlegroundNumbers.db.profile.AllyNameplates_Hide_HealthBar_Always
                local displayHBArena = BattlegroundNumbers.db.profile.AllyNameplates_Hide_HealthBar_Enabled["Arena"]
                local displayHBBG = BattlegroundNumbers.db.profile.AllyNameplates_Hide_HealthBar_Enabled["BattleGrounds"]
                if (displayHBAlways or 
                    (displayHBArena and isArena()) or 
                    (displayHBBG and isCommonBG())) and 
                    UnitCanAssist("player",F.unit) then
                    
                    if not UnitIsUnit("target",F.unit) then
                        F.healthBar:Hide()
                    end
                end
        
        
                local displayColorAlways = BattlegroundNumbers.db.profile.AllyNameplates_Color_Always
                local displayColorArena = BattlegroundNumbers.db.profile.AllyNameplates_Color_Enabled["Arena"]
                local displayColorBG = BattlegroundNumbers.db.profile.AllyNameplates_Color_Enabled["BattleGrounds"]
                if (displayColorAlways or 
                    (displayColorArena and isArena()) or 
                    (displayColorBG and isCommonBG())) then
        
                    local color = BattlegroundNumbers.db.profile.AllyNameplates_Color
                    F.name:SetTextColor(color[1],color[2],color[3],color[4])
                end
            end
    
            -- Enemies Displays
            -- colorize enemy targeting you
            if UnitCanAttack("player",F.unit) then
                local yTargetEnabled  = BattlegroundNumbers.db.profile.EnemyNameplates_YTarget_Color_Enabled
                if UnitIsUnit("player", F.unit .. "target") and yTargetEnabled then
                    local color  = BattlegroundNumbers.db.profile.EnemyNameplates_YTarget_Color
                    F.name:SetTextColor(color[1],color[2],color[3],color[4])
                end
            end
        end
    end
end

local function updateNameColor(F)
    if addonEnabled() and F.unit:find("nameplate") then
        local unitName = GetUnitName(F.displayedUnit, true)

        -- Allies Displays
        
        local custom = BattlegroundNumbers.db.profile.CustomUnits[unitName]
        if custom and custom.EnabledAllies and (UnitIsFriend("player",F.unit) or UnitCanAssist("player",F.unit)) then
            local color = custom.HColor
            -- F.healthBar:SetStatusBarColor(color[1],color[2],color[3],color[4])
            F.name:SetTextColor(color[1],color[2],color[3],color[4])
        end

        -- Enemies Displays

        if custom and custom.EnabledEnemies and (UnitIsEnemy("player",F.unit) or UnitCanAttack("player",F.unit)) then
            local color = custom.HColor
            -- F.healthBar:SetStatusBarColor(color[1],color[2],color[3],color[4])
            F.name:SetTextColor(color[1],color[2],color[3],color[4])
        end
    end
end

do
    local defaultSettings = {
        profile = {
            Enabled = true,
            EnemyNameplates_Color_Enabled = false,
            EnemyNameplates_Color = {1, 0, 0, 1},
            EnemyNameplates_YTarget_Color_Enabled = false,
            EnemyNameplates_YTarget_Color = {1,0,0,1},
            EnemyNameplates_Name = "",
            AllyNameplates_Color_Always = false,
            AllyNameplates_Color = {0, 1, 0, 1},
            AllyNameplates_Color_Enabled = {},
            AllyNameplates_Hide_HealthBar_Always = false,
            AllyNameplates_Hide_HealthBar_Enabled = {},
            CustomUnits = {}
        }
    }
    function BattlegroundNumbers:ADDON_LOADED(arg)
        if arg == "BattlegroundNumbers" then
            self.test = {bg = false, arena = false}
            print("|cff03C6FCBattlegroundNumbers|r - AddOn loaded successfully. Use |cff00FF00/bgn|r for options.");
        end
    end
    function BattlegroundNumbers:PLAYER_LOGIN()
        
		self.db = LibStub("AceDB-3.0"):New("BattlegroundNumbersDB", defaultSettings, true)

		self:SetupOptions()
		
		self:UnregisterEvent("PLAYER_LOGIN")
    end
    function BattlegroundNumbers:UPDATE_BATTLEFIELD_SCORE()
        if isCommonBG() then
            EnemyList = getUpdatedEnemyList()
        end
    end
    function BattlegroundNumbers:PLAYER_ENTERING_BATTLEGROUND()
        EnemyList = {}
    end
    function BattlegroundNumbers:PLAYER_ENTERING_WORLD()
        local instanceType = select(2, IsInInstance())
        if instanceType == "pvp" or instanceType == "arena" then
            self.test = {bg = false, arena = false}
        end
    end
end

hooksecurefunc("CompactUnitFrame_OnUpdate",changeNameplateName)
hooksecurefunc("CompactUnitFrame_UpdateName",updateNameColor)
