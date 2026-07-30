{@
------------------------------------------------------------------------
Ff__2605 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2026, fifth puzzle.

Usage

  FF__2605

See

  https://flipflop.slome.org/2026/5
}


program Ff__2605;



uses
  Crt, Strs, Logging, Metadata, Structs;



const
  GridWidth = 50;
  GridHeight = 50;



type
  TGrid = array[1..GridWidth, 1..GridHeight] of Char;



procedure InpToGrid(
  Meta : TMetaData;
  var Grid : TGrid
);

var
  Str : String;
  Row, Col : Byte;

begin
  OpenInput(Meta, 1);
  for Row := 1 to GridHeight do
  begin
    Str := ReadInpStr;
    for Col := 1 to GridWidth do
      Grid[Col, Row] := Str[Col];
  end;
  CloseInput;
end;



procedure CopyGrid(
  Src : TGrid;
  var Dest : TGrid
);

var
  Row, Col : Byte;

begin
  for Row := 1 to GridHeight do
    for Col := 1 to GridWidth do
      Dest[Col, Row] := Src[Col, Row];
end;


function IsVisited(
  Grid : TGrid;
  Col, Row : Byte
) : Boolean;

begin
  IsVisited :=
    (Grid[Col, Row] = 'U')
    or (Grid[Col, Row] = 'R')
    or (Grid[Col, Row] = 'D')
    or (Grid[Col, Row] = 'L');
end;



procedure Visit(
  var Grid : TGrid;
  Col, Row : Byte
);

begin
  case Grid[Col, Row] of
    '^': Grid[Col, Row] := 'U';
    '>': Grid[Col, Row] := 'R';
    'v': Grid[Col, Row] := 'D';
    '<': Grid[Col, Row] := 'L';
  end;
end;



function SolvePt1(
  var Grid : TGrid
) : LongInt;

var
  Res : LongInt;
  Row, Col, NextRow, NextCol : Byte;
  Dir : Char;

begin
  Row := 1;
  Col := 1;
  while not IsVisited(Grid, Col, Row) do
  begin
    NextRow := Row;
    NextCol := Col;
    case Grid[Col, Row] of
      '^': NextRow := Row - 1;
      '>': NextCol := Col + 1;
      'v': NextRow := Row + 1;
      '<': NextCol := Col - 1;
    end;
    Visit(Grid, Col, Row);
    Col := NextCol;
    Row := NextRow;
  end;
  Res := 0;
  for Row := 1 to GridHeight do
    for Col := 1 to GridWidth do
      if IsVisited(Grid, Col, Row) then
        Inc(Res);
  SolvePt1 := Res;
end;



function Count(
  Grid : TGrid
) : LongInt;

var
  Res : LongInt;
  Col, Row : Byte;

begin
  Res := 0;
  for Row := 1 to GridHeight do
    for Col := 1 to GridWidth do
      if IsVisited(Grid, Col, Row) then
        Inc(Res);
  Count := Res;
end;



procedure Print(
  Grid : TGrid
);

var
  Col, Row : Byte;
  C : Char;

begin
{  ClrScr;}
  for Row := 1 to GridHeight do
  begin
    for Col := 1 to GridWidth do
      Write(Grid[Col, Row]);
    if Row < 50 then
      Writeln;
  end;
  C := ReadKey;
end;



function WalkerPt3(
  Orig : TGrid;
  var Grid : TGrid
) : LongInt;

var
  Res : LongInt;
  Row, Col, NextRow, NextCol : Byte;
  NumRightTurns : Byte;

begin
  NumRightTurns := 0;
  Row := 1;
  Col := 1;
  NextRow := 1;
  NextCol := 1;
  while NumRightTurns < 4 do
  begin
{    Print(Grid);}
    if IsVisited(Grid, Col, Row) then
    begin
{      Print(Grid);}
      if (Row = 1) or (Col = 1) or (Row = GridHeight) or (Col = GridWidth) then
      begin
        WalkerPt3 := Count(Grid);
        Exit;
      end;
      Inc(NumRightTurns);
      if NumRightTurns > 3 then
      begin
        WalkerPt3 := Count(Grid);
        Exit;
      end;
      case Orig[Col, Row] of
        '^': Grid[Col, Row] := '>';
        '>': Grid[Col, Row] := 'v';
        'v': Grid[Col, Row] := '<';
        '<': Grid[Col, Row] := '^';
      end;
    end;
    case Grid[Col, Row] of
      '^': NextRow := Row - 1;
      '>': NextCol := Col + 1;
      'v': NextRow := Row + 1;
      '<': NextCol := Col - 1;
    end;
    Visit(Grid, Col, Row);
    Col := NextCol;
    Row := NextRow;
{    if Keypressed then Halt;}
  end;
  WalkerPt3 := Count(Grid);
