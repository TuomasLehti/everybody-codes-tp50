{

  A solver for Advent of Code 2015, day 5.

  This solver was written 25.4.2026.

}
program AoC_1505;



uses
  Metadata, Strs, Logging;



{$I SRC\AOC\2015\05\STRNORN.PAS}



var
  Meta : TMetaData;
  AnsPt1, AnsPt2 : LongInt;
  Str : String;



begin
  Meta.Id := 'AOC_1505';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);

  AnsPt1 := 0;
  AnsPt2 := 0;
  while not InpEof do
  begin
    Str := ReadInpStr;
    if IsNicePt1(Str) then
      Inc(AnsPt1);
    if IsNicePt2(Str) then
      Inc(AnsPt2);
  end;
  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));

  CloseInput;
end.