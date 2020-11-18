local L = LibStub("AceLocale-3.0"):NewLocale("BattlegroundNumbers", "esES")
if not L then return end

-- options
L["GeneralSettings"] = "Opciones Generales"
L["GeneralSettings_Desc"] = "Opciones Generales del AddOn"
L["Enabled"] = "Habilitar"
L["Enabled_Desc"] = "Habilitar"
L["EnemyNameplates"] = "Nameplates Enemigos"
L["EnemyNameplates_Color_Enabled"] = "Habilitar Color Personalizado"
L["EnemyNameplates_Color_Enabled_Desc"] = "Habilitar color personalizado para enemigos"
L["EnemyNameplates_Color"] = "Color para Nombres en nameplates enemigos"
L["EnemyNameplates_Color_Desc"] = "El color para los nombres en nameplates enemigos mientras estas en un campo de batalla"
L["EnemyNameplates_Format"] = "Formato de Nombre"
L["EnemyNameplates_Format_Desc"] = [=[Formato para el nombre en nameplates. Ej.: CLASS SPEC - NUM

Available Variables:
NAME - nombre del jugador (incluye reino si es que aplica)
CLASS - clase del jugador
SPEC - especialización del jugador
NUM - numero (por clase)
]=]
L["AllyNameplates"] = "Nameplates Aliados"
L["AllyNameplates_Color_Always"] = "Habilitar Color de Aliados"
L["AllyNameplates_Color_Always_Desc"] = "Siempre habilitar color personalizado para aliados"
L["AllyNameplates_Color"] = "Colores de Nameplates Aliados"
L["AllyNameplates_Color_Desc"] = "Color para nombres en nameplates aliados"
L["AllyNameplates_Color_Enabled"] = "Habilitar Color Personalizado"
L["AllyNameplates_Color_Enabled_Desc"] = "Habilitar color personalizado para aliados"
L["AllyNameplates_Color_Arena"] = "Arenas"
L["AllyNameplates_Color_BG"] = "Campos de Batalla"
L["AllyNameplates_Hide_HealthBar_Always"] = "Siempre Ocultar Barra de vida"
L["AllyNameplates_Hide_HealthBar_Always_Desc"] = "Siempre ocultar barra de vida en nameplates aliados. Incluyendo mundo abierto."
L["AllyNameplates_Hide_HealthBar_Enabled"] = "Ocultar Barra de Vida"
L["AllyNameplates_Hide_HealthBar_Enabled_Desc"] = "Ocultar Barra de vida en nameplates aliados"
L["AllyNameplates_Hide_HealthBar_Arena"] = "Arenas"
L["AllyNameplates_Hide_HealthBar_BG"] = "Campos de Batalla"
L["FUNC_NOT_COMBAT"] = "esta funcionalidad no puede ser usada en combate"