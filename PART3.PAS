program Part3;

const
  numRows = 20;
  numCols = 39;
  numSlots = 20;
  numCoins = 6;
  lenCoin = 20;
  inputFnm = 'PART3.TXT';

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

type
  TGameState = array[1..numSlots] of Byte;

var
  NumCombs : LongInt;
  MaxScore, MinScore : Integer;

procedure PlayEveryGame(CoinsLeft : Byte; GameState : TGameState);
var
  I, J, Score : Integer;
begin
  if CoinsLeft = 0 then
  begin
    NumCombs := NumCombs + 1;
    if (NumCombs mod 5000) = 0 then
      WriteLn(NumCombs);
    Score := 0;
    for J := 1 to numSlots do
      if GameState[J] > 0 then
        Score := Score + Play(GameState[J], J);
    if (Score < MinScore) then
      MinScore := Score;
    if (Score > MaxScore) then
      MaxScore := Score;
  end
  else
  begin
    for I := 1 to numSlots do
    begin
      if GameState[I] = 0 then
      begin
        GameState[I] := CoinsLeft;
        PlayEveryGame(CoinsLeft - 1, GameState);
        GameState[I] := 0;
      end;
    end;
  end;
end;


var
  SlotIdx : Byte;
  GameState : TGameState;
  CoinsLeft : Integer;

begin
  WriteLn('Everybody Codes');
  WriteLn('Story 2: The Entertainment Hub');
  WriteLn('Quest 1: Nail Down Your Luck');
  Parse;
  CoinsLeft := numCoins;
  for SlotIdx := 1 to numSlots do
    GameState[SlotIdx] := 0;
  NumCombs := 0;
  MaxScore := 0;
  MinScore := 32767;
  PlayEveryGame(CoinsLeft, GameState);
  WriteLn('Part 3: ', MinScore, ' ', MaxScore);
end.