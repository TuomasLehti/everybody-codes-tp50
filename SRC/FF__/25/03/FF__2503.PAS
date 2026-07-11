{@
------------------------------------------------------------------------
Ff__2503 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2015, third puzzle.

Usage

  FF__2503

See

  https://flipflop.slome.org/2025/3
}



program Ff__2503;


uses
  Strs, Logging, Metadata;


type



  TRgbCol = record
    R, G, B : Byte;
  end;



  TColAmt = record
    Col : TRgbCol;
    Amt : Word;
  end;



  TFreqs = array[0..1023] of TColAmt;



  TBushLbl = (red, green, blue, special);



procedure StrToRgbCol(
  S : String;
  var Col : TRgbCol
);

begin
  Col.R := StrToInt(StrCutChr(S, ','));
  Col.G := StrToInt(StrCutChr(S, ','));
  Col.B := StrToInt(S);
end;



procedure PrintColor(
  Col : TRgbCol
);

begin
  WriteLn(Col.R, ',', Col.G, ',', Col.B);
end;



function EqualColors(
  One, Other : TRgbCol
) : Boolean;

begin
  EqualColors :=
    (One.R = Other.R)
    and (One.G = Other.G)
    and (One.B = Other.B);
end;



procedure Count(
  Col : TRgbCol;
  var Freqs : TFreqs;
  var FreqAmt : Word
);

var
  Idx : Word;

begin
  if FreqAmt > 0 then
    for Idx := 0 to FreqAmt - 1 do
    begin
      if EqualColors(Col, Freqs[Idx].Col) then
      begin
        Inc(Freqs[Idx].Amt);
        Exit;
      end;
    end;
  Freqs[FreqAmt].Col := Col;
  Freqs[FreqAmt].Amt := 1;
  Inc(FreqAmt);
end;



function GetBushLbl(
  Col: TRgbCol
) : TBushLbl;

begin
  with Col do
  begin
    if (R = G) or (R = B) or (G = B) then
      GetBushLbl := special
    else if (R > G) and (R > B) then
      GetBushLbl := red
    else if (G > R) and (G > B) then
      GetBushLbl := green
    else if (B > R) and (B > G) then
      GetBushLbl := blue
    else
      Writeln('Shouldn''t happen');
  end;
end;



function Maximum(
  Freqs : TFreqs;
  FreqAmt : Word
) : String;

var
  MaxIdx: Word;
  Max, Idx : Word;
  Lbl : TBushLbl;

begin
  Max := 0;
  MaxIdx := 0;
  for Idx := 0 to FreqAmt - 1 do
  begin
    if Freqs[Idx].Amt > Max then
    begin
      Max := Freqs[Idx].Amt;
      MaxIdx := Idx;
    end;
  end;
  Maximum :=
    IntToStr(Freqs[MaxIdx].Col.R) + ',' +
    IntToStr(Freqs[MaxIdx].Col.G) + ',' +
    IntToStr(Freqs[MaxIdx].Col.B);
end;


var
  Meta : TMetadata;
  S : String;
  Col : TRgbCol;
  Freqs : TFreqs;
  FreqAmt : Word;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;
  Lbl : TBushLbl;

begin
  Meta.ID := 'FF__2503';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);
  FreqAmt := 0;
  AnsPt2 := 0;
  AnsPt3 := 0;
  while not InpEof do
  begin
    S := ReadInpStr;
    StrToRgbCol(S, Col);
    Count(Col, Freqs, FreqAmt);
    Lbl := GetBushLbl(Col);
    case Lbl of
      red:     AnsPt3 := AnsPt3 + 5;
      green:   begin
                 AnsPt3 := AnsPt3 + 2;
                 Inc(AnsPt2);
               end;
      blue:    AnsPt3 := AnsPt3 + 4;
      special: AnsPt3 := AnsPt3 + 10;
    end;
  end;
  CloseInput;

  LogAnswer(Meta, 1, Maximum(Freqs, FreqAmt));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
  LogAnswer(Meta, 3, IntToStr(AnsPt3));
end.