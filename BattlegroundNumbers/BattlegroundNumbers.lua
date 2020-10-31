-- some code came from BattlegroundEnemies AddOn, big thanks to BGE devs!
BINDING_HEADER_BGNUMBERS = "Battleground Nameplate Numbers"
_G["BINDING_NAME_CLICK MainFrame:LeftButton"] = "Select next enemy target"
local Data = {}
Data.Classes = {}
local MainFrame = CreateFrame("Button", "MainFrame",nil,"SecureActionButtonTemplate")

local function isCommonBG()
    return C_PvP.IsBattleground()
end

local function getEnemyList()
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
        return PlayerSortingTable
    end
    return {}
end

local name = nil

local function nextTarget(self, button, down)    
    if isCommonBG() and UnitAffectingCombat("player") == false then
        local enemies = getEnemyList()
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
			
			--if specName == "Танцующий с ветром" then specName = "Танцующая с ветром" end -- fix for russian bug, fix added on 2017.08.27
			local specID,specName,_,icon,role = GetSpecializationInfoForClassID(classID, i, 3) -- female version	
			if not Data.Classes[classTag][specName] then --there is a female version of that specName
				Data.Classes[classTag][specName] = Data.Classes[classTag][maleSpecName]
			end
		end
	end
end

local function changeNameplateName(F)
    local function capitalize(str)
        -- from http://lua-users.org/wiki/StringRecipes
        local function tchelper(first, rest)
            return first:upper()..rest:lower()
         end
         return str:gsub("(%a)([%w_']*)", tchelper)
    end
    
    if isCommonBG() and F.unit:find("nameplate") then
        local PlayerSortingTable = getEnemyList()
        local ClassCounter = {}
        

        for i = 1, #PlayerSortingTable do
            local player = PlayerSortingTable[i]
            local classTag = player.PlayerClass
            local name = player.PlayerName
            local role = player.PlayerRoleNumber
            local spec = player.PlayerSpec
            if role == 1 then
                classTag = "HEALER"
            end
            if role == 2 then
                classTag = "TANK"
            end
            if ClassCounter[classTag] == nil then
                ClassCounter[classTag] = 1
            end
            if GetUnitName(F.unit, true) == name then
                F.name:SetText(capitalize(classTag .. " " .. spec ..  " - " .. ClassCounter[classTag]))
                if UnitIsUnit(F.unit, "target") then
                    F.name:SetTextColor(1, 0.3, 0.3)
                end
            end
            ClassCounter[classTag] = ClassCounter[classTag] + 1
        end
    end
end

hooksecurefunc("CompactUnitFrame_UpdateName",changeNameplateName)
