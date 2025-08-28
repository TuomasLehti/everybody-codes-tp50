program Part1;

uses
  SlotMchn;

var
  Idx : Byte;
  Score : Integer;

begin
  WriteLn('Everybody Codes');
  WriteLn('Story 2: The Entertainment Hub');
  WriteLn('Quest 1: Nail Down Your Luck');
  Parse('PART1.TXT');
  Score := 0;
  for Idx := 1 to numCoins do
    Score := Score + Play(Idx, Idx);
  WriteLn('Part 1 answer: ', Score);
end.