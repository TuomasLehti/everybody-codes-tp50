program Part2;

const
  numRows = 20;
  numCols = 25;
  numSlots = 13;
  numCoins = 100;
  lenCoin = 20;
  inputFnm = 'PART2.TXT';

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
  CoinIdx, SlotIdx : Byte;
  Score, HighScore, TotalScore : Integer;

begin
  WriteLn('Everybody Codes');
  WriteLn('Story 2: The Entertainment Hub');
  WriteLn('Quest 1: Nail Down Your Luck');
  Parse;
  TotalScore := 0;
  HighScore := 0;
  for CoinIdx := 1 to numCoins do
  begin
    for SlotIdx := 1 to numSlots do
    begin
      Score := Play(CoinIdx, SlotIdx);
      if Score > HighScore then
        HighScore := Score;
    end;
    TotalScore := TotalScore + HighScore;
    HighScore := 0;
  end;
  WriteLn('Part 2 answer: ', TotalScore);
end.