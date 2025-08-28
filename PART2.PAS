program Part2;

uses
  SlotMchn;

var
  CoinIdx, SlotIdx : Byte;
  Score, HighScore, TotalScore : Integer;

begin
  WriteLn('Everybody Codes');
  WriteLn('Story 2: The Entertainment Hub');
  WriteLn('Quest 1: Nail Down Your Luck');
  Parse('PART2.TXT');
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