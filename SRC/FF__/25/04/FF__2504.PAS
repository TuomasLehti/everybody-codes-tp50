{@
------------------------------------------------------------------------
Ff__2504 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2015, fourth puzzle.

Usage

  FF__2504

See

  https://flipflop.slome.org/2025/4
}

program Ff__2504;

uses
  Metadata, Strs;

const
  NumTrash = 100;

type
  TCoords = record
    X, Y : Byte;
    D : LongInt;
  end;

  TTrash = array[1..NumTrash] of TCoords;

var
  Meta : TMetaData;


procedure ReadTrash(
  var Trash : TTrash
);

var
  S : String;
  TrashIdx, CommaIdx : Byte;
  Err : Integer;

begin
  OpenInput(Meta, 1);
  for TrashIdx := 1 to NumTrash do
  begin
    S := ReadInpStr;
    CommaIdx := Pos(',', S);

    Val(Copy(S, 1, CommaIdx - 1), Trash[TrashIdx].X, Err);
    if Err > 0 then
    begin
      Writeln('Number format error X ', Err);
      Halt;
    end;
    Val(Copy(S, CommaIdx + 1, Length(S)), Trash[TrashIdx].Y, Err);
    if Err > 0 then
    begin
      Writeln('Number format error Y ', Err);
      Halt;
    end;
    with Trash[TrashIdx] do
      D := X + Y;
  end;
  CloseInput;
end;



function StepsPt2(
  One, Other : TCoords
) : Word;

var
  DX, DY : Word;

begin
  DX := Abs(Other.X - One.X);
  DY := Abs(Other.Y - One.Y);
  if DY > DX then
    StepsPt2 := DX + DY - DX
  else
    StepsPt2 := DY + DX - DY;
end;


procedure Sort(
  var Trash : TTrash
);

var
  I, J : Byte;
  T : TCoords;

begin
  for I := 1 to NumTrash do
    for J := I + 1 to NumTrash do
      if Trash[I].D > Trash[J].D then
      begin
        T := Trash[I];
        Trash[I] := Trash[J];
        Trash[J] := T;
      end;
end;



var
  Trash : TTrash;
  Cur : TCoords;
  Idx : Byte;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;

begin
  Meta.ID := 'FF__2504';
  ReadMetadata(Meta);

  ReadTrash(Trash);
  Cur.X := 0;
  Cur.Y := 0;

  AnsPt1 := 0;
  AnsPt2 := 0;
  AnsPt3 := 0;
  for Idx := 1 to NumTrash do
  begin
    AnsPt1 := AnsPt1
      + Abs(Trash[Idx].X - Cur.X)
      + Abs(Trash[Idx].Y - Cur.Y);
    AnsPt2 := AnsPt2 + StepsPt2(Cur, Trash[Idx]);
    Cur := Trash[Idx];
  end;
  Sort(Trash);
  Cur.X := 0;
  Cur.Y := 0;
  for Idx := 1 to NumTrash do
  begin
    AnsPt3 := AnsPt3 + StepsPt2(Cur, Trash[Idx]);
    Cur := Trash[Idx];
  end;

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
  LogAnswer(Meta, 3, IntToStr(AnsPt3));
end.
