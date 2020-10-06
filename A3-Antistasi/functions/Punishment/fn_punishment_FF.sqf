/*
Function:
    A3A_fnc_punishment_FF

Description:
    Checks if incident reported is indeed a rebel Friendly Fire event.
    Refer to A3A_fnc_punishment.sqf for actual punishment logic.
    NOTE: When called from an Hit type of EH, use Example 2 in order to detect collisions.

Scope:
    <SERVER> Execute on server only.

Environment:
    <UNSCHEDULED> This function is thread safe. However, quick execution is optimal.

Parameters:
    <OBJECT> Player that is being verified for FF. | <ARRAY<OBJECT,OBJECT>> Suspected instigator and source/killer returned from EH. The unit that caused the damage is collisions is the source/killer.
    <NUMBER> The amount of time to add to the players total sentence time.
    <NUMBER> Raise the player's total offence level by this percentage. (100% total = Ocean Gulag).
    <OBJECT> The victim of the player's FF. [DEFAULT=objNull]
    <STRING> Custom message to be displayed to FFer [DEFAULT=""]

Returns:
    <STRING> Either a exemption type or "PROSECUTED".

Examples <OBJECT>:
    [_instigator, 60, 0.4, _unit] remoteExec ["A3A_fnc_punishment_FF",2,false];   // How it should be called from another object.
    // Unit Tests:
    [player, 0, 0, objNull] remoteExec ["A3A_fnc_punishment_release",2];          // Test self with no victim
    [player, 0, 0, cursorObject] remoteExec ["A3A_fnc_punishment_release",2];     // Test self with victim
    [getPlayerUID player,"forgive"] remoteExec ["A3A_fnc_punishment_release",2];  // Self forgive all sins

Examples <ARRAY<OBJECT,OBJECT>>:
    [[_instigator,_source], 60, 0.4, _unit] remoteExec ["A3A_fnc_punishment_FF",2,false]; // How it should be called from an EH.

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_instigator",objNull, [objNull,[]], [] ],
    ["_timeAdded",0, [0]],
    ["_offenceAdded",0, [0]],
    ["_victim",objNull, [objNull]],
    ["_customMessage","", [""], [] ]
];
private _filename = "fn_punishment_FF.sqf";
///////////Checks if is Collision///////////
private _isCollision = false;
if (_instigator isEqualType []) then {
    _isCollision = !(((_instigator#0) isEqualType objNull) && {isPlayer (_instigator#0)});
    _instigator = _instigator select _isCollision;  // First one in EH will be unit by default, if its a collision the eh returns the instigator in "source" or "killer"
};
if (!(_instigator isEqualType objNull)) exitWith {"NOT OBJECT"};
private _vehicle = vehicle _instigator;
private _vehicleType = typeOf _vehicle;

//////////////////Cool-down/////////////////
if (_instigator getVariable ["A3A_FFPunish_CD ", 0] > servertime) exitWith {"PUNISHMENT COOL-DOWN ACTIVE"};
_instigator setVariable ["A3A_FFPunish_CD ", servertime + 1, false];  // Will only ever be evaluated from one machine.

/////////////////Definitions////////////////
private _victimStats = ["damaged systemPunished ",format ["damaged %1 ", name _victim]] select (_victim isKindOf "Man");
_victimStats = ["[",["AI",getPlayerUID _victim] select (isPlayer _victim),"]"] joinString "";
private _notifyVictim = {
    if (isPlayer _victim) then {["FF Notification", format["%1 hurt you!",name _instigator]] remoteExec ["A3A_fnc_customHint", _victim, false];};
};
private _notifyInstigator = {
    params ["_exempMessage"];
    private _comradeStats = ["",["Injured comrade: ",name _victim,""] joinString ""] select (_victim isKindOf "Man");
    ["FF Warning", [_exempMessage,_comradeStats,_customMessage] joinString "<br/>"] remoteExec ["A3A_fnc_customHint", _instigator, false];
};
private _logPvPHurt = {
    if (!(_victim isKindOf "Man")) exitWith {};
    private _killStats = format ["PVPHURT | Rebel %1 [%2]%3", name _instigator, getPlayerUID _instigator, _victimStats];
    [2,_killStats,_filename,true] call A3A_fnc_log;
};
private _logPvPAttack = {
    if (!(_victim isKindOf "Man")) exitWith {};
    private _killStats = format ["PVPATTACK | PvP %1 [%2]%3", name _instigator, getPlayerUID _instigator, _victimStats];
    [2,_killStats,_filename,true] call A3A_fnc_log;
};

///////////////Checks if is FF//////////////
private _exemption = switch (true) do {  // ~0.012 ms for all false cases
    case (!tkPunish):                                  {"FF PUNISH IS DISABLED"};
    case (!isMultiplayer):                             {"IS NOT MULTIPLAYER"};
    case ("HC" in (getPlayerUID _instigator)):         {"FF BY HC"};  // Quick & reliable check
    case (!(isPlayer _instigator)):                    {"FF BY AI"};
    case (_vehicle isEqualTo (vehicle _victim)):       {"IN SAME VEHICLE"};  // Also fulfils role of checking whether the instigator and victim is same person.
    case (_victim getVariable ["pvp",false]):          {call _logPvPHurt; "VICTIM NOT REBEL"};
    case (_instigator getVariable ["pvp",false]):      {call _logPvPAttack; "INSTIGATOR NOT REBEL"};
    default                                            {""};
};
if (!(_exemption isEqualTo "")) exitWith {
    format["NOT FF, %1", _exemption];
};

/////////////Acts on Collision//////////////
if (_isCollision) then {
    _customMessage = [_customMessage,"You damaged a friendly as a driver."] joinString "<br/>";
    _timeAdded = 27;
    _offenceAdded = 0.15;
    [2, format ["COLLISION | %1 [%2]'s %3 %4", name _instigator, getPlayerUID _instigator, _vehicleType, _victimStats], _filename] call A3A_fnc_log;
};

/////////Checks for important roles/////////
_exemption = switch (true) do {
    case (!(admin owner _instigator isEqualTo 0) || player isEqualTo _instigator): {  // Local host included.
        ["You damaged a friendly as admin."] call _notifyInstigator; // Admin not reported to victim in case of Zeus remote control.
        format ["ADMIN, %1", ["Server","Voted","Logged"] select (admin owner _instigator)];
    };
    case (_vehicle isKindOf "Air"): {
        call _notifyVictim;
        ["You damaged a friendly as CAS support."] call _notifyInstigator;
        format["AIRCRAFT, %1", _vehicleType];
    };
    case (
        isNumber (configFile >> "CfgVehicles" >> _vehicleType >> "artilleryScanner") &&
        {!(getNumber (configFile >> "CfgVehicles" >> _vehicleType >> "artilleryScanner") isEqualTo 0)}
    ): {
        call _notifyVictim;
        ["You damaged a friendly as arty support."] call _notifyInstigator;
        format ["ARTY, %1", _vehicleType];
    };
    // TODO: if( remoteControlling(_instigator) ) exitWith
        // For the meantime do either one of the following: login as admin for Zeus, or "player setVariable ["PvP",true,true];
        // Without above: Your AI will be prosecuted for FF. Upon leaving UAV you will be punished. If you have debug console you can self forgive.
    default {""};
};
if (!(_exemption isEqualTo "")) exitWith {
    private _playerStats = format["%1 [%2] %3, Avoided-time: %4, Avoided-offence: %5", name _instigator, getPlayerUID _instigator, _victimStats,str _timeAdded, str _offenceAdded];
    [2, format ["%1 | %2", _exemption, _playerStats], _filename,true] call A3A_fnc_log;
    _exemption;
};

///////////////Drop The Hammer//////////////
[_instigator,_timeAdded,_offenceAdded,_victim,_customMessage] call A3A_fnc_punishment;
"PROSECUTED";
