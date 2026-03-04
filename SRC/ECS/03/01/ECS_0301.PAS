{

  A solver for Everybody Codes, story 3, parts 1 and 2.

  This solver was written 4.3.2026.

}
program ECS_0301;



uses
  Metadata, Strs, Logging;


{
  ---------------------------------------------------------------------------
  BinStrToLongInt
  ---------------------------------------------------------------------------

  Function

    A quick and dirty method for converting a binary string to a LongInt.

  Parameters

    Bin        The binary string to be converted.

    Zero       The character representing a zero.

    One        The character representing a one.

  Remarks

    No range checks.
}

function BinStrToLongInt(
  Bin : String;
  Zero, One : Char
) : LongInt;

var
  Idx : Byte;
  Res : LongInt;

begin
  Res := 0;
  for Idx := 1 to Length(Bin) do
  begin
    Res := Res * 2;
    if Bin[Idx] = One then
      Res := Res + 1;
  end;
  BinStrToLongInt := Res;
end;



type
  TScaleRec = record
    Id : Word;
    R, G, B, S : Byte;
  end;



{
  ---------------------------------------------------------------------------
  InputToScale
  ---------------------------------------------------------------------------

  Function

    Converts a string of the puzzle input to a record used in calculations.

  Parameters

    Line       A line of the input.

    Scale      The resulting scale record.
}

procedure InputToScale(
  Line : String;
  var Scale : TScaleRec
);

begin
  Scale.Id := StrToInt(StrCutChr(Line, ':'));
  Scale.R := BinStrToLongInt(StrCutChr(Line, ' '), 'r', 'R');
  Scale.G := BinStrToLongInt(StrCutChr(Line, ' '), 'g', 'G');
  Scale.B := BinStrToLongInt(StrCutChr(Line, ' '), 'b', 'B');
  if Line <> '' then
    Scale.S := BinStrToLongInt(StrCutChr(Line, ' '), 's', 'S');
end;



{
  ---------------------------------------------------------------------------
  SolvePt1
  ---------------------------------------------------------------------------

  Function

    Finds the scales whose green component is dominant and sums their ids.

  Parameters

    Meta       The metadata associated with this puzzle.
}

function SolvePt1(
  Meta : TMetadata
) : LongInt;

var
  Ans : LongInt;
  Line : String;
  Scale : TScaleRec;

begin
  OpenInput(Meta, 1);
  Ans := 0;
  while not InpEof do
  begin
    Line := ReadInpStr;
    InputToScale(Line, Scale);
    if (Scale.G > Scale.R) and (Scale.G > Scale.B) then
      Ans := Ans + Scale.Id;
  end;
  CloseInput;
  SolvePt1 := Ans;
end;



{
  ---------------------------------------------------------------------------
  SolvePt2
  ---------------------------------------------------------------------------

  Function

    Finds the shiniest scales and returns the id of the darkest of them.

  Parameters

    Meta       The metadata associated with this puzzle.
}

function SolvePt2(
  Meta : TMetadata
) : LongInt;

const
  NumScales = 256;

type
  TScaleArr = array[1..NumScales] of TScaleRec;
  PScaleArr = ^TScaleArr;

var
  Ans : LongInt;
  Line : String;
  Idx : Word;
  Scales : PScaleArr;
  MaxShine, MinDarkness : Byte;
  DarkestId : Word;

begin
  OpenInput(Meta, 2);
  New(Scales);

  { The scales need to be examined more than once, which is why this is
    done in multiple passes. }

  for Idx := 1 to NumScales do
    InputToScale(ReadInpStr, Scales^[Idx]);

  MaxShine := 0;
  for Idx := 1 to NumScales do
    with Scales^[Idx] do
      if S > MaxShine then
        MaxShine := S;

  MinDarkness := 255;
  for Idx := 1 to NumScales do
    with Scales^[Idx] do
      if S = MaxShine then
        if (R + G + B) < MinDarkness then
        begin
          MinDarkness := R + G + B;
          DarkestId := Id;
        end;

  SolvePt2 := DarkestId;
  Dispose(Scales);
  CloseInput;
end;



var
  Meta : TMetadata;
  AnsPt1, AnsPt2 : LongInt;


begin
  Meta.Id := 'ECS_0301';
  ReadMetadata(Meta);
  LogStart(Meta);
  AnsPt1 := SolvePt1(Meta);
  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  AnsPt2 := SolvePt2(Meta);
  LogAnswer(Meta, 2, IntToStr(AnsPt2));

end.