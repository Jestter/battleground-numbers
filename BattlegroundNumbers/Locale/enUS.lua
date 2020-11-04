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
L["AlliesNameplates_Color"] = "Allies Nameplate Names Color"
L["AlliesNameplates_Color_Desc"] = "The color for allies nameplate names when playing a battleground"
L["EnemyNameplates_Format"] = "Name Format"
L["EnemyNameplates_Format_Desc"] = [=[Format for nameplate name. ie.: CLASS SPEC - NUM

Available Variables:
NAME - player name (includes realm if applies)
CLASS - player class
SPEC - player spec
NUM - number (classwide)
]=]