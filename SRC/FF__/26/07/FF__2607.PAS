{@
------------------------------------------------------------------------
Ff__2607 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2026, seventh puzzle.

Usage

  FF__2607

See

  https://flipflop.slome.org/2026/7
}


program Ff__2607;



uses
  Crt,
  Strs, Logging, Metadata, Structs, Coords;



const
  NumMovements = 5000;
  GridHeight = 30;
  GridWidth = 30;



type
  TMovementArr = array[1..NumMovements] of Char;
  PMovementArr = ^TMovementArr;


type
  TDir = (Up, Rt, Dn, Lt);



const
  Translations : array[TDir] of TLongCoords = (
    (X:  0; Y:  1),
    (X:  1; Y:  0),
    (X:  0; Y: -1),
    (X: -1; Y:  0)
  );



procedure Translate(
  Coords, Translation : TLongCoords;
  var Result : TLongCoords
);

begin
  Result.X := Coords.X + Translation.X;
  Result.Y := Coords.Y + Translation.Y;
end;



function LongCoordsEqual(
  One, Other : PLongCoords
) : Boolean;

begin
  LongCoordsEqual := (One^.X = Other^.X) and (One^.Y = Other^.Y);
end;



{
==============================================================================
=
=       V I S U A L I Z I N G
=
==============================================================================
}


const
  BgChr = '.';
  SushiChr = '@';
  SnakeHeadChr = 'S';
  SnakeTailChr = '#';


procedure DrawChar(
  Col, Row : Byte;
  C : Char
);

begin
  GotoXY(Col, Row);
  Write(C);
end;



procedure DrawGrid;

var
  Row, Col : Byte;

begin
  ClrScr;
  for Row := 1 to GridHeight do
    for Col := 1 to GridWidth do
      DrawChar(Col, Row, BgChr);
end;



{
==============================================================================
=
=       P A R S I N G
=
==============================================================================
}


procedure InpToMoves(
  var Moves : PMovementArr
);

var
  MoveIdx : Word;

begin
  for MoveIdx := 1 to NumMovements do
    Moves^[MoveIdx] := ReadInpChar;
end;



procedure InpToSushis(
  var Sushis : TLnkLst
);

var
  CoordStr : String;
  Sushi : PLongCoords;

begin
  repeat
    CoordStr := ReadInpStr;
  until CoordStr <> '';
  AppendToLnkLst(Sushis, StrToPLongCoords(CoordStr));
  while not InpEof do
    AppendToLnkLst(Sushis, StrToPLongCoords(ReadInpStr));
end;



procedure ParseInput(
  Meta : TMetadata;
  var Moves : PMovementArr;
  var Sushis : TLnkLst { of PLongCoords }
);

begin
  OpenInput(Meta, 1);
  InpToMoves(Moves);
  InpToSushis(Sushis);
  CloseInput;
end;



{
==============================================================================
=
=       P A R T   1
=
==============================================================================
}



function SolvePt1(
  Moves : PMovementArr;
  Sushis : TLnkLst
) : String;

var
  AnsPt1 : LongInt;
  MoveIdx : Word;
  Snake, Sushi : PLongCoords;
  _ : Char;


begin
{  DrawGrid;}

  New(Snake);
  Snake^.X := 0;
  Snake^.Y := 0;
  AnsPt1 := 0;
  IterReset(Sushis);
  Sushi := IterNext(Sushis);
  for MoveIdx := 1 to (NumMovements div 2) do
  begin

{    DrawChar(Snake^.X + 1, Snake^.Y + 1, SnakeHeadChr);
    DrawChar(Sushi^.X + 1, Sushi^.Y + 1, SushiChr);
    Delay(100);
    DrawChar(Snake^.X + 1, Snake^.Y + 1, BgChr);
    DrawChar(Sushi^.X + 1, Sushi^.Y + 1, BgChr);}



    case Moves^[MoveIdx] of
      '^': Translate(Snake^, Translations[Up], Snake^);
      '>': Translate(Snake^, Translations[Rt], Snake^);
      'v': Translate(Snake^, Translations[Dn], Snake^);
      '<': Translate(Snake^, Translations[Lt], Snake^);
    end;
    if LongCoordsEqual(Snake, Sushi) then
    begin
      Sushi := IterNext(Sushis);
      Inc(AnsPt1);
    end;
  end;
  Dispose(Snake);
  SolvePt1 := IntToStr(AnsPt1);
