{

  A solver for Everybody Codes, story 3, part 1.

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
    R, G, B : Byte;
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
end;



var
  Meta : TMetadata;
  Line : String;
  Scale : TScaleRec;
  AnsPt1 : LongInt;


begin
  Meta.Id := 'ECS_0301';
  ReadMetadata(Meta);
  LogStart(Meta);
  OpenInput(Meta, 1);

  AnsPt1 := 0;
  while not InpEof do
  begin
    Line := ReadInpStr;
    InputToScale(Line, Scale);
    if (Scale.G > Scale.R) and (Scale.G > Scale.B) then
      AnsPt1 := AnsPt1 + Scale.Id;
  end;
  LogAnswer(Meta, 1, IntToStr(AnsPt1));

  CloseInput;
end.