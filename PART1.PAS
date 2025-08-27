program Part1;

const
  numRows = 12;
  numCols = 17;
  numCoins = 9;
  lenCoin = 12;
  inputFnm = 'PART1.TXT';

type
  TMachine = array[1..numRows] of String[numCols];
  TCoins = array[1..numCoins] of String[lenCoin];

var
  Machine : TMachine;
  Coins : TCoins;

procedure Parse;
type
  TState = (sMachine, sCoins);
var
  EcInp : Text;
  Line : String;
  State : TState;
  Idx : Byte;
begin
  Assign(EcInp, inputFnm);
  Reset(EcInp);
  State := sMachine;
  Idx := 0;
  while not Eof(EcInp) do
  begin
    ReadLn(EcInp, Line);
    Idx := Idx + 1;
    if Line = '' then
    begin
      State := sCoins;
      Idx := 0;
    end
    else if State = sMachine then
      Machine[Idx] := Line
    else
      Coins[Idx] := Line;
  end;
  Close(EcInp);
end;

function Play(CoinIdx, Slot : Byte) : Integer;
var
  X, Y, BehaviourIdx, FinalSlot : Byte;
  Coin : String;
  Score : Integer;
begin
  Coin := Coins[CoinIdx];
  X := Slot * 2 - 1;
  BehaviourIdx := 0;
  for Y := 1 to numRows + 1 do
  begin
    if Machine[Y][X] = '*' then
    begin
      BehaviourIdx := BehaviourIdx + 1;
      if Coin[BehaviourIdx] = 'R' then
        if X = numCols then
          X := X - 1
        else
          X := X + 1
      else
        if X = 1 then
          X := X + 1
        else
          X := X - 1;
    end;
  end;
  Score := ((X + 1) div 2) * 2 - Slot;
  if (Score < 0) then
    Score := 0;
  Play := Score;
end;

var
  Idx : Byte;
  Score : Integer;

begin
  WriteLn('Everybody Codes');
  WriteLn('Story 2: The Entertainment Hub');
  WriteLn('Quest 1: Nail Down Your Luck');
  Parse;
  Score := 0;
  for Idx := 1 to numCoins do
    Score := Score + Play(Idx, Idx);
  WriteLn('Part 1 answer: ', Score);
end.