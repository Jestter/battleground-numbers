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

local function addVerticalSpacing(order)
	local verticalSpacing = {
		type = "description",
		name = " ",
		fontSize = "large",
		width = "full",
		order = order
	}
	return verticalSpacing
end

local function addSpacing(order, multiplier)
	local spacing = {
		type = "description",
		name = " ",
		width = multiplier,	
		order = order,
	}
	return spacing
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
						width = "normal",
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
						width = "full",
						order = 5
					},
					AllyNameplates_Color_Header = {
						type = "header",
						name = L.AllyNameplates,
                        order = 6
					},
					AllyNameplates_Color_Always = {
						type = "toggle",
						name = L.AllyNameplates_Color_Always,
						desc = L.AllyNameplates_Color_Always_Desc,
						width = "1.5",
                        order = 7
					},
					AllyNameplates_Color = {
						type = "color",
						name = L.AllyNameplates_Color,
						desc = L.AllyNameplates_Color_Desc,
                        hasAlpha = true,
                        disabled = function(...) 
							return (self.db.profile.AllyNameplates_Color_Enabled["Arenas"] == false
							or self.db.profile.AllyNameplates_Color_Enabled["Arenas"] == nil)
							and (self.db.profile.AllyNameplates_Color_Enabled["BattleGrounds"] == false
							or self.db.profile.AllyNameplates_Color_Enabled["BattleGrounds"] == nil)
							and self.db.profile.AllyNameplates_Color_Always == false
						end,
                        order = 8,
                        set = function(option, ...) 
                            local R,G,B,A = ...
							setOption(option, {R,G,B,A})
						end
					},
					AllyNameplates_Color_Enabled = {
						type = "multiselect",
						name = L.AllyNameplates_Color_Enabled,
						desc = L.AllyNameplates_Color_Enabled_Desc,
						width = "full",
						hidden = function()
							return self.db.profile.AllyNameplates_Color_Always
						end,
						get = function(option, key)
							return self.db.profile.AllyNameplates_Color_Enabled[key]
						end,
						set = function(option, key, state) 
							self.db.profile.AllyNameplates_Color_Enabled[key] = state
						end,
						values = {
							Arenas = L.AllyNameplates_Color_Arena,
							BattleGrounds = L.AllyNameplates_Color_BG
						},
						order = 9
					},
					AllyNameplates_Hide_HealthBar_Always = {
						type = "toggle",
						name = L.AllyNameplates_Hide_HealthBar_Always,
						desc = L.AllyNameplates_Hide_HealthBar_Always_Desc,
						width = "full",
                        order = 10
					},
					AllyNameplates_Hide_HealthBar_Enabled = {
						type = "multiselect",
						name = L.AllyNameplates_Hide_HealthBar_Enabled,
						desc = L.AllyNameplates_Hide_HealthBar_Enabled_Desc,
						width = "full",
						hidden = function()
							return self.db.profile.AllyNameplates_Hide_HealthBar_Always
						end,
						get = function(option, key)
							return self.db.profile.AllyNameplates_Hide_HealthBar_Enabled[key]
						end,
						set = function(option, key, state) 
							self.db.profile.AllyNameplates_Hide_HealthBar_Enabled[key] = state
						end,
						values = {
							Arenas = L.AllyNameplates_Hide_HealthBar_Arena,
							BattleGrounds = L.AllyNameplates_Hide_HealthBar_BG
						},
						order = 11
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
	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

	AceConfigDialog:Open("BattlegroundNumbers")

end