end;


{
==============================================================================
=
=       P A R T   2
=
==============================================================================
}



function GetSnakeHead(
  Snake : TLnkLst
) : PLongCoords;

begin
  GetSnakeHead := Snake.Head^.Data;
end;



procedure RemoveSnakeTail(
  var Snake : TLnkLst
);

var
  Node : TNodePtr;

begin
  if LnkLstIsEmpty(Snake) then
    Exit;

  Node := Snake.Head;

  if Node = Snake.Tail then
  begin
    DestroyLongCoords(Node^.Data);
    Dispose(Node);
    Snake.Head := nil;
    Snake.Tail := nil;
    Exit;
  end;

  while Node^.Next <> Snake.Tail do
    Node := Node^.Next;
  DestroyLongCoords(Snake.Tail^.Data);
  Dispose(Snake.Tail);
  Snake.Tail := Node;
  Snake.Tail^.Next := nil;
end;



function SnakeContains(
  Snake : TLnkLst;
  Coords : PLongCoords
) : Boolean;

var
  Node : TNodePtr;
  SnakePart : PLongCoords;

begin
  Node := Snake.Head;
  while Node <> Snake.Tail do
  begin
    SnakePart := Node^.Data;
    if LongCoordsEqual(SnakePart, Coords) then
    begin
      SnakeContains := true;
      Exit;
    end;
    Node := Node^.Next;
  end;
  SnakeContains := false;
end;



function SnakeLength(
  Snake : TLnkLst
) : LongInt;

var
  Ans : LongInt;
  Node : TNodePtr;

begin
  Node := Snake.Head;
  Ans := 0;
  while Node <> nil do
  begin
    Node := Node^.Next;
    Inc(Ans);
  end;
  SnakeLength := Ans;
end;



procedure PrintSnake(
  Snake : TLnkLst
);

var
  Node : TNodePtr;
  Coords : PLongCoords;

begin
  Node := Snake.Head;
  while Node <> nil do
  begin
    Coords := Node^.Data;
    Write(Coords^.X, ',', Coords^.Y, '; ');
    Node := Node^.Next;
  end;
  Writeln;
end;



procedure DrawSnake(
  Snake : TLnkLst;
  C : Char
);

var
  Node : TNodePtr;
  Coords : PLongCoords;

begin
  Node := Snake.Head;
  while Node <> nil do
  begin
    Coords := Node^.Data;
    DrawChar(Coords^.X + 1, Coords^.Y + 1, C);
    Node := Node^.Next;
  end;
end;



function SolvePt2(
  Moves : PMovementArr;
  Sushis : TLnkLst
) : String;

var
  MoveIdx : Word;
  Snake : TLnkLst;
  Sushi, NextPos : PLongCoords;
_ : Char;

begin
{  DrawGrid;}
  CreateLnkLst(Snake);

  New(NextPos);
  NextPos^.X := 0;
  NextPos^.Y := 0;
  AppendToLnkLst(Snake, NextPos);

  MoveIdx := 1;
  IterReset(Sushis);
  Sushi := IterNext(Sushis);
  while true do
  begin


{    DrawChar(Sushi^.X + 1, Sushi^.Y + 1, SushiChr);
    DrawSnake(Snake, SnakeTailChr);
    Delay(100);
    DrawChar(Sushi^.X + 1, Sushi^.Y + 1, BgChr);
    DrawSnake(Snake, BgChr);}


    New(NextPos);
    case Moves^[MoveIdx] of
      '^': Translate(GetSnakeHead(Snake)^, Translations[Up], NextPos^);
      '>': Translate(GetSnakeHead(Snake)^, Translations[Rt], NextPos^);
      'v': Translate(GetSnakeHead(Snake)^, Translations[Dn], NextPos^);
      '<': Translate(GetSnakeHead(Snake)^, Translations[Lt], NextPos^);
    end;
    Inc(MoveIdx);

    if SnakeContains(Snake, NextPos) then
    begin
      SolvePt2 := IntToStr(SnakeLength(Snake));
      Exit;
    end;
    PushToLnkLst(Snake, NextPos);
    if LongCoordsEqual(NextPos, Sushi) then
      Sushi := IterNext(Sushis)
    else
      RemoveSnakeTail(Snake);
  end;
  DestroyLnkLst(Snake, DestroyLongCoords);
