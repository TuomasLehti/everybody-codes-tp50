program Aoc2507;

uses
  Utils;

const
  numCols = 141;
  inpFn = 'INPUT07.TXT';
  thousandsSep = ' ';

type
  TBigInt = array[0..10] of Word;



procedure PrintBigInt(
  BigInt : TBigInt
);

var
  I : Byte;

begin
  I := 0;
  while (BigInt[I] = 0) and (I < 11) do
    I := I + 1;

  Write(BigInt[I]);
  I := I + 1;

  while (I < 11) do
  begin
    Write(thousandsSep);
    if (BigInt[I] < 100) then Write('0');
    if (BigInt[I] < 10) then Write('0');
    Write(BigInt[I]);
    I := I + 1;
  end;

  WriteLn;
end;



procedure ZeroBigInt(
  var BigInt : TBigInt
);

var
  I : Byte;

begin
  for I := 0 to 10 do BigInt[I] := 0;
end;



procedure IncBigInt(
  var One : TBigInt;
  Other : TBigInt
);

var
  I : Byte;

begin
  for I := 10 downto 0 do
  begin
    One[I] := One[I] + Other[I];
    if (One[I] > 1000) and (I > 0) then
    begin
      One[I-1] := One[I-1] + 1;
      One[I] := One[I] - 1000;
    end;
  end;
end;



function BigIntIsZero(
  BigInt : TBigInt
) : Boolean;

var
  I : Byte;

begin
  BigIntIsZero := true;
  for I := 0 to 10 do
    if BigInt[I] > 0 then
      BigIntIsZero := false;
end;



type
  TSplitters = array[1..numCols] of Boolean;

  TBeams = array[1..numCols] of TBigInt;



procedure GetBeamsAtStart(
  var AocInp : Text;
  var Beams : TBeams
);

var
  I : Byte;
  S : String;

begin
  Readln(AocInp, S);
  for I := 1 to numCols do
  begin
    ZeroBigInt(Beams[I]);
    if S[I] = 'S' then
      Beams[I][10] := 1;
  end;
  Readln(AocInp); { empty line after each meaningful line }
end;



procedure GetSplitters(
  var AocInp : Text;
  var Splitters : TSplitters
);

var
  S : String;
  I : Byte;

begin
  Readln(AocInp, S);
  for I := 1 to numCols do
    Splitters[I] := S[I] = '^';
  Readln(AocInp); { empty line after each meaningful line }
end;



var
  AocInp : Text;
  AnsPt1 : Word;
  AnsPt2 : TBigInt;
  Beams, NextBeams : TBeams;
  Splitters : TSplitters;
  I : Byte;

begin
  Assign(AocInp, inpFn);
  Reset(AocInp);

  GetBeamsAtStart(AocInp, Beams);



  AnsPt1 := 0;

  while not Eof(AocInp) do
  begin
    GetSplitters(AocInp, Splitters);

    for I := 1 to numCols do
      ZeroBigInt(NextBeams[I]);

    for I := 1 to numCols do
    begin
      if not Splitters[I] then
      begin
        IncBigInt(NextBeams[I], Beams[I]);
      end
      else
      begin
        if not BigIntIsZero(Beams[I]) then
          AnsPt1 := AnsPt1 + 1;
        IncBigInt(NextBeams[I-1], Beams[I]);
        IncBigInt(NextBeams[I+1], Beams[I]);
      end;
    end;

    Beams := NextBeams;

  end;

  ZeroBigInt(AnsPt2);
  for I := 1 to numCols do
  begin
    IncBigInt(AnsPt2, Beams[I]);
  end;

  Writeln('Part 1: ', AnsPt1);
  Write('Part 2: ');
  PrintBigInt(AnsPt2);

  Close(AocInp);
end.