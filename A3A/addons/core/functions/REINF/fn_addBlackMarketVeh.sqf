#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
params [
	["_typeVehX", "", [""]]
];

if (_typeVehX isEqualTo "") exitWith {[localize "STR_A3A_addFiaVeh_header", localize "STR_A3AP_error_empty_generic"] call A3A_fnc_customHint;};
if (!(isNil "HR_GRG_placing") && {HR_GRG_placing}) exitWith {[localize "STR_A3A_addFiaVeh_header", localize "STR_A3AP_error_already_placing_generic"] call A3A_fnc_customHint;};
if (player != player getVariable ["owner",player]) exitWith {[localize "STR_A3A_addFiaVeh_header", localize "STR_A3AP_error_aicontrol_generic"] call A3A_fnc_customHint;};
if ([getPosATL player] call A3A_fnc_enemyNearCheck) exitWith {[localize "STR_A3A_addFiaVeh_header", localize "STR_A3AP_error_enemynear_generic"] call A3A_fnc_customHint;};

private _cost = [_typeVehX] call A3U_fnc_blackMarketVehiclePrice;
private _resourcesFIA = 0;

if (player != theBoss) then {
	_resourcesFIA = player getVariable "moneyX";
} else {
	private _factionMoney = server getVariable "resourcesFIA";
	if (_cost <= _factionMoney) then {
		_resourcesFIA = _factionMoney;
	} else {
		_resourcesFIA = player getVariable "moneyX";
	};
};

if (_resourcesFIA < _cost) exitWith {
	[localize "STR_A3A_addFiaVeh_header", format [localize "STR_A3AP_error_veh_not_enough_money_generic", _cost, A3A_faction_civ get "currencySymbol"]] call A3A_fnc_customHint;
};

if (player distance2d traderX > 50) exitWith {
	[localize "STR_A3A_addFiaVeh_header", localize "STR_veh_callback_arms_dealer_close"] call A3A_fnc_customHint;
};

private _extraMessage =	format [localize "STR_veh_callback_select_veh_generic", _cost,  A3A_faction_civ get "currencySymbol"];
private _fnc_placed = {
	params ["_vehicle", "_cost"];
	if (isNull _vehicle) exitWith {};
	private _factionMoney = server getVariable "resourcesFIA";

	if (player == theBoss && {_cost <= _factionMoney}) then {
		[0,(-1 * _cost)] remoteExec ["A3A_fnc_resourcesFIA",2];
	}
	else {
		[-1 * _cost] call A3A_fnc_resourcesPlayer;
		_vehicle setVariable ["ownerX",getPlayerUID player,true];
		playSound "A3AP_UiSuccess";
	};

	[_vehicle, teamPlayer] call A3A_fnc_AIVehInit;
	[_vehicle, teamPlayer] call SCRT_fnc_misc_tryInitVehicle;

	player reveal _vehicle;
};
private _fnc_check = {
	[(player distance2d traderX > 50), localize "STR_veh_callback_arms_dealer_close"];
};

[_typeVehX, _fnc_placed, _fnc_check, [_cost], nil, nil, nil, _extraMessage] call HR_GRG_fnc_confirmPlacement;
