params ["_currentRoad"];
private ["_connected", "_relPos", "_road"];
//Get all connected
_connected = roadsConnectedTo _currentRoad;

/*
_nearRoads = (getPos _currentRoad) nearRoads 10;
{
    if(_x != _currentRoad) then
    {
      _connected pushBackUnique _x;
    };
} forEach _nearRoads;
*/

for "_i" from 0 to 31 do
{
  _relPos = _currentRoad getRelPos [5, 11.25 * _i];
  _road = roadAt _relPos;
  if(!(isNull _road) && {_road != _currentRoad}) then
  {
    _connected pushBackUnique _road;
  };
  _relPos = _currentRoad getRelPos [7, (11.25 * _i) + (11.25 / 3)];
  _road = roadAt _relPos;
  if(!(isNull _road) && {_road != _currentRoad}) then
  {
    _connected pushBackUnique _road;
  };
  _relPos = _currentRoad getRelPos [9, (11.25 * _i) + ( 2 * 11.25 / 3)];
  _road = roadAt _relPos;
  if(!(isNull _road) && {_road != _currentRoad}) then
  {
    _connected pushBackUnique _road;
  };
};


_connected;
