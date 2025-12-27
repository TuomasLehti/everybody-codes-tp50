program Part3;

uses
  SlotMchn;

type
  TGameState = array[1..maxSlots] of Byte;

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
  Parse('PART3.TXT');
  CoinsLeft := numCoins;
  for SlotIdx := 1 to numSlots do
    GameState[SlotIdx] := 0;
  NumCombs := 0;
  MaxScore := 0;
  MinScore := 32767;
  PlayEveryGame(CoinsLeft, GameState);
  WriteLn('Part 3: ', MinScore, ' ', MaxScore);
end.