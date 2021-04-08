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
L["EnemyNameplates_YTarget_Color_Enabled"] = "You're Their Target"
L["EnemyNameplates_YTarget_Color_Enabled_Desc"] = "Enable change for color when enmey is targeting you"
L["EnemyNameplates_YTarget_Color"] = "Color When You're Their Target"
L["EnemyNameplates_YTarget_Color_Desc"] = "Color when the enemy is targeting you"
L["EnemyNameplates_Color_Desc"] = "The color for enemy nameplate names when playing a battleground"
L["EnemyNameplates_Format"] = "Name Format (Battlegrounds)"
L["EnemyNameplates_Format_Desc"] = [=[Format for nameplate name. ie.: CLASS SPEC - NUM

Available Variables:
NAME - player name (includes realm if applies)
CLASS - player class
SPEC - player spec
ROLE - player role
NUM - number (class-wide).
SNUM - number (spec-wide).
]=]
L["EnemyNameplates_Format_Arena"] = "Name Format (Arena)"
L["EnemyNameplates_Format_Arena_Desc"] = [=[Format for nameplate name. ie.: CLASS SPEC - NUM

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
L["CustomUnitSettings"] = "Custom Units (experimental)"
L["CustomUnitSettings_Desc"] = "Settings for custom unit nameplates (experimental)"
L["CustomUnit_AddUnit"] = "Add Unit"
L["CustomUnit_AddUnit_Desc"] = "Add custom unit exact name here"
L["CustomUnit_Units"] = "Units"
L["CustomUnit_Units_Desc"] = "Units"
L["CustomUnit_Color"] = "Nameplate Text Color"
L["CustomUnit_Color_Desc"] = "Custom Unit nameplate color"
L["CustomUnit_Enemy"] = "Enabled for Enemies"
L["CustomUnit_Enemy_Desc"] = ""
L["CustomUnit_Ally"] = "Enabled for Allies"
L["CustomUnit_Ally_Desc"] = ""
L["CustomUnit_Remove"] = "Remove"
L["CustomUnit_Remove_Desc"] = "Remove this unit"
L["TestBG"]="Test BG"
L["TestArena"]="Test arena"
L["TestBG_Desc"]="Enable all nameplates for better testing"
L["TestArena_Desc"]="Enable all nameplates for better testing"