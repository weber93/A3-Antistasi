////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
//Name Used for notifications
nameOccupants = "NATO";

//Police Faction
factionGEN = "BLU_GEN_F";
//SF Faction
factionMaleOccupants = "BLU_CTRG_F";
//Miltia Faction
if (gameMode != 4) then {factionFIA = ""};

//Flag Images
NATOFlag = "Flag_NATO_F";
NATOFlagTexture = "\A3\Data_F\Flags\Flag_NATO_CO.paa";
flagNATOmrk = "flag_NATO";
if (isServer) then {"NATO_carrier" setMarkerText "NATO Carrier"};

//Loot Crate
NATOAmmobox = "B_supplyCrate_F";

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
NATOPlayerLoadouts = [
	//Team Leader
	["vanilla_blufor_teamLeader_WDL"] call A3A_fnc_getLoadout,
	//Medic
	["vanilla_blufor_medic_WDL"] call A3A_fnc_getLoadout,
	//Autorifleman
	["vanilla_blufor_machineGunner_WDL"] call A3A_fnc_getLoadout,
	//Marksman
	["vanilla_blufor_marksman_WDL"] call A3A_fnc_getLoadout,
	//Anti-tank Scout
	["vanilla_blufor_AT_WDL"] call A3A_fnc_getLoadout,
	//AT2
	["vanilla_blufor_rifleman_WDL"] call A3A_fnc_getLoadout
];

//PVP Player Vehicles
vehNATOPVP = ["B_MRAP_01_F","B_MRAP_01_hmg_F","B_Quadbike_01_F"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
NATOGrunt = "B_W_Soldier_F";
NATOOfficer = "B_W_Officer_F";
NATOOfficer2 = "B_G_officer_F";
NATOBodyG = "B_W_Soldier_TL_F";
NATOCrew = "B_W_Crew_F";
NATOUnarmed = "B_W_Survivor_F";
NATOMarksman = "B_W_soldier_M_F";
staticCrewOccupants = "B_W_Soldier_F";
NATOPilot = "B_W_Helipilot_F";

//Militia Units
if (gameMode != 4) then
	{
	FIARifleman = "B_W_Soldier_F";
	FIAMarksman = "B_W_soldier_M_F";
	};

//Police Units
policeOfficer = "B_GEN_Commander_F";
policeGrunt = "B_GEN_Soldier_F";

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
//Military Groups
//Teams
groupsNATOSentry = ["B_W_Soldier_GL_F",NATOGrunt];
groupsNATOSniper = ["B_sniper_F","B_W_Soldier_SL_F"];
groupsNATOsmall = [groupsNATOSentry,groupsNATOSniper,["B_W_soldier_M_F","B_W_Officer_F"]];
//Fireteams
groupsNATOAA = ["B_W_Soldier_TL_F","B_W_Soldier_AA_F","B_W_Soldier_AA_F","B_W_Soldier_AAA_F"];
groupsNATOAT = ["B_W_Soldier_TL_F","B_W_Soldier_AT_F","B_W_Soldier_AT_F","B_W_Soldier_AAT_F"];
groupsNATOmid = [["B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_GL_F","B_W_Soldier_LAT2_F"],groupsNATOAA,groupsNATOAT];
//Squads
NATOSquad = ["B_W_Soldier_SL_F",NATOGrunt,"B_W_Soldier_LAT2_F",NATOMarksman,"B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_A_F","B_W_Medic_F"];
NATOSpecOp = ["B_CTRG_Soldier_TL_tna_F","B_CTRG_Soldier_M_tna_F",NATOBodyG,"B_CTRG_Soldier_LAT_tna_F","B_CTRG_Soldier_JTAC_tna_F","B_CTRG_Soldier_Exp_tna_F","B_CTRG_Soldier_AR_tna_F","B_CTRG_Soldier_Medic_tna_F"];
groupsNATOSquad =
	[
	NATOSquad,
	["B_W_Soldier_SL_F",NATOGrunt,"B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_A_F","B_W_Soldier_LAT2_F","B_W_Soldier_LAT2_F","B_W_Medic_F"],
	["B_W_Soldier_SL_F",NATOGrunt,"B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_A_F","B_W_Soldier_LAT_F","B_W_Soldier_LAT_F","B_W_Medic_F"],
	["B_W_Soldier_SL_F",NATOGrunt,"B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_A_F","B_W_Soldier_AA_F","B_W_Soldier_AAA_F","B_W_Medic_F"],
	["B_W_Soldier_SL_F",NATOGrunt,"B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_A_F","B_W_Soldier_AT_F","B_W_Soldier_AAT_F","B_W_Medic_F"],
	["B_W_Soldier_SL_F",NATOGrunt,"B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_A_F","B_W_Engineer_F","B_W_Engineer_F","B_W_Medic_F"]
	];

//Militia Groups
if (gameMode != 4) then
	{
	//Teams
	groupsFIASmall =
		[
		["B_W_Soldier_GL_F",FIARifleman],
		[FIAMarksman,FIARifleman],
		["B_W_soldier_M_F","B_W_soldier_M_F"]
		];
	//Fireteams
	groupsFIAMid =
		[
		["B_W_Soldier_TL_F","B_W_Soldier_GL_F","B_W_Soldier_AR_F","B_W_soldier_M_F"],
		["B_W_Soldier_TL_F","B_W_Soldier_GL_F","B_W_Soldier_AR_F","B_W_Soldier_LAT2_F"],
		["B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_AAA_F","B_W_Soldier_AA_F"]
		];
	//Squads
	FIASquad = ["B_W_Soldier_TL_F","B_W_Soldier_AR_F","B_W_Soldier_GL_F","B_W_Officer_F","B_W_Officer_F","B_W_soldier_M_F","B_W_Soldier_LAT2_F","B_W_Medic_F"];
	groupsFIASquad =
		[
		FIASquad,
		["B_W_Soldier_TL_F","B_W_Support_AMG_F","B_W_Soldier_GL_F","B_W_Officer_F","B_W_Support_MG_F","B_W_soldier_M_F","B_W_Soldier_LAT2_F","B_W_Medic_F"]
		];
	};

//Police Groups
//Teams
groupsNATOGen = [policeOfficer,policeGrunt];

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
//Lite
vehNATOBike = "B_Quadbike_01_F";
vehNATOLightArmed = ["B_MRAP_01_hmg_F"];
vehNATOLightUnarmed = ["B_MRAP_01_F"];
vehNATOTrucks = ["B_Truck_01_transport_F","B_Truck_01_covered_F"];
vehNATOCargoTrucks = ["B_Truck_01_cargo_F", "B_Truck_01_flatbed_F"];
vehNATOAmmoTruck = "B_Truck_01_ammo_F";
vehNATORepairTruck = "B_Truck_01_Repair_F";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
//Armored
vehNATOAPC = ["B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_rcws_F"];
vehNATOTank = "B_MBT_01_cannon_F";
vehNATOAA = "B_APC_Tracked_01_AA_F";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
//Boats
vehNATOBoat = "B_Boat_Armed_01_minigun_F";
vehNATORBoat = "B_Boat_Transport_01_F";
vehNATOBoats = [vehNATOBoat,vehNATORBoat,"B_APC_Wheeled_01_cannon_F"];
//Planes
vehNATOPlane = "B_Plane_CAS_01_F";
vehNATOPlaneAA = "B_Plane_Fighter_01_F";
vehNATOTransportPlanes = ["B_T_VTOL_01_infantry_F"];
//Heli
vehNATOPatrolHeli = "B_Heli_Light_01_F";
vehNATOTransportHelis = ["B_Heli_Transport_03_F",vehNATOPatrolHeli,"B_Heli_Transport_01_camo_F"];
vehNATOAttackHelis = ["B_Heli_Light_01_armed_F","B_Heli_Attack_01_F"];
//UAV
vehNATOUAV = "B_UAV_02_F";
vehNATOUAVSmall = "B_UAV_01_F";
//Artillery
vehNATOMRLS = "B_MBT_01_arty_F";
vehNATOMRLSMags = "32Rnd_155mm_Mo_shells";
//Combined Arrays
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, "B_Truck_01_fuel_F", "B_Truck_01_medical_F", vehNATORepairTruck,"B_APC_Tracked_01_CRV_F"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA] + vehNATOTransportPlanes;

//Militia Vehicles
if (gameMode != 4) then
	{
	vehFIAArmedCar = "B_LSV_01_armed_F";
	vehFIATruck = "B_Truck_01_transport_F";
	vehFIACar = "B_LSV_01_unarmed_F";
	};

//Police Vehicles
vehPoliceCar = "B_GEN_Offroad_01_gen_F";

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Statics
NATOMG = "I_G_HMG_02_high_F";
staticATOccupants = "B_static_AT_F";
staticAAOccupants = "B_static_AA_F";
NATOMortar = "B_Mortar_01_F";

//Static Weapon Bags
MGStaticNATOB = "I_G_HMG_02_high_weapon_F";
ATStaticNATOB = "B_AT_01_weapon_F";
AAStaticNATOB = "B_AA_01_weapon_F";
MortStaticNATOB = "B_Mortar_01_weapon_F";
//Short Support
supportStaticNATOB = "I_G_HMG_02_support_F";
//Tall Support
supportStaticNATOB2 = "I_G_HMG_02_support_high_F";
//Mortar Support
supportStaticNATOB3 = "B_Mortar_01_support_F";
