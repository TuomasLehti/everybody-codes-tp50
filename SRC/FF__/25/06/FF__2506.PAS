{@
------------------------------------------------------------------------
Ff__2506 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2015, fourth puzzle.

Usage

  FF__2506

See

  https://flipflop.slome.org/2025/6
}

program Ff__2506;

uses
  Metadata, Strs;

const
  NumBirds = 1000;
  SkySize = 1000;
  NumSecs = 100;

type
  TCoords = record
    X, Y : LongInt;
  end;

  TBirds = array[1..NumBirds] of TCoords;

var
  Meta : TMetadata;


procedure ClearBirds(
  var Birds : TBirds
);

var
  Idx : Word;

begin
  for Idx := 1 to NumBirds do
    with Birds[Idx] do
    begin
      X := 0;
      Y := 0;
    end;
end;



procedure ReadBirds(
  var Birds : TBirds
);

var
  S : String;
  TrashIdx : Word;

begin
  OpenInput(Meta, 1);
  for TrashIdx := 1 to NumBirds do
  begin
    S := ReadInpStr;
    Birds[TrashIdx].X := StrToInt(StrCutChr(S, ','));
    Birds[TrashIdx].Y := StrToInt(S);
  end;
  CloseInput;
end;



procedure MoveBirds(
  var Birds : TBirds;
  Moves : TBirds;
  Time : LongInt
);

var
  Idx : Word;

begin
  for Idx := 1 to NumBirds do
    with Birds[Idx] do
    begin
      X := X + Moves[Idx].X * Time;
      X := X mod SkySize;
      if X < 0 then
        X := X + SkySize;

      Y := Y + Moves[Idx].Y * Time;
      Y := Y mod SkySize;
      if Y < 0 then
        Y := Y + SkySize;
    end;
end;



function Picture(
  Birds : TBirds
) : Word;

var
  I, N : Word;

begin
  N := 0;
  for I := 1 to NumBirds do
    with Birds[I] do
      if (X >= 250) and (X < 750) and (Y >= 250) and (Y < 750) then
        Inc(N);
  Picture := N;
end;



var
  Moves, Birds, BirdsPt3 : TBirds;
  Sec, BirdIdx : Word;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;
  I : Integer;

begin
  Meta.ID := 'FF__2506';
  ReadMetadata(Meta);


  ClearBirds(Birds);
  ReadBirds(Moves);

  MoveBirds(Birds, Moves, NumSecs);
  AnsPt1 := Picture(Birds);

  ClearBirds(Birds);
  ClearBirds(BirdsPt3);
  AnsPt2 := 0;
  AnsPt3 := 0;
  for Sec := 1 to 1000 do
  begin
    Write(Sec, ' ');
    MoveBirds(Birds, Moves, 3600);
    AnsPt2 := AnsPt2 + Picture(Birds);
    MoveBirds(BirdsPt3, Moves, 31556926 div 2);
    MoveBirds(BirdsPt3, Moves, 31556926 div 2);
    AnsPt3 := AnsPt3 + Picture(BirdsPt3);
    WriteLn(AnsPt2, ' ', ANsPt3);
  end;

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
  LogAnswer(Meta, 3, IntToStr(AnsPt3));
end.
