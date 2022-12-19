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

function BattlegroundNumbers:CustomUnitOptions()
	self.cUnitOptions = {}
	local count = 0
	for k,v in pairs(self.db.profile.CustomUnits) do
		if k and v then
			self.cUnitOptions[k] = {
				type = "group",
				name = k,
				order = count,
				args = {
					CustomUnit_Color = {
						type = "color",
						name = L.CustomUnit_Color,
						desc = L.CustomUnit_Color_Desc,
						order = 0,
						width = "full",
						hasAlpha = true,
						get = function(option, key)
							if self.db.profile.CustomUnits[k] then
								local value = self.db.profile.CustomUnits[k].HColor
								return value[1] ,value[2] ,value[3] ,value[4]
							end
							return {1,0,0,1}
						end,
						set = function(option, ...)
							local R,G,B,A = ...
							self.db.profile.CustomUnits[k].HColor = {R,G,B,A}
						end
					},
					CustomUnit_Enemy = {
						type = "toggle",
						name = L.CustomUnit_Enemy,
						desc = L.CustomUnit_Enemy_Desc,
						order = 1,
						get = function(option, key)
							if self.db.profile.CustomUnits[k] then
								local value = self.db.profile.CustomUnits[k].EnabledEnemies
								return value
							end
							return false
						end,
						set = function(option, value)
							self.db.profile.CustomUnits[k].EnabledEnemies = value
						end
					},
					CustomUnit_Ally = {
						type = "toggle",
						name = L.CustomUnit_Ally,
						desc = L.CustomUnit_Ally_Desc,
						order = 2,
						get = function(option, key)
							if self.db.profile.CustomUnits[k] then
								local value = self.db.profile.CustomUnits[k].EnabledAllies
								return value
							end
							return false
						end,
						set = function(option, value)
							self.db.profile.CustomUnits[k].EnabledAllies = value
						end
					},
					CustomUnit_HideUnit = {
						type = "toggle",
						name = L.CustomUnit_HideUnit,
						desc = L.CustomUnit_HideUnit_Desc,
						order = 3,
						get = function(option, key)
							if self.db.profile.CustomUnits[k] then
								local value = self.db.profile.CustomUnits[k].HideUnit
								return value
							end
							return false
						end,
						set = function(option, value)
							self.db.profile.CustomUnits[k].HideUnit = value
						end
					},
					CustomUnit_HideHealthBar = {
						type = "toggle",
						name = L.CustomUnit_HideHealthBar,
						desc = L.CustomUnit_HideHealthBar_Desc,
						order = 4,
						get = function(option, key)
							if self.db.profile.CustomUnits[k] then
								local value = self.db.profile.CustomUnits[k].HideHealthBar
								return value
							end
							return false
						end,
						set = function(option, value)
							self.db.profile.CustomUnits[k].HideHealthBar = value
						end
					},
					CustomUnit_Remove = {
						type = "execute",
						name = L.CustomUnit_Remove,
						desc = L.CustomUnit_Remove_Desc,
						order = 5,
						func = function()
							self.db.profile.CustomUnits[k] = nil
							self:LoadOptions()
							AceConfigRegistry:NotifyChange("BattlegroundNumbers")
						end,
					}
				}
			}
			count = count + 1
		end
	end
	return self.cUnitOptions
end

function BattlegroundNumbers:AddCustomUnit(key)
	self.db.profile.CustomUnits[key] = {
		HColor = {1,0,0,1},
		EnabledAllies = false,
		EnabledEnemies = false,
		HideHealthBar = false,
		HideUnit = false
	}
	self:LoadOptions()
	AceConfigRegistry:NotifyChange("BattlegroundNumbers")
end

