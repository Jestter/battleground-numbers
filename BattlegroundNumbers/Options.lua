local addonName, Data = ...
local GetAddOnMetadata = GetAddOnMetadata

local L = LibStub("AceLocale-3.0"):GetLocale("BattlegroundNumbers")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local function Optionslocation()
	local location = BattlegroundNumbers.db.profile
	return location
end

local function getOption(option)
	local location = Optionslocation()
	local value = location[option[#option]]
	if type(value) == "table" then
		return unpack(value)
	else
		return value
	end
end

local function setOption(option, value)
	local location = Optionslocation()
	location[option[#option]] = value
end

function BattlegroundNumbers:SetupOptions()
	self.options = {
		type = "group",
		name = "BattlegroundNumbers " .. GetAddOnMetadata(addonName, "Version"),
		childGroups = "tree",
		get = getOption,
		set = setOption,
		args = {
			GeneralSettings = {
				type = "group",
				name = L.GeneralSettings,
				desc = L.GeneralSettings_Desc,
				order = 0,
				args = {
					Enabled = {
						type = "toggle",
						name = L.Enabled,
						desc = L.Enabled_Desc,
						order = 1
                    },
                    EnemyNameplates_Color_Header = {
						type = "header",
						name = L.EnemyNameplates,
                        order = 2
					},
                    EnemyNameplates_Color_Enabled = {
						type = "toggle",
						name = L.EnemyNameplates_Color_Enabled,
						desc = L.EnemyNameplates_Color_Enabled_Desc,
                        order = 3
					},
					EnemyNameplates_Color = {
						type = "color",
						name = L.EnemyNameplates_Color,
						desc = L.EnemyNameplates_Color_Desc,
                        hasAlpha = true,
                        disabled = function(...) 
                            return self.db.profile.EnemyNameplates_Color_Enabled == false
						end,
                        order = 4,
                        set = function(option, ...) 
                            local R,G,B,A = ...
							setOption(option, {R,G,B,A})
						end
                    },
                    EnemyNameplates_Format = {
						type = "input",
						name = L.EnemyNameplates_Format,
						desc = L.EnemyNameplates_Format_Desc,
						order = 5
                    },
				}
			}
		}
	}
	AceConfigRegistry:RegisterOptionsTable("BattlegroundNumbers", self.options)
		
	AceConfigDialog:SetDefaultSize("BattlegroundNumbers", 709, 532)
	
	--profiles
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profiles.order = -1
	self.options.args.profiles.disabled = InCombatLockdown
	
	AceConfigDialog:AddToBlizOptions("BattlegroundNumbers", "BattlegroundNumbers")
end

SLASH_BattlegroundNumbers1, SLASH_BattlegroundNumbers2 = "/BattlegroundNumbers", "/bgn"
SlashCmdList["BattlegroundNumbers"] = function(msg)
	AceConfigDialog:Open("BattlegroundNumbers")
end
