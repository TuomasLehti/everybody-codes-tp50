{

  A solver for Advent of Code 2015, day 2: I Was Told There Would Be No Math.

  Most of the work is done in the Present-unit, because it is easier to test.
  Time will tell if this presents name clashes in the future.

  This solver was made 11.1.2026.

}
program AoC_1502;

uses
  Metadata, Strs, Logging,
  Present;

var
  Meta : TMetadata;
  S, SS : String;
  Pr : TPresent;
  AnsPt1, AnsPt2 : LongInt;

begin
  Meta.Id := 'AOC_1502';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta);

  AnsPt1 := 0;
  AnsPt2 := 0;

  while not InpEof do
  begin
    InpToPresent(ReadInpStr, Pr);
    AnsPt1 := AnsPt1 + WrappingNeeded(Pr);
    AnsPt2 := AnsPt2 + RibbonNeeded(Pr);
  end;

  CloseInput;

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
end.