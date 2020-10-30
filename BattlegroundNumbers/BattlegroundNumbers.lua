-- some (a lot of) code came from BattlegroundEnemies AddOn, big thanks to BGE devs!


Data = {}
Data.Classes = {}

do
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


hooksecurefunc("CompactUnitFrame_UpdateName",
    function(F)
        local function capitalize(str)
            -- from http://lua-users.org/wiki/StringRecipes
            local function tchelper(first, rest)
                return first:upper()..rest:lower()
             end
             return str:gsub("(%a)([%w_']*)", tchelper)
        end

        if C_PvP.IsBattleground() and F.unit:find("nameplate") then
            local ClassCounter = {}
            local PlayerSortingTable = {}
            local MyBgFaction = GetBattlefieldArenaFaction()  -- returns the playered faction 0 for horde, 1 for alliance
            local EnemyFaction = -1
            local AllyFaction = -1
            if MyBgFaction == 0 then -- i am Horde
                EnemyFaction = 1 --Enemy is Alliance
                AllyFaction = 0
            else
                EnemyFaction = 0 --Enemy is Horde
                AllyFaction = 1
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
)
