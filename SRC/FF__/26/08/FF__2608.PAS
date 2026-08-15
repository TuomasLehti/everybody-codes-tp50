{@
------------------------------------------------------------------------
Ff__2608 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2026, eighth puzzle.

Usage

  FF__2608

See

  https://flipflop.slome.org/2026/8
}


program Ff__2608;



uses
  Strs, Logging, Metadata, Structs;


type


  PStr = ^String;



{$F+}
procedure DestroyPStr(
  var Data : Pointer
);

begin
  Dispose(PStr(Data));
  Data := nil;
end;
{$F-}



function InpToPStr(
  Inp : String
) : PStr;

var
  Rule : PStr;
  ReplacerIdx : Byte;

begin
  New(Rule);
  Rule^ := '';
  while Length(Inp) > 0 do
  begin
    Rule^ := Rule^ + Copy(Inp, 1, 1);
    Delete(Inp, 1, 2);
  end;
  InpToPStr := Rule;
end;



procedure ParseInput(
  Meta : TMetadata;
  var Rules : TLnkLst
);

begin
  CreateLnkLst(Rules);
  OpenInput(Meta, 1);
  while not InpEof do
  begin
    AppendToLnkLst(Rules, InpToPStr(ReadInpStr));
  end;
  Close(Input);
end;



function GetRuleStr(
  Rules : TLnkLst;
  Evolver : String
) : PStr;

var
  Cur : PStr;

begin
  IterReset(Rules);
  while not IterEndOfLst(Rules) do
  begin
    Cur := IterNext(Rules);
    if Copy(Cur^, 1, Length(Evolver)) = Evolver then
    begin
      GetRuleStr := Cur;
      Exit;
    end;
  end;
{  SLog(logWarn, 'Evolver not found');}
  GetRuleStr := nil;
end;


type
  TStoatArr = array[0..64000] of Char;

  PStoatArr = ^TStoatArr;



function GeneratePt1(
  Rules : TLnkLst;
  Src, Dest : PStoatArr
) : Word;

var
  SrcIdx, DestIdx : Word;
  Rule : PStr;
  Evolver : String;

begin
  SrcIdx := 0;
  DestIdx := 0;
  while Src^[SrcIdx] <> Chr(0) do
  begin
    Evolver[0] := Chr(1);
    Evolver := Src^[SrcIdx];
    Rule := GetRuleStr(Rules, Evolver);
    Move(Rule^[2], Dest^[DestIdx], Length(Rule^) - 1);
    DestIdx := DestIdx + Length(Rule^) - 1;
    Inc(SrcIdx);
  end;
  GeneratePt1 := DestIdx;
end;



function SolvePt1(
  Rules : TLnkLst
) : String;


var
  CurGen, NextGen : PStoatArr;
  GenIdx, GenLen : Word;

begin
  New(CurGen);
  New(NextGen);

  for GenIdx := 0 to 64000 do
  begin
    CurGen^[GenIdx] := Chr(0);
    NextGen^[GenIdx] := Chr(0);
  end;

  CurGen^[0] := 'A';
  CurGen^[1] := 'B';

  for GenIdx := 0 to 6 do
  begin
    if (GenIdx mod 2) = 0 then
      GenLen := GeneratePt1(Rules, CurGen, NextGen)
    else
      GenLen := GeneratePt1(Rules, NextGen, CurGen);
{    WriteLn(GenIdx, ':', GenLen);}
  end;

  Dispose(NextGen);
  Dispose(CurGen);
  SolvePt1 := IntToStr(GenLen);
end;




function GeneratePt2(
  Rules : TLnkLst;
  Src, Dest : PStoatArr
) : Word;

var
  SrcIdx, DestIdx : Word;
  Rule : PStr;
  Evolver : String;
  Tmp : Char;

begin
  SrcIdx := 0;
  DestIdx := 0;
  while Src^[SrcIdx + 1] <> Chr(0) do
  begin

    Evolver[0] := Chr(2);
    Evolver[1] := Src^[SrcIdx];
    Evolver[2] := Src^[SrcIdx + 1];

    Rule := GetRuleStr(Rules, Evolver);
    if Rule = nil then
    begin
      Tmp := Evolver[1];
      Evolver[1] := Evolver[2];
      Evolver[2] := Tmp;
      Rule := GetRuleStr(Rules, Evolver);
    end;
    if Rule = nil then
      SLog(logWarn, 'Evolver not found')
{    else
      Writeln(Rule^)};

    Dest^[DestIdx] := Src^[SrcIdx];
    Inc(DestIdx);

    Move(Rule^[3], Dest^[DestIdx], Length(Rule^) - 2);
    DestIdx := DestIdx + Length(Rule^) - 2;

    Dest^[DestIdx] := Src^[SrcIdx + 1];
    { Won't advance destination index because the next round will want to
      overwrite the char in the dest idx. }

    Inc(SrcIdx);
  end;
  GeneratePt2 := DestIdx + 1; { correct for unwillingness to advance dest idx }
end;



function SolvePt2(
  Rules : TLnkLst
) : String;


var
  CurGen, NextGen : PStoatArr;
  GenIdx, GenLen : Word;

begin
  New(CurGen);
  New(NextGen);

  for GenIdx := 0 to 64000 do
  begin
    CurGen^[GenIdx] := Chr(0);
    NextGen^[GenIdx] := Chr(0);
  end;

  CurGen^[0] := 'A';
  CurGen^[1] := 'B';

  for GenIdx := 0 to 6 do
  begin
    if (GenIdx mod 2) = 0 then
      GenLen := GeneratePt2(Rules, CurGen, NextGen)
    else
      GenLen := GeneratePt2(Rules, NextGen, CurGen);
    WriteLn(GenIdx, ':', GenLen);
  end;

  Dispose(NextGen);
  Dispose(CurGen);
  SolvePt2 := IntToStr(GenLen);
end;


function SolvePt3(
  Rules : TLnkLst
) : String;


var
  CurGen, NextGen : PStoatArr;
  GenIdx, GenLen : Word;

begin
  New(CurGen);
  New(NextGen);

  for GenIdx := 0 to 64000 do
  begin
    CurGen^[GenIdx] := Chr(0);
    NextGen^[GenIdx] := Chr(0);
  end;

  CurGen^[0] := 'A';
  CurGen^[1] := 'B';

  for GenIdx := 0 to 21 do
  begin
    if (GenIdx mod 2) = 0 then
      GenLen := GeneratePt2(Rules, CurGen, NextGen)
    else
      GenLen := GeneratePt2(Rules, NextGen, CurGen);
    WriteLn(GenIdx, ':', GenLen);
  end;

  Dispose(NextGen);
  Dispose(CurGen);
  SolvePt3 := IntToStr(GenLen);
end;


var
  Meta : TMetaData;
  Rules : TLnkLst; { of PRule }


begin
  Meta.Id := 'FF__2608';
  ReadMetadata(Meta);
  LogStart(Meta);
  ParseInput(Meta, Rules);

  LogAnswer(Meta, 1, SolvePt1(Rules));
  LogAnswer(Meta, 2, SolvePt2(Rules));
  LogAnswer(Meta, 3, SolvePt3(Rules));


  DestroyLnkLst(Rules, DestroyPStr);

end.
