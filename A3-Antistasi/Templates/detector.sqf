/*
      This file handles the detection of mods.
      Best practice is to detect the presence of a CfgPatches entry, but there are alternatives.
      To add a new mod, give it a hadMod variable with the rest, then add an if (isClass) entry like the FFAA one. (You could even copy/paste the FFAA one and replace its calls with the ones you need.)
*/
//Var initialisation
private _filename = "detector.sqf";
hasRHS = false;
activeAFRF = false;
activeUSAF = false;
activeGREF = false;
hasFFAA = false;
hasIFA = false;
has3CB = false;
hasIvory = false;

//Actual Detection
//IFA Detection
//Deactivated for now, as IFA is having some IP problems (08.05.2020 european format)
if isClass (configFile >> "CfgPatches" >> "LIB_Core") then
{
    //hasIFA = true;
    //[2, "IFA Detected", _fileName] call A3A_fnc_log;
    [1, "IFA detected, but it is no longer supported, please remove this mod", _fileName] call A3A_fnc_log;
    ["modUnautorized",false,1,false,false] call BIS_fnc_endMission;
};

//RHS Detection
if (isClass (configFile >> "CfgFactionClasses" >> "rhs_faction_vdv") && isClass (configFile >> "CfgFactionClasses" >> "rhs_faction_usarmy") && isClass (configFile >> "CfgFactionClasses" >> "rhsgref_faction_tla")) then {
  activeAFRF = true;//Obsolete, please kill
  activeUSAF = true;//Obsolete, please kill
  activeGREF = true;//Obsolete, please kill. WHY IS THIS USED FUCKING EVERYWHERE?
  hasRHS = true;
  diag_log format ["%1: [Antistasi] | INFO | initVar | RHS Pack Detected.",servertime];
};

//3CB Detection
if (hasRHS && isClass (configfile >> "CfgPatches" >> "UK3CB_BAF_Weapons")) then {has3CB = true; diag_log format ["%1: [Antistasi] | INFO | initVar | 3CB Detected.",servertime];};

//FFAA Detection
if (isClass (configfile >> "CfgPatches" >> "ffaa_armas")) then {hasFFAA = true; diag_log format ["%1: [Antistasi] | INFO | initVar | FFAA Detected.",servertime];};

//Ivory Car Pack Detection
if (isClass (configfile >> "CfgPatches" >> "Ivory_Data")) then {hasIvory = true; diag_log format ["%1: [Antistasi] | INFO | initVar | Ivory Cars Detected.",servertime];};
