local L = LibStub('AceLocale-3.0'):NewLocale('BattlegroundNumbers', 'enUS', true)

if not L then return end

-- options
L["GeneralSettings"] = "General Settings"
L["GeneralSettings_Desc"] = "General Addon Settings"
L["Enabled"] = "Enabled"
L["Enabled_Desc"] = "Enabled"
L["EnemyNameplates"] = "Enemy Nameplates"
L["EnemyNameplates_Color_Enabled"] = "Enable Custom Color"
L["EnemyNameplates_Color_Enabled_Desc"] = "Enables custom enemy name color"
L["EnemyNameplates_Color"] = "Enemy Nameplate Names Color"
L["EnemyNameplates_Color_Desc"] = "The color for enemy nameplate names when playing a battleground"
L["EnemyNameplates_Format"] = "Name Format"
L["EnemyNameplates_Format_Desc"] = [=[Format for nameplate name. ie.: CLASS SPEC - NUM

Available Variables:
NAME - player name (includes realm if applies)
CLASS - player class
SPEC - player spec
NUM - number (classwide)
]=]
L["AllyNameplates"] = "Ally Nameplates"
L["AllyNameplates_Color_Always"] = "Enable Custom Color Always"
L["AllyNameplates_Color_Always_Desc"] = "Enables custom ally name color always. Including world."
L["AllyNameplates_Color"] = "Ally Nameplate Names Color"
L["AllyNameplates_Color_Desc"] = "The color for ally nameplate names"
L["AllyNameplates_Color_Enabled"] = "Enable Custom Color"
L["AllyNameplates_Color_Enabled_Desc"] = "Enables custom ally name color"
L["AllyNameplates_Color_Arena"] = "Arenas"
L["AllyNameplates_Color_BG"] = "BattleGrounds"
L["AllyNameplates_Hide_HealthBar_Always"] = "Hide Health Bar Always"
L["AllyNameplates_Hide_HealthBar_Always_Desc"] = "Hide Ally nameplate health bars always. Including world."
L["AllyNameplates_Hide_HealthBar_Enabled"] = "Hide Health Bar"
L["AllyNameplates_Hide_HealthBar_Enabled_Desc"] = "Hide ally nameplate health bar"
L["AllyNameplates_Hide_HealthBar_Arena"] = "Arenas"
L["AllyNameplates_Hide_HealthBar_BG"] = "BattleGrounds"
L["FUNC_NOT_COMBAT"] = "this functionality cannot be used in combat"