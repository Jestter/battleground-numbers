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
L["EnemyNameplates_YTarget_Color_Enabled"] = "Eres Su Objetivo"
L["EnemyNameplates_YTarget_Color_Enabled_Desc"] = "Habilita el cambio de color cuando eres el objetivo enemigo"
L["EnemyNameplates_YTarget_Color"] = "Color Cuando Eres Su Objetivo"
L["EnemyNameplates_YTarget_Color_Desc"] = "Color a utilizar cuando eres el objetivo enemigo"
L["EnemyNameplates_Color_Desc"] = "El color para los nombres en nameplates enemigos mientras estas en un campo de batalla"
L["EnemyNameplates_Format"] = "Formato de Nombre (Campo de Batalla)"
L["EnemyNameplates_Format_Desc"] = [=[Formato para el nombre en nameplates. Ej.: CLASS SPEC - NUM

Available Variables:
NAME - nombre del jugador (incluye reino si es que aplica)
CLASS - clase del jugador
SPEC - especialización del jugador
ROLE - rol del jugador
NUM - numero (por clase)
SNUM - numero (por spec).
]=]
L["EnemyNameplates_Format_Arena"] = "Formato de Nombre (Arena)"
L["EnemyNameplates_Format_Arena_Desc"] = [=[Formato para el nombre en nameplates. Ej.: CLASS SPEC - NUM

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
L["CustomUnitSettings"] = "Personalización de Unidades (experimental)"
L["CustomUnitSettings_Desc"] = "Opciones para nameplates personalizados de unidades (experimental)"
L["CustomUnit_AddUnit"] = "Agregar Unidad"
L["CustomUnit_AddUnit_Desc"] = "Agregar unidad escribiendo el nombre exacto"
L["CustomUnit_Units"] = "Unidades"
L["CustomUnit_Units_Desc"] = "Unidades"
L["CustomUnit_Color"] = "Color de Texto en Nameplate"
L["CustomUnit_Color_Desc"] = "Color para el texto del nameplate de la unidad"
L["CustomUnit_Enemy"] = "Habilitado para enemigos"
L["CustomUnit_Enemy_Desc"] = ""
L["CustomUnit_Ally"] = "Habilitado para aliados"
L["CustomUnit_Ally_Desc"] = ""
L["CustomUnit_Remove"] = "Remover"
L["CustomUnit_Remove_Desc"] = "Remover esta unidad"