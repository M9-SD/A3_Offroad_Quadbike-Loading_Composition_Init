comment "
	Script: M9SD_fnc_moduleOffQuad
	Name: Offroad w/ Quadbike-Loading
	Author: M9-SD
	Description:
		- Adds scroll actions to the offroad to open & close the back door (animated)
		- Adds an action to load the quadbike (requires you be driving the quadbike)
		- Adds an action to unload the quadbike (for both offroad and quadbike drivers)
		- SFX (playSound3D)
";

M9SD_fnc_moduleOffQuad = 
{
	this  = _this;

	if (isNil 'quadbikeTypes') then {
		quadbikeTypes = 
		[
			'B_Quadbike_01_F',
			'B_G_Quadbike_01_F',
			'B_T_Quadbike_01_F',
			'O_Quadbike_01_F',
			'O_G_Quadbike_01_F',
			'O_T_Quadbike_01_ghex_F',
			'I_Quadbike_01_F',
			'I_G_Quadbike_01_F',
			'I_E_Quadbike_01_F',
			'C_Quadbike_01_F',
			'C_Quadbike_01_black_F',
			'C_Quadbike_01_blue_F',
			'C_Quadbike_01_red_F',
			'C_Quadbike_01_white_F'
		];
		publicVariable 'quadbikeTypes';
	};
	
	comment "pos = position player;
	truck = 'C_Offroad_01_F' createVehicle pos;";
	
	pos = position this;
	truck = this;
	quad = (selectRandom ["B_T_Quadbike_01_F", "B_G_Quadbike_01_F", "C_Quadbike_01_black_F", "B_Quadbike_01_F"]) createVehicle pos;

	[truck, ["<t align='center' valign='middle'>Load Quadbike<br/><t font='puristaSemiBold'><t color='#FFFFFF'><t size='1.6'><img image='\A3\soft_f\Offroad_01\Data\UI\Offroad_01_base_CA.paa'></img><t font='RobotoCondensed' size='1.4'> ←      <t font='puristaSemiBold' size='1.0'><img image='\A3\Soft_F\Quadbike_01\Data\UI\Quadbike_01_CA.paa'></img><t size='1.4' font='puristaSemiBold'>  </t>", 
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_truck = _target;
		if (_truck getVariable ['occupied', false]) exitWith {};
		_veh = vehicle _caller;
		if ((typeof _veh) in quadbikeTypes) then {
			_quad = _veh;
			if !(_quad in (attachedObjects _truck)) then 
			{
				[_quad, false] remoteExec ['engineOn', owner _quad];
				comment "
					Attach point for normal offroad:
				_quad attachTo [_truck,[-0.025,-1.62,0.6]];";
				comment "
					Attach point for covered offroad:
				";
				_quad attachTo [_truck,[-0.025,-1.57,0.50]];
				[_quad, 0.95] remoteExec ['setObjectScale'];
				_truck setVariable ['occupied', true, true];
				_truck animateDoor ['OpenDoor3', 0, false];
				playSound3D ['A3\Missions_F_Bootcamp\data\sounds\assemble_target.wss', _quad, false, getposasl _quad, 0.5, 1, 35, 0, false];
				playSound3D ['A3\Missions_F_Bootcamp\data\sounds\vr_goggles.wss', _truck, false, getposasl _truck, 1.21, 1, 35, 0, false];
				playSound3D [format ['a3\missions_f_exp\data\sounds\exp_m07_lightson_0%1.wss', selectRandom [1,2,3]], _quad, false, getposasl _quad, 0.5, 1, 35, 0, false];
			};
		};
	}, arguments, 714, true, false, '', "
		((typeof (vehicle _this)) in quadbikeTypes) && 
		!(_target getVariable ['occupied', false]) && 
		!((vehicle _this) in (attachedObjects _target)) &&
		(speed _target < 0.1) && 
		((_target doorPhase 'openDoor3') == 1)
	", 7, faLSE, '', '']] remoteExec ['addAction', 0, true];

	COMMENT "kick! RE # 20";

	[truck, ["<t align='center' valign='middle'>Unload Quadbike<br/><t font='puristaSemiBold'><t color='#FFFFFF'><t size='1.6'><img image='\A3\soft_f\Offroad_01\Data\UI\Offroad_01_base_CA.paa'></img><t font='RobotoCondensed' size='1.4'> →      <t font='puristaSemiBold' size='1.0'><img image='\A3\Soft_F\Quadbike_01\Data\UI\Quadbike_01_CA.paa'></img><t size='1.4' font='puristaSemiBold'>  </t>", 
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_truck = _target;
		if !(_truck getVariable ['occupied', false]) exitWith {};
		_veh = vehicle _caller;
		_quad = objNull;
		if ((typeof _veh) in quadbikeTypes) then {
			_quad = _veh;
		};
		if (isNull _quad) then {
			{
				if (typeOf _x in quadbikeTypes) exitWith {
					_quad = _x;
				};
			} forEach attachedObjects _truck;
		};
		if (isNull _quad) exitWith { };
		if !(_quad in (attachedObjects _truck)) exitWith {}; 
		_dir = [vectorDir _truck, vectorUp _truck];
		_center = getPos _truck;
		_pos = _center findEmptyPosition [1,50,'B_T_Quadbike_01_F'];
		_pos set [2, (_pos # 2) + 0.25];
		_quad setPos _pos;
		detach _quad;
		_quad setvectordirandup _dir;
		_truck animateDoor ['OpenDoor3', 0, false];
		_truck setVariable ['occupied', false, true];
		playSound3D ['A3\Missions_F_Bootcamp\data\sounds\assemble_target.wss', _quad, false, getposasl _quad, 0.5, 1, 35, 0, false];
		playSound3D ['A3\Missions_F_Bootcamp\data\sounds\vr_goggles.wss', _truck, false, getposasl _truck, 1.5, 1, 35, 0, false];
		playSound3D [format ['a3\missions_f_exp\data\sounds\exp_m07_lightsoff_0%1.wss', selectRandom [1,2,3]], _quad, false, getposasl _quad, 0.5, 1, 35, 0, false];
	}, arguments, 714, true, false, '', "
		(_target getVariable ['occupied', false]) && 
		(speed _target < 0.1) && 
		((_target doorPhase 'openDoor3') == 1)
	", 7, faLSE, '', '']] remoteExec ['addAction', 0, true];


	[truck, ["Open back door", 
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_truck = _target;
		_truck animateDoor ['OpenDoor3', 1, false];
	}, arguments, 0.1, true, false, '', "
		((_target doorPhase 'openDoor3') == 0)
	", 5.25, faLSE, '', '']] remoteExec ['addAction', 0, true];

	[truck, ["Close back door", 
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_truck = _target;
		_truck animateDoor ['OpenDoor3', 0, false];
	}, arguments, 0.1, true, false, '', "
		((_target doorPhase 'openDoor3') == 1)
	", 5.25, faLSE, '', '']] remoteExec ['addAction', 0, true];
};

this call M9SD_fnc_moduleOffQuad;
