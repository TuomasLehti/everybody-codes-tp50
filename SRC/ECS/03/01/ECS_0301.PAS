{

  A solver for Everybody Codes, story 3.

  The approach with a linked list is slightly overkill for such a small
  puzzle, but it simplifies the solving procedures, which do not have
  to know the amount of rows in the input.

  The goal in the long run is to separate the linked list logic into a
  separate unit among other common data structures.

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

{
  Each scale is represented as a record. Id is the identifier of the scale
  and R, G, B the color components. S is for the level of shine, which
  is needed in parts 2 and 3.
}

  TScaleRec = record
    Id : LongInt;
    R, G, B, S : Byte;
  end;


{
  Scales are stored in a singly-linked list, because the number of them
  varies between different parts.
}

  PScaleNode = ^TScaleNode;

  TScaleNode = record
    Scale : TScaleRec;
    Next : PScaleNode;
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

  { The group of the color is determined in the process of solving part 3,
    because it is something that is not present in the input and thus not
    a concern of this parsing procedure. }

end;


{
  ---------------------------------------------------------------------------
  InputToScaleList
  ---------------------------------------------------------------------------

  Function

    Reads the scales from the puzzle input and returns the head of a singly
    linked list of scale records.

  Remarks

    The puzzle input must be opened and closed by the calling procedure.
    The linked list must be destroyed by the calling procedure.
}

function InputToScaleList
: PScaleNode;

var
  Head, Tail, Node : PScaleNode;

begin
  Head := nil;
  Tail := nil;
  while not InpEof do
  begin

    { Read a scale and construct a new node. }
    New(Node);
    with Node^ do
    begin
      InputToScale(ReadInpStr, Scale);
      Next := nil;
    end;

    { If the list is empty, set the node as the first node. }
    if Head = nil then
    begin
      Head := Node;
      Tail := node;
    end

    { Otherwise append the node to the end of the list. }
    else
    begin
      Tail^.Next := Node;
      Tail := Node;
    end;

  end;
  InputToScaleList := Head;
end;


{
  ---------------------------------------------------------------------------
  DestroyScaleList
  ---------------------------------------------------------------------------

  Function

    Frees the memory allocated for the singly linked list of scales.
}

procedure DestroyScaleList(
  var Head : PScaleNode
);

var
  Tmp : PScaleNode;

begin
  Tmp := Head;
  while Tmp <> nil do
  begin
    Head := Tmp^.Next;
    Dispose(Tmp);
    Tmp := Head;
  end;
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
  Node, Scales : PScaleNode;

begin
  OpenInput(Meta, 1);
  Scales := InputToScaleList;

  Ans := 0;
  Node := Scales;
  while Node <> nil do
  begin
    with Node^.Scale do
      if (G > R) and (G > B) then
        Ans := Ans + Id;
    Node := Node^.Next;
  end;

  DestroyScaleList(Scales);
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

  function GetMaxShine(Scales : PScaleNode) : Byte;
  var
    Node : PScaleNode;
    MaxShine : Byte;
  begin
    MaxShine := 0;
    Node := Scales;
    while Node <> nil do
    begin
      with Node^.Scale do
        if S > MaxShine then
          MaxShine := S;
      Node := Node^.Next;
    end;
    GetMaxShine := MaxShine;
  end;

  function GetDarkestId(Scales : PScaleNode; MaxShine : Byte) : LongInt;
  var
    Node : PScaleNode;
    MinDarkness : Byte;
    DarkestId : Word;
  begin
    MinDarkness := 255;
    Node := Scales;
    while Node <> nil do
    begin
      with Node^.Scale do
        if S = MaxShine then
          if (R + G + B) < MinDarkness then
          begin
            MinDarkness := R + G + B;
            DarkestId := Id;
          end;
      Node := Node^.Next;
    end;
    GetDarkestId := DarkestId;
  end;

var
  Ans : LongInt;
  MaxShine, MinDarkness : Byte;
  DarkestId : Word;
  Node, Scales : PScaleNode;

begin
  OpenInput(Meta, 2);
  Scales := InputToScaleList;

  { This is done essentially in two passes. }

  SolvePt2 := GetDarkestId(Scales, GetMaxShine(Scales));
  DestroyScaleList(Scales);
  CloseInput;
end;



{
  ---------------------------------------------------------------------------
  SolvePt3
  ---------------------------------------------------------------------------

  Function

    Finds the sum of the ids of the scales in the most numerous color group.

  Parameters

    Meta       The metadata associated with this puzzle.
}

function SolvePt3(
  Meta : TMetadata
) : LongInt;

type
  TColorGroup = (
    none,
    redMatte, redShiny,
    greenMatte, greenShiny,
    blueMatte, blueShiny
  );

  TColGrpArr = array[TColorGroup] of Word;

  function GetColorGrp(Scale : TScaleRec) : TColorGroup;
  var
    Grp : TColorGroup;
  begin
    with Scale do
    begin
      if (R > G) and (R > B) then
        Grp := redMatte
      else if (G > R) and (G > B) then
        Grp := greenMatte
      else if (B > R) and (B > G) then
        Grp := blueMatte
      else
        Grp := none;
      if Grp <> none then
        if S >= 33 then
          if Grp = redMatte then
            Grp := redShiny
          else if Grp = greenMatte then
            Grp := greenShiny
          else
            Grp := blueShiny
        else if S > 30 then
          Grp := none;
    end;
    GetColorGrp := Grp;
  end;

  procedure ClrColGrpSizes(var ColGrpSizes : TColGrpArr);
  var
    Grp : TColorGroup;
  begin
    for Grp := none to blueShiny do
      ColGrpSizes[Grp] := 0;
  end;

  procedure CountColGrps(Scales : PScaleNode; var ColGrpSzs : TColGrpArr);
  var
    Node : PScaleNode;
  begin
    Node := Scales;
    while Node <> nil do
    begin
      Inc(ColGrpSzs[GetColorGrp(Node^.Scale)]);
      Node := Node^.Next;
    end;
  end;

  function GetLargestColGrp(Scales : PScaleNode; GrpSzs : TColGrpArr) : TColorGroup;
  var
    Node : PScaleNode;
    LargestGrpSize : Word;
    Grp, LargestGrp : TColorGroup;
  begin
    LargestGrp := none;
    LargestGrpSize := 0;
    for Grp := none to blueShiny do
      if GrpSzs[Grp] > LargestGrpSize then
      begin
        LargestGrp := Grp;
        LargestGrpSize := GrpSzs[Grp];
      end;
    GetLargestColGrp := LargestGrp;
  end;

  function SumIds(Scales : PScaleNode; Grp : TColorGroup) : LongInt;
  var
    Node : PScaleNode;
    Ans : LongInt;
  begin
    Ans := 0;
    Node := Scales;
    while Node <> nil do
    begin
      if GetColorGrp(Node^.Scale) = Grp then
        Ans := Ans + Node^.Scale.Id;
      Node := Node^.Next;
    end;
    SumIds := Ans;
  end;

var
  Ans : LongInt;
  GroupSizes : TColGrpArr;
  Node, Scales : PScaleNode;

begin
  OpenInput(Meta, 3);
  Scales := InputToScaleList;
  ClrColGrpSizes(GroupSizes);
  CountColGrps(Scales, GroupSizes);
  SolvePt3 := SumIds(
    Scales,
    GetLargestColGrp(Scales, GroupSizes)
  );

  DestroyScaleList(Scales);
  CloseInput;
end;



var
  Meta : TMetadata;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;


begin
  Meta.Id := 'ECS_0301';
  ReadMetadata(Meta);
  LogStart(Meta);
  AnsPt1 := SolvePt1(Meta);
  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  AnsPt2 := SolvePt2(Meta);
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
  AnsPt3 := SolvePt3(Meta);
  LogAnswer(Meta, 3, IntToStr(AnsPt3));

end.