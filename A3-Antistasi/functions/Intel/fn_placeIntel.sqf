params["_marker", "_isLarge"];

private _intelSize = if (_isLarge) then {"large"} else {"medium"};
private _fileName = "placeIntel";
[
    3,
    format ["Spawning %2 intel on marker %1", _marker, _intelSize],
    _fileName
] call A3A_fnc_log;

//Catch invalid cases
if(!(_marker  in airportsX || {_marker in outposts})) exitWith
{
    [
        1,
        format ["Marker %1 is not suited to have intel!", _marker],
        _fileName
    ] call A3A_fnc_log;
};

//Search for building to place intel in
private _side = sidesX getVariable _marker;
private _size = markerSize _marker;
private _radius = sqrt ((_size select 0) * (_size select 0) + (_size select 1) * (_size select 1));

private _listStaticTower = ["Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"];
private _listStaticHQ = ["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F"];

private _allBuildings = nearestObjects [(getMarkerPos _marker), _listStaticHQ + _listStaticTower, _radius, true];

if(count _allBuildings == 0) exitWith
{
    [
        2,
        format ["No suitable buildings found on marker %1", _marker],
        _fileName
    ] call A3A_fnc_log;
};

private _building = selectRandom _allBuildings;
private _isTower = (!((typeOf _building) in _listStaticHQ));

//Placing the intel desk
private _spawnParameters = [];
if(_isTower) then
{
    _spawnParameters = [_building buildingPos 9, -90];
}
else
{
    _spawnParameters = [_building buildingPos 1, -180];
};

private _desk = createVehicle ["Land_CampingTable_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_desk setDir (getDir _building + (_spawnParameters select 1));
_desk setPos (_spawnParameters select 0);
_desk setVelocity [0, 0, -1];

//Await until desk have hit the group, it tend to stuck in the air otherwise
sleep 5;

private _intelType = "";
if(_isLarge) then
{
    _intelType = "Land_Laptop_unfolded_F";
    _spawnParameters = -25;
}
else
{
    _intelType = "Land_Document_01_F";
    _spawnParameters = -155;
};

private _deskPos = getPosATL _desk;
private _intelPos = ([_deskPos, 0.5, (getDir _desk) + 80] call BIS_fnc_relPos) vectorAdd [0, 0, 0.82];
private _intel = createVehicle [_intelType, [0,0,0], [], 0, "CAN_COLLIDE"];
_intel setDir ((getDir _desk) + _spawnParameters);
_intel setPosATL _intelPos;
_intel enableSimulation false;
_intel allowDamage false;

if(_isLarge) then
{
    private _isTrap = (random 100 < (4 * tierWar));
    if(_isTrap) then
    {
        [3, format ["Large intel on %1 is selected as trap, spawning explosives", _marker], _fileName] call A3A_fnc_log;
        private _bomb = "DemoCharge_Remote_Ammo_Scripted" createVehicle [0,0,0];
        _bomb = [_bomb] call BIS_fnc_replaceWithSimpleObject;
        _bomb setDir (getDir _intel);
        _bomb attachTo [_intel, [0,0,-0.14]];
        _bomb setVectorUp [0,0,-1];
        _intel setVariable ["trapBomb", _bomb, true];
    };
    _intel addAction ["Download Intel", {["Large", _this select 0, _this select 3, _this select 2] spawn A3A_fnc_retrieveIntel;}, _marker,4,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
}
else
{
    _intel addAction ["Take Intel", {["Medium", _this select 0] spawn A3A_fnc_retrieveIntel;},nil,4,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
};

/*
[_marker, _desk, _intel] spawn
{
    waitUntil{sleep 10; (spawner getVariable (_this select 0) == 2)};
    deleteVehicle (_this select 1);
    if(!isNil {_this select 2}) then {deleteVehicle (_this select 2)};
};
*/