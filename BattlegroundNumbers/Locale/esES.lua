local L = LibStub("AceLocale-3.0"):NewLocale("BattlegroundNumbers", "esES")
if not L then return end

-- options
L["GeneralSettings"] = "Opciones Generales"
L["GeneralSettings_Desc"] = "Opciones Generales del AddOn"
L["Enabled"] = "Habilitar"
L["Enabled_Desc"] = "Habilitar"
L["EnemyNameplates"] = "Nameplates Enemigos"
L["EnemyNameplates_Color_Enabled"] = "Habilitar Color Para Enemigos"
L["EnemyNameplates_Color_Enabled_Desc"] = "Habilitar Color Para Enemigos"
L["EnemyNameplates_Color"] = "Color de Nombres en Nameplates Enemigos"
L["EnemyNameplates_Color_Desc"] = "El color para los nombres en nameplates enemigos mientras estas en un campo de batalla"
L["AlliesNameplates_Color"] = "Color de Nombres en Nameplates Aliados"
L["AlliesNameplates_Color_Desc"] = "El color para los nombres en nameplates aliados mientras estas en un campo de batalla"
L["EnemyNameplates_Format"] = "Formato de Nombre"
L["EnemyNameplates_Format_Desc"] = [=[Formato para el nombre en nameplates. Ej.: CLASS SPEC - NUM

Available Variables:
NAME - nombre del jugador (incluye reino si es que aplica)
CLASS - clase del jugador
SPEC - especialización del jugador
NUM - numero (por clase)
]=]