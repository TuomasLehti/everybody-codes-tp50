program Part1;

var
  EcInput : Text;
  Balloons : String;
  FluffboltIdx : LongInt;
  BalloonIdx : LongInt;

function Fluffbolt(Idx : LongInt) : Char;
var
  IdxRemainder : Byte;
begin
  IdxRemainder := Idx mod 3;
  case IdxRemainder of
    0: Fluffbolt := 'R';
    1: Fluffbolt := 'G';
    2: Fluffbolt := 'B';
  end;
end;

begin
  WriteLn('Everybody Codes');
  WriteLn('Story 2: The Entertainment Hub');
  WriteLn('Quest 2: The Pocket-Money Popper');

  Assign(EcInput, 'PART1.TXT');
  Reset(EcInput);
  ReadLn(EcInput, Balloons);
  Close(EcInput);

  FluffboltIdx := 0;
  BalloonIdx := 1;
  while (BalloonIdx < Length(Balloons)) do
  begin
    if Balloons[BalloonIdx] <> Fluffbolt(FluffboltIdx) then
      FluffboltIdx := FluffboltIdx + 1;
    BalloonIdx := BalloonIdx + 1;
  end;
  FluffboltIdx := FluffboltIdx + 1;

  WriteLn('Part 1: ', FluffboltIdx);
end.