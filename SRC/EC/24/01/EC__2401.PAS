{

  A solver for Everybody Codes 2024, day 1.

  This solver was written 4.3.2026.

}
program EC__2401;



uses
  Metadata, Strs, Logging;



function GetPotions(
  Monster : Char
) : Byte;

begin
  if Monster = 'B' then
    GetPotions := 1
  else if Monster = 'C' then
    GetPotions := 3
  else if Monster = 'D' then
    GetPotions := 5
  else
    GetPotions := 0;
end;




function SolvePt1(
  Meta : TMetadata
) : LongInt;

var
  C : Char;
  Ans : LongInt;

begin
  OpenInput(Meta, 1);
  Ans := 0;
  while not InpEof do
    Ans := Ans + GetPotions(ReadInpChar);
  CloseInput;
  SolvePt1 := Ans;
end;



function SolvePt2(
  Meta : TMetadata
) : LongInt;

var
  C1, C2 : Char;
  Ans : LongInt;

begin
  OpenInput(Meta, 2);
  Ans := 0;
  while not InpEof do
  begin
    C1 := ReadInpChar;
    C2 := ReadInpChar;
    Ans := Ans + GetPotions(C1) + GetPotions(C2);
    if (C1 <> 'x') and (C2 <> 'x') then
      Ans := Ans + 2;
  end;
  CloseInput;
  SolvePt2 := Ans;
end;





function SolvePt3(
  Meta : TMetadata
) : LongInt;

var
  C1, C2, C3 : Char;
  NumXs : Byte;
  Ans : LongInt;

begin
  OpenInput(Meta, 3);
  Ans := 0;
  while not InpEof do
  begin
    C1 := ReadInpChar;
    C2 := ReadInpChar;
    C3 := ReadInpChar;
    NumXs := 0;
    if C1 = 'x' then NumXs := NumXs + 1;
    if C2 = 'x' then NumXs := NumXs + 1;
    if C3 = 'x' then NumXs := NumXs + 1;
    Ans := Ans + GetPotions(C1) + GetPotions(C2) + GetPotions(C3);
    if NumXs = 1 then
      Ans := Ans + 2
    else if NumXs = 0 then
      Ans := Ans + 6;
  end;
  CloseInput;
  SolvePt3 := Ans;
end;


var
  Meta : TMetadata;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;


begin
  Meta.Id := 'EC__2401';
  ReadMetadata(Meta);
  LogStart(Meta);
  LogAnswer(Meta, 1, IntToStr(SolvePt1(Meta)));
  LogAnswer(Meta, 2, IntToStr(SolvePt2(Meta)));
  LogAnswer(Meta, 3, IntToStr(SolvePt3(Meta)));
end.