end;



function SolvePt2(
  Grid : TGrid
) : LongInt;

var
  Res : LongInt;
  Row, Col : Byte;
  Dir : Char;
  Max : LongInt;
  Orig, Solved : TGrid;

begin
  CopyGrid(Grid, Solved);
  CopyGrid(Grid, Orig);
  Max := SolvePt1(Solved);
  Writeln;

  for Row := 2 to GridHeight - 1 do
    for Col := 2 to GridWidth - 1 do
      if IsVisited(Solved, Col, Row) then
      begin
{        Write(#13, Col, ',', Row);}
        CopyGrid(Orig, Grid);
        Dir := Grid[Col, Row];

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := '^';
        Res := SolvePt1(Grid);
        if Res > Max then
        begin
          Max := Res;
          Writeln(Col, ',', Row, ',^,', Max);
        end;

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := '>';
        Res := SolvePt1(Grid);
        if Res > Max then
        begin
          Max := Res;
          Writeln(Col, ',', Row, ',>,', Max);
        end;

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := 'v';
        Res := SolvePt1(Grid);
        if Res > Max then
        begin
          Max := Res;
          Writeln(Col, ',', Row, ',v,', Max);
        end;

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := '<';
        Res := SolvePt1(Grid);
        if Res > Max then
        begin
          Max := Res;
          Writeln(Col, ',', Row, ',<,', Max);
        end;

      end;
  SolvePt2 := Max;
  Writeln;
end;



function SolvePt3(
  Grid : TGrid
) : LongInt;

var
  Res : LongInt;
  Row, Col : Byte;
  Max : LongInt;
  Orig, Solved : TGrid;

begin
  CopyGrid(Grid, Solved);
  CopyGrid(Grid, Orig);
  Max := WalkerPt3(Orig, Solved);
  Max := 0;
  for Row := 2 to GridHeight - 1 do
    for Col := 2 to GridWidth - 1 do
      if IsVisited(Solved, Col, Row) then
      begin
        Write(Col, ' ', Row, #13);

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := '^';
        Res := WalkerPt3(Orig, Grid);
        if Res > Max then
        begin
          Max := Res;
        end;

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := '>';
        Res := WalkerPt3(Orig, Grid);
        if Res > Max then
        begin
          Max := Res;
        end;

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := 'v';
        Res := WalkerPt3(Orig, Grid);
        if Res > Max then
        begin
          Max := Res;
        end;

        CopyGrid(Orig, Grid);
        Grid[Col, Row] := '<';
        Res := WalkerPt3(Orig, Grid);
        if Res > Max then
        begin
          Max := Res;
        end;

        if Res > Max then Max := Res;
      end;
  SolvePt3 := Max;
end;





var
  Meta : TMetaData;
  Orig, Grid : TGrid;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;


begin
  Meta.Id := 'FF__2605';
  ReadMetadata(Meta);
  LogStart(Meta);

  InpToGrid(Meta, Orig);

  CopyGrid(Orig, Grid);
{  Writeln(WalkerPt3(Grid));}
{  Print(Grid);}
{  Halt;}

{  CopyGrid(Orig, Grid);
  Grid[6, 2] := '^';
  Writeln('6,2: ', WalkerPt3(Grid), ' (62)');

  CopyGrid(Orig, Grid);
  Grid[7, 2] := '^';
  Writeln('7,2: ', WalkerPt3(Grid), ' (62)');

  CopyGrid(Orig, Grid);
  Grid[8, 1] := '^';
  Writeln('8,1: ', WalkerPt3(Grid), ' (63)');

  CopyGrid(Orig, Grid);
  Grid[8, 1] := '<';
  Writeln('8,1: ', WalkerPt3(Grid), ' (63)');

  CopyGrid(Orig, Grid);
  Grid[9, 1] := '>';
  Writeln('9,1: ', WalkerPt3(Grid), '(64)');

  CopyGrid(Orig, Grid);
  Grid[6, 6] := '>';
  Writeln('6,6: ', WalkerPt3(Grid), '(65)');

  CopyGrid(Orig, Grid);
  Grid[7, 6] := '>';
  Writeln('7,6: ', WalkerPt3(Grid), '(66)'); }




{  Print(Orig);
  Halt;}

  CopyGrid(Orig, Grid);
  LogAnswer(Meta, 1, IntToStr(SolvePt1(Grid)));

  CopyGrid(Orig, Grid);
{  LogAnswer(Meta, 2, IntToStr(SolvePt2(Grid)));}

  CopyGrid(Orig, Grid);

  LogAnswer(Meta, 3, IntToStr(SolvePt3(Grid)));

end.
