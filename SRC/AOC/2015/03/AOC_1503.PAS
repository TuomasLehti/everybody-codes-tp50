{

  A solver for Advent of Code 2015, day 3.

  This solver was written 11.1.2026.

}
program AoC_1503;

uses
  Metadata, Strs, Logging;



const
  numMoves = 8192;



type
  TCoords = record
    X, Y : Integer;
  end;



  TCoordArr = array[1..numMoves] of TCoords;



  TVisited = record
    Coords : TCoordArr;
    Num : Word;
  end;



  TVisitedPtr = ^TVisited;



function EqualCoords(
  C1, C2 : TCoords
) : Boolean;

begin
  EqualCoords := (C1.X = C2.X) and (C1.Y = C2.Y);
end;



function HasBeenVisited(
  Pos : TCoords;
  Visited : TVisitedPtr
) : Boolean;

var
  Idx : Word;
  IsVis : Boolean;

begin
  with Visited^ do
    for Idx := 1 to Num do
      if EqualCoords(Pos, Coords[Idx]) then
      begin
        HasBeenVisited := true;
        Exit;
      end;
  HasBeenVisited := false;
end;



procedure AddVisited(
  Pos : TCoords;
  Visited : TVisitedPtr
);

begin
  with Visited^ do
  begin
    if Num = numMoves then
    begin
      Log(logWarn, 'Too many moves');
      Exit;
    end;
    Num := Num + 1;
    Coords[Num] := Pos;
  end;
end;



procedure MoveSanta(
  var Pos : TCoords;
  Visited : TVisitedPtr;
  Dir : Char
);

begin
  case Dir of
    '^' : Pos.Y := Pos.Y + 1;
    '>' : Pos.X := Pos.X + 1;
    'v' : Pos.Y := Pos.Y - 1;
    '<' : Pos.X := Pos.X - 1;
  end;
  if not HasBeenVisited(Pos, Visited) then
    AddVisited(Pos, Visited)
end;


var
  SantaPt1,
  SantaPt2,
  RoboPt2 : TCoords;
  VisitedPt1,
  VisitedPt2 : TVisitedPtr;


var
  Meta : TMetadata;
  C : Char;
  Idx : Word;


begin
  Meta.Id := 'AOC_1503';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta);

  New(VisitedPt1);
  New(VisitedPt2);
  SantaPt1.X := 0;
  SantaPt1.Y := 0;
  SantaPt2.X := 0;
  SantaPt2.Y := 0;
  RoboPt2.X := 0;
  RoboPt2.Y := 0;
  AddVisited(SantaPt1, VisitedPt1);
  AddVisited(SantaPt2, VisitedPt2);
  Idx := 0;
  while not InpEof do
  begin
    Idx := Idx + 1;
    if (Idx mod 1000) = 0 then
      Log(logDebug, 'Move: ' + IntToStr(Idx));
    C := ReadInpChar;

    MoveSanta(SantaPt1, VisitedPt1, C);

    if (Idx MOD 2) = 0 then
      MoveSanta(SantaPt2, VisitedPt2, C)
    else
      MoveSanta(RoboPt2, VisitedPt2, C);
  end;

  CloseInput;

  LogAnswer(Meta, 1, IntToStr(VisitedPt1^.Num));
  LogAnswer(Meta, 2, IntToStr(VisitedPt2^.Num));
  Dispose(VisitedPt1);
  Dispose(VisitedPt2);
end.