end;



procedure CutSnake(
  var Snake : TLnkLst;
  NextPos : PLongCoords
);

var
  OtherSnakeHead : TNodePtr;
  ThisSnakeTail : TNodePtr;
  Coords : PLongCoords;
  OtherSnake : TLnkLst;

begin
  OtherSnakeHead := Snake.Head;
  Coords := OtherSnakeHead^.Data;
  while not LongCoordsEqual(NextPos, Coords) do
  begin
    OtherSnakeHead := OtherSnakeHead^.Next;
    Coords := OtherSnakeHead^.Data;
  end;

  ThisSnakeTail := Snake.Head;
  while ThisSnakeTail^.Next <> OtherSnakeHead do
    ThisSnakeTail := ThisSnakeTail^.Next;

  OtherSnake.Head := OtherSnakeHead;
  Snake.Tail := ThisSnakeTail;
  Snake.Tail^.Next := nil;

  DestroyLnkLst(OtherSnake, DestroyLongCoords);

end;



function SolvePt3(
  Moves : PMovementArr;
  Sushis : TLnkLst
) : String;

var
  MoveIdx, NumCollisions : Word;
  Snake : TLnkLst;
  Sushi, NextPos : PLongCoords;
_ : Char;

begin
{  DrawGrid;}
  CreateLnkLst(Snake);

  New(NextPos);
  NextPos^.X := 0;
  NextPos^.Y := 0;
  AppendToLnkLst(Snake, NextPos);


  IterReset(Sushis);
  Sushi := IterNext(Sushis);
  NumCollisions := 0;
  for MoveIdx := 1 to NumMovements do
  begin


{    DrawChar(Sushi^.X + 1, Sushi^.Y + 1, SushiChr);
    DrawSnake(Snake, SnakeTailChr);
    DrawChar(GetSnakeHead(Snake)^.X + 1, GetSnakeHead(Snake)^.Y + 1, SnakeHeadChr);

    Delay(100);
    DrawChar(Sushi^.X + 1, Sushi^.Y + 1, BgChr);
    DrawSnake(Snake, BgChr);}


    New(NextPos);
    case Moves^[MoveIdx] of
      '^': Translate(GetSnakeHead(Snake)^, Translations[Up], NextPos^);
      '>': Translate(GetSnakeHead(Snake)^, Translations[Rt], NextPos^);
      'v': Translate(GetSnakeHead(Snake)^, Translations[Dn], NextPos^);
      '<': Translate(GetSnakeHead(Snake)^, Translations[Lt], NextPos^);
    end;

    if SnakeContains(Snake, NextPos) then
    begin
      CutSnake(Snake, NextPos);
      Inc(NumCollisions);
    end;
    PushToLnkLst(Snake, NextPos);
    if LongCoordsEqual(NextPos, Sushi) then
      if IterEndOfLst(Sushis) then
        Sushi^.X := 99
      else
        Sushi := IterNext(Sushis)
    else
      RemoveSnakeTail(Snake);
  end;
  SolvePt3 := IntToStr(SnakeLength(Snake) * NumCollisions);
  DestroyLnkLst(Snake, DestroyLongCoords);
end;





var
  Meta : TMetaData;
  Moves : PMovementArr;
  Snake : PLongCoords;
  Sushis : TLnkLst;


begin
  Meta.Id := 'FF__2607';
  ReadMetadata(Meta);
  LogStart(Meta);

  New(Moves);
  CreateLnkLst(Sushis);
  ParseInput(Meta, Moves, Sushis);

  LogAnswer(Meta, 1, SolvePt1(Moves, Sushis));
  LogAnswer(Meta, 2, SolvePt2(Moves, Sushis));
  LogAnswer(Meta, 3, SolvePt3(Moves, Sushis));

  Dispose(Moves);
  DestroyLnkLst(Sushis, DestroyLongCoords);

end.
