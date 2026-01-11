program AoC_1501;

uses
  CmdLine, Logging, Metadata, Strs;

var
  Meta : TMetadata;
  C : Char;
  Step, AnsPt1, AnsPt2 : Integer;

begin
  Meta.Id := 'AOC_1501';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta);

  AnsPt1 := 0;
  AnsPt2 := -1;
  Step := 0;

  while not InpEof do
  begin

    C := ReadInpChar;

    if C = '(' then
      AnsPt1 := AnsPt1 + 1
    else if C=')' then
      AnsPt1 := AnsPt1 - 1;

    Step := Step + 1;
    if (AnsPt2 = -1) and (AnsPt1 = -1) then
      AnsPt2 := Step;

  end;

  CloseInput;

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
end.