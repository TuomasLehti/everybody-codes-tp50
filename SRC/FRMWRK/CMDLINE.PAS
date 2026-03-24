{
  A crude command line argument parser.

  Supports plain arguments without switches:
    PROGRAM ARG

  Supports switches without values
    PROGRAM /F

  Supports switches with values:
    PROGRAM /F<value>

  Arguments can't contain spaces.

  Switches are case-insensitive.

  All plain arguments should be at the start and after a switch everything
  should be a switch.

  Supports 10 plain arguments and 10 switches at the moment. This restriction
  may become less restrictive later. This restriction will not become more
  restrictive at any point in time.
}
unit CmdLine;



interface



uses
  Strs;


{
  ---------------------------------------------------------------------------
  GetSwitch - function
  ---------------------------------------------------------------------------

  Function

    Returns the value of a switch.

  Parameters

    S          The switch.

    Returns    The value.

  Remarks

    If there is no switch with a given value, returns an empty string.

}
function GetSwitch(
  S : String
): String;



{
  ---------------------------------------------------------------------------
  SwitchExists - function
  ---------------------------------------------------------------------------

  Function

    Checks if a switch has been given in the command line.

  Parameters

    S          The switch.

    Returns    True if a switch exists in the command line.

  Remarks

    The switch in question may or may not have a value.
}
function SwitchExists(
  S : String
): Boolean;



{
  ---------------------------------------------------------------------------
  GetPlain
  ---------------------------------------------------------------------------

  Function

    Returns a plain argument.

  Parameters

    Idx        The index of the argument.

    Returns    The argument.

}
function GetPlain(
  Idx : Byte
): String;



implementation



type
  TStrArr = array[1..10] of String;



var
  Plains : TStrArr;
  NumPlains : Byte;
  Switches, Values : TStrArr;
  NumSwitches : Byte;



function GetSwitch(
  S : String
): String;

var
  I : Integer;

begin
  I := 1;
  while (I <= 10) and (Switches[I] <> S) do
    I := I + 1;
  if I <= 10 then
    GetSwitch := Values[I]
  else
    GetSwitch := '';
end;



function SwitchExists(
  S : String
) : Boolean;

var
  I : Integer;

begin
  for I := 1 to NumSwitches do
    if Switches[I] = S then
    begin
      SwitchExists := true;
      Exit;
    end;
  SwitchExists := false;
end;



function GetPlain(
  Idx : Byte
): String;

begin
  GetPlain := '';
  if Idx <= NumPlains then
    GetPlain := Plains[Idx];
end;



procedure ParseCmdLine;

type
  TParsingState = (sPlains, sSwitches);

var
  I : Word;
  State : TParsingState;

begin
  State := sPlains;
  NumPlains := 0;
  NumSwitches := 0;
  for I := 1 to ParamCount do
  begin
    if StrBegins(ParamStr(I), '/') then
      State := sSwitches;
    if State = sPlains then
    begin
      NumPlains := NumPlains + 1;
      Plains[NumPlains] := ParamStr(I);
    end
    else
    begin
      NumSwitches := NumSwitches + 1;
      Switches[NumSwitches] := Copy(ParamStr(I), 2, 1);
      Values[NumSwitches] := Copy(ParamStr(I), 3, Length(ParamStr(I)) - 2);
    end;
  end;
end;



begin
  ParseCmdLine;
end.