function BattlegroundNumbers:LoadOptions()
	self.options.args = {
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
					width = "full",
					order = 1
				},
				TestBG = {
					type = "execute",
					name = L.TestBG,
					desc = L.TestBG_Desc,
					order = 2,
					func = function() 
						if self.test and self.test.bg then
							self.test = {bg = false, arena = false}
						else
							self.test = {bg = true, arena = false}
						end
					end
				},
				TestArena = {
					type = "execute",
					name = L.TestArena,
					desc = L.TestArena_Desc,
					order = 3,
					func = function() 
						if self.test and self.test.arena then
							self.test = {bg = false, arena = false}
						else
							self.test = {bg = false, arena = true}
						end
					end
				},
				EnemyNameplates_Color_Header = {
					type = "header",
					name = L.EnemyNameplates,
					order = 4
				},
				EnemyNameplates_Color_Enabled = {
					type = "toggle",
					name = L.EnemyNameplates_Color_Enabled,
					desc = L.EnemyNameplates_Color_Enabled_Desc,
					width = "normal",
					order = 5
				},
				EnemyNameplates_Color = {
					type = "color",
					name = L.EnemyNameplates_Color,
					desc = L.EnemyNameplates_Color_Desc,
					hasAlpha = true,
					disabled = function(...) 
						return self.db.profile.EnemyNameplates_Color_Enabled == false
					end,
					order = 6,
					set = function(option, ...) 
						local R,G,B,A = ...
						setOption(option, {R,G,B,A})
					end
				},
				EnemyNameplates_YTarget_Color_Enabled = {
					type = "toggle",
					name = L.EnemyNameplates_YTarget_Color_Enabled,
					desc = L.EnemyNameplates_YTarget_Color_Enabled_Desc,
					width = "normal",
					order = 7
				},
				EnemyNameplates_YTarget_Color = {
					type = "color",
					name = L.EnemyNameplates_YTarget_Color,
					desc = L.EnemyNameplates_YTarget_Color_Desc,
					hasAlpha = true,
					disabled = function(...) 
						return self.db.profile.EnemyNameplates_YTarget_Color_Enabled == false
					end,
					order = 8,
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
					order = 9
				},
				EnemyNameplates_Format_Arena = {
					type = "input",
					name = L.EnemyNameplates_Format_Arena,
					desc = L.EnemyNameplates_Format_Arena_Desc,
					width = "full",
					order = 10
				},
				AllyNameplates_Color_Header = {
					type = "header",
					name = L.AllyNameplates,
					order = 11
				},
				AllyNameplates_Color_Always = {
					type = "toggle",
					name = L.AllyNameplates_Color_Always,
					desc = L.AllyNameplates_Color_Always_Desc,
					width = "1.5",
					order = 12
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
					order = 13,
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
					order = 14
				},
				AllyNameplates_Hide_HealthBar_Always = {
					type = "toggle",
					name = L.AllyNameplates_Hide_HealthBar_Always,
					desc = L.AllyNameplates_Hide_HealthBar_Always_Desc,
					width = "full",
					order = 15
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
					order = 16
				},
			}
		},
		CustomUnits = {
			type = "group",
			name = L.CustomUnitSettings,
			desc = L.CustomUnitSettings_Desc,
			childGroups = "tab",
			order = 1,
			args = {
				AddUnit = {
					type = "input",
					name = L.CustomUnit_AddUnit,
					desc = L.CustomUnit_AddUnit_Desc,
					width = "full",
					get = function(option)
						return ""
					end,
					set = function(option,value)
						self:AddCustomUnit(value)
					end,
					order = 0
				},
				Units = {
					type = "group",
					name = L.CustomUnit_Units,
					desc = L.CustomUnit_Units_Desc,
					childGroups = "select",
					order = 100,
					args = self:CustomUnitOptions()
				}
			}
		}
	}
end

function BattlegroundNumbers:CreateOptions()
	self.options = {
		type = "group",
		name = "BattlegroundNumbers " .. GetAddOnMetadata(addonName, "Version"),
		childGroups = "tree",
		get = getOption,
		set = setOption,
		args = {}
	}
	self:LoadOptions()
end

function BattlegroundNumbers:SetupOptions()
	self:CreateOptions()
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
