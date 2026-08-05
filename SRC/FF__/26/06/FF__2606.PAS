{@
------------------------------------------------------------------------
Ff__2606 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2026, sixth puzzle.

Usage

  FF__2606

See

  https://flipflop.slome.org/2026/6
}


program Ff__2606;



uses
  Strs, Logging, Metadata, Structs, Coords, UInt512;



const
  GridWidth = 200;
  GridHeight = 100;



type
  TGrid = array[1..GridWidth, 1..GridHeight] of Char;
  PGrid = ^TGrid;



procedure InpToGrid(
  Meta : TMetaData;
  var Grid : PGrid
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
      Grid^[Col, Row] := Str[Col];
  end;
  CloseInput;
end;



procedure CopyGrid(
  Src : PGrid;
  var Dest : PGrid
);

var
  Row, Col : Byte;

begin
  for Row := 1 to GridHeight do
    for Col := 1 to GridWidth do
      Dest^[Col, Row] := Src^[Col, Row];
end;



procedure PrintGrid(
  Grid : PGrid
);

var
  Col, Row : Byte;
  C : Char;

begin
  for Row := 1 to GridHeight do
  begin
    for Col := 1 to GridWidth do
      Write(Grid^[Col, Row]);
    Writeln;
  end;
end;



procedure SearchChar(
  Grid : PGrid;
  C : Char;
  var Coords : TLongCoords
);

var
  Col, Row : Byte;

begin
  for Row := 1 to GridHeight do
    for Col := 1 to GridWidth do
      if Grid^[Col, Row] = C then
      begin
        Coords.X := Col;
        Coords.Y := Row;
        Exit;
      end;
  Coords.X := -1;
  Coords.Y := -1;
end;




procedure SearchStart(
  Grid : PGrid;
  var Start : TLongCoords
);

var
  Col, Row : Byte;

begin
  SearchChar(Grid, 'S', Start);
end;



function IsGear(
  Grid : PGrid;
  Coords : TLongCoords
) : Boolean;

begin
  IsGear := Grid^[Coords.X, Coords.Y] = '#';
end;



function InBounds(
  Coords : TLongCoords
) : Boolean;

begin
  InBounds :=
    (Coords.X >= 1)
    and (Coords.Y >= 1)
    and (Coords.X <= GridWidth)
    and (Coords.Y <= GridHeight);
end;


type
  TDir = (Up, Rt, Dn, Lt);

const
  Translations : array[TDir] of TLongCoords = (
    (X:  0; Y: -1),
    (X:  1; Y:  0),
    (X:  0; Y:  1),
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


const
  Cw = #1;
  Ccw = #2;



procedure Rotate(
  var Grid : PGrid
);

var
  Cur, Nbor : PLongCoords;
  Queue : TLnkLst; { of PLongCoords }
  Dir : TDir;

begin
  CreateLnkLst(Queue);

  { Add the start gear to the queue and start the rotation.}
  New(Cur);
  SearchStart(Grid, Cur^);
  Grid^[Cur^.X, Cur^.Y] := Ccw;
  AppendToLnkLst(Queue, Cur);

  while not LnkLstIsEmpty(Queue) do
  begin
    Cur := PopFromLnkLst(Queue);

    for Dir := Up to Lt do
    begin
      New(Nbor);
      Translate(Cur^, Translations[Dir], Nbor^);
      if (InBounds(Nbor^)) and (IsGear(Grid, Nbor^)) then
      begin
        if Grid^[Cur^.X, Cur^.Y] = Ccw then
          Grid^[Nbor^.X, Nbor^.Y] := Cw
        else
          Grid^[Nbor^.X, Nbor^.Y] := Ccw;
        AppendToLnkLst(Queue, Nbor);
      end
      else
        Dispose(Nbor);
    end;

    Dispose(Cur);
  end;
end;


function IsBluetooth(
  var Grid : PGrid;
  Coords : TLongCoords
) : Boolean;

begin
  IsBluetooth :=
    ((Grid^[Coords.X, Coords.Y] >= 'a') and (Grid^[Coords.X, Coords.Y] <= 'z'));
end;



function IsLowerCase(
  C : Char
) : Boolean;

begin
  IsLowerCase := (C > 'a') and (C < 'z');
end;


function LowerCase(
  C : Char
) : Char;

begin
  if IsLowerCase(C) then
    LowerCase := C
  else
    LowerCase :=
      Chr(
        Ord(C) - (Ord('A') - Ord('a'))
      );
end;



procedure SearchOtherBluetooth(
  var Grid : PGrid;
  Bt : TLongCoords;
  var OtherBt : TLongCoords
);

var
  C, CC : Char;

begin
  C := Grid^[Bt.X, Bt.Y];
  SearchChar(Grid, UpCase(C), OtherBt);
end;


function IsGearPt2(
  var Grid : PGrid;
  Coords : TLongCoords
) : Boolean;

begin
  IsGearPt2 := (Grid^[Coords.X, Coords.Y] = '#')
    or (Grid^[Coords.X, Coords.Y] = '3');
end;


procedure RotatePt2(
  var Grid : PGrid
);

var
  Cur, Nbor, BtNbor : PLongCoords;
  Bt : TLongCoords;
  Queue : TLnkLst; { of PLongCoords }
  Dir, BtDir : TDir;

begin
  CreateLnkLst(Queue);

  { Add the start gear to the queue and start the rotation.}
  New(Cur);
  SearchStart(Grid, Cur^);
  Grid^[Cur^.X, Cur^.Y] := Ccw;
  AppendToLnkLst(Queue, Cur);

  while not LnkLstIsEmpty(Queue) do
  begin
    Cur := PopFromLnkLst(Queue);

    for Dir := Up to Lt do
    begin
      New(Nbor);
      Translate(Cur^, Translations[Dir], Nbor^);
      if (InBounds(Nbor^)) then

        if (IsGearPt2(Grid, Nbor^)) then
        begin
          if Grid^[Cur^.X, Cur^.Y] = Ccw then
            Grid^[Nbor^.X, Nbor^.Y] := Cw
          else
            Grid^[Nbor^.X, Nbor^.Y] := Ccw;
          AppendToLnkLst(Queue, Nbor);
        end

        else if (IsBluetooth(Grid, Nbor^)) then
        begin
          SearchOtherBluetooth(Grid, Nbor^, Bt);
{          Writeln(Bt.X, ',', Bt.Y, ':', Grid^[Bt.X, Bt.Y]);}
          for BtDir := Up to Lt do
          begin
            New(BtNbor);
            Translate(Bt, Translations[BtDir], BtNbor^);
{            Writeln('-', BtNbor^.X, ',', BtNbor^.Y, ':', Grid^[BtNbor^.X, BtNbor^.Y]);}
            if IsGearPt2(Grid, BtNbor^) then
            begin
{              Writeln('---');}
              if Grid^[Cur^.X, Cur^.Y] = Ccw then
                Grid^[BtNbor^.X, BtNbor^.Y] := Cw
              else
                Grid^[BtNbor^.X, BtNbor^.Y] := Ccw;
              AppendToLnkLst(Queue, BtNbor);
            end;
          end;
        end

      else
        Dispose(Nbor);
    end;

    Dispose(Cur);
  end;
end;


function LnkLstContains(
  Lst : TLnkLst;
  Coords : PLongCoords
) : Boolean;

var
  OtherCoords : PLongCoords;
  Node : TNodePtr;

begin
  Node := Lst.Head;
  while Node <> nil do
  begin
    OtherCoords := PLongCoords(Node^.Data);
    if (OtherCoords^.X = Coords^.X) and (OtherCoords^.Y = Coords^.Y) then
    begin
      LnkLstContains := true;
      Exit;
    end;
    Node := Node^.Next;
  end;
  LnkLstContains := false;
end;



function FloodFillSize(
  Grid : PGrid;
  Start : TLongCoords
) : Word;

var
  Visited : TLnkLst;
  Current, Candidate : PLongCoords;
  Dir : TDir;
  Size : Word;
  Node : TNodePtr;

begin
  CreateLnkLst(Visited);
  New(Current);
  Current^ := Start;
  AppendToLnkLst(Visited, Current);

  Node := Visited.Head;
  while Node <> nil do
  begin
    Current := Node^.Data;
{    Writeln;
    Writeln;
    Writeln(Current^.X,',',Current^.Y);}
    for Dir := Up to Lt do
    begin
      New(Candidate);
      Translate(Current^, Translations[Dir], Candidate^);
      if InBounds(Candidate^) and IsGearPt2(Grid, Candidate^) then
      begin
{        WriteLn('-',Candidate^.X,',',Candidate^.Y,':',LnkLstContains(Visited,Candidate));}
        if not LnkLstContains(Visited, Candidate) then
          AppendToLnkLst(Visited, Candidate)
        else
          Dispose(Candidate);
      end
      else Dispose(Candidate);
    end;
    Node := Node^.Next;
  end;

  Size := 0;
  while not LnkLstIsEmpty(Visited) do
  begin
    Current := PopFromLnkLst(Visited);
    Dispose(Current);
    Inc(Size);
  end;
  FloodFillSize := Size;
end;



function IsPrime(
  Num : Word
) : Boolean;

var
  Divider : Word;

begin
  for Divider := 2 to Num-1 do
    if (Num mod Divider) = 0 then
    begin
      IsPrime := false;
      Exit;
    end;
  IsPrime := true;
end;



procedure RotatePt3(
  var Grid : PGrid
);

var
  Cur, Nbor, BtNbor : PLongCoords;
  Bt : TLongCoords;
  Queue : TLnkLst; { of PLongCoords }
  Dir, BtDir : TDir;

begin
  CreateLnkLst(Queue);

  { Add the start gear to the queue and start the rotation.}
  New(Cur);
  SearchStart(Grid, Cur^);
  Grid^[Cur^.X, Cur^.Y] := Ccw;
  AppendToLnkLst(Queue, Cur);

  while not LnkLstIsEmpty(Queue) do
  begin
    Cur := PopFromLnkLst(Queue);

    for Dir := Up to Lt do
    begin
      New(Nbor);
      Translate(Cur^, Translations[Dir], Nbor^);
      if (InBounds(Nbor^)) then

        if (IsGearPt2(Grid, Nbor^)) then
        begin
          if Grid^[Cur^.X, Cur^.Y] = Ccw then
            Grid^[Nbor^.X, Nbor^.Y] := Cw
          else
            Grid^[Nbor^.X, Nbor^.Y] := Ccw;
          AppendToLnkLst(Queue, Nbor);
        end

        else if (IsBluetooth(Grid, Nbor^)) then
        begin
          SearchOtherBluetooth(Grid, Nbor^, Bt);
{          Writeln(Bt.X, ',', Bt.Y, ':', Grid^[Bt.X, Bt.Y]);}
          for BtDir := Up to Lt do
          begin
            New(BtNbor);
            Translate(Bt, Translations[BtDir], BtNbor^);
            if (IsGearPt2(Grid, BtNbor^)) and (not IsPrime(FloodFillSize(Grid, BtNbor^))) then
            begin
{              Writeln('---');}
              if Grid^[Cur^.X, Cur^.Y] = Ccw then
                Grid^[BtNbor^.X, BtNbor^.Y] := Cw
              else
                Grid^[BtNbor^.X, BtNbor^.Y] := Ccw;
              AppendToLnkLst(Queue, BtNbor);
            end;
          end;
        end

      else
        Dispose(Nbor);
    end;

    Dispose(Cur);
  end;
end;


type
  TLightStatus = (off, low, high);





function GetLightStatus(
  Grid : PGrid;
  Col, Row : Byte
) : TLightStatus;

begin
  if Col > 1 then
    if Grid^[Col - 1, Row] = Ccw then
    begin
      GetLightStatus := low;
      Exit;
    end
    else if Grid^[Col - 1, Row] = Cw then
    begin
      GetLightStatus := high;
      Exit;
    end;

  if Col < GridWidth then
    if Grid^[Col + 1, Row] = Ccw then
    begin
      GetLightStatus := low;
      Exit;
    end
    else if Grid^[Col + 1, Row] = Cw then
    begin
      GetLightStatus := high;
      Exit;
    end;
                         
  if Row > 1 then
    if Grid^[Col, Row - 1] = Ccw then
    begin
      GetLightStatus := low;
      Exit;
    end
    else if Grid^[Col, Row - 1] = Cw then
    begin
      GetLightStatus := high;
      Exit;
    end;

  if Row < GridHeight then
    if Grid^[Col, Row + 1] = Ccw then
    begin
      GetLightStatus := low;
      Exit;
    end
    else if Grid^[Col, Row + 1] = Cw then
    begin
      GetLightStatus := high;
      Exit;
    end;

  GetLightStatus := off;
end;


function StatusToHex(
  Grid : PGrid
) : String;

var
  Col, Row : Byte;
  U, One, Two : TUInt512;

begin
  ZeroUInt512(U);
  IntToUInt512(2, Two);
  IntTOUInt512(1, One);
  for Row := 1 to GridHeight do
    for Col := 1 to GridWidth do
      if Grid^[Col,Row] = '*' then
      begin
        case GetLightStatus(Grid, Col, Row) of
          high: begin
                  MultUInt512s(U, Two, U);
                  AddUInt512s(U, One, U);
                end;
          low:  begin
                  MultUInt512s(U, Two, U);
                end;
        end;
       end;
  StatusToHex := UInt512ToDecStr(U);
end;


var
  Meta : TMetaData;
  Orig, Grid : PGrid;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;
  Start : TLongCoords;


begin
  New(Orig);
  New(Grid);
  Meta.Id := 'FF__2606';
  ReadMetadata(Meta);
  LogStart(Meta);

  InpToGrid(Meta, Orig);

  CopyGrid(Orig, Grid);
  Rotate(Grid);
  LogAnswer(Meta, 1, StatusToHex(Grid));

  CopyGrid(Orig, Grid);
  RotatePt2(Grid);
{  PrintGrid(Grid);}
  LogAnswer(Meta, 2, StatusToHex(Grid));

  CopyGrid(Orig, Grid);
{  Start.X := 17;
  Start.Y := 3;
  Writeln(FloodFillSize(Grid, Start));
  Halt;}
  RotatePt3(Grid);
{  PrintGrid(Grid);}
  LogAnswer(Meta, 3, StatusToHex(Grid));

  Dispose(Orig);
  Dispose(Grid);

{  LogAnswer(Meta, 2, IntToStr(SolvePt2(Grid)));
  LogAnswer(Meta, 3, IntToStr(SolvePt3(Grid)));}

end.
