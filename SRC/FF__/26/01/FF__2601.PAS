{@
------------------------------------------------------------------------
Ff__2601 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2026, first puzzle.

Usage

  FF__2601

See

  https://flipflop.slome.org/2026/1
}


program Ff__2601;



uses
  Strs, Logging, Metadata, Structs;



var
  Meta : TMetaData;



type
  PLongInt = ^LongInt;


{$F+}
procedure DestroyLongIntNode(
  var P : Pointer
);

begin
  Dispose(PLongInt(P));
end;
{$F-}



procedure InputToLongIntLst(
  var Lst : TLnkLst { of PLongInt }
);

var
  Int : PLongInt;

begin
  OpenInput(Meta, 1);
  while not InpEof do
  begin
    New(Int);
    Int^ := StrToInt(ReadInPStr);
    AppendToLnkLst(Lst, Int);
  end;
  CloseInput;
end;



function SolvePart1(
  Coffee : TLnkLst { of PLongInt }
) : LongInt;

var
  Acc : LongInt;
  Temperature : PLongInt;

begin
  IterReset(Coffee);
  Acc := 0;
  while not IterEndOfLst(Coffee) do
  begin
    Temperature := IterNext(Coffee);
    if Temperature^ < 60 then
      Acc := Acc + 60 - Temperature^;
  end;
  SolvePart1 := Acc;
end;



function SolvePart2(
  Coffee : TLnkLst { of PLongInt }
) : LongInt;

var
  Acc : LongInt;
  Temperature : PLongInt;

begin
  IterReset(Coffee);
  Acc := 0;
  while not IterEndOfLst(Coffee) do
  begin
   Temperature := IterNext(Coffee);
    if Temperature^ < 60 then
      Acc := Acc + 60 - Temperature^
    else if Temperature^ > 60 then
      Acc := Acc + (Temperature^ - 60) * 5;
  end;
  SolvePart2 := Acc;
end;



function SolvePart3(
  Coffee : TLnkLst { of PLongInt }
) : LongInt;

  function LnkLstLen(Lst : TLnkLst) : Word;
  var
    L : Word;
    Tmp : PLongInt;
  begin
    L := 0;
    IterReset(Lst);
    while not IterEndOfLst(Lst) do
    begin
      Tmp := IterNext(Lst);
      Inc(L);
    end;
    LnkLstLen := L;
  end;

  function LnkLstHalfWayNode(Lst : TLnkLst) : TNodePtr;
  var
    Tmp : TNodePtr;
    Len, Idx : Word;
  begin
    Tmp := Lst.Head;
    Len := LnkLstLen(Lst) div 2;
    for Idx := 1 to Len - 1 do
      Tmp := Tmp^.Next;
    LnkLstHalfWayNode := Tmp;
  end;

  procedure SplitInHalf(var S, E : TLnkLst);
  var
    HalfWay : TNodePtr;
  begin
    HalfWay := LnkLstHalfWayNode(S);
    E.Head := HalfWay^.Next;
    E.Tail := S.Tail;
    S.Tail := HalfWay;
    HalfWay^.Next := nil;
  end;

var
  Targets : TLnkLst;
  Temperature, Target : PLongInt;
  Acc : LongInt;

begin
  CreateLnkLst(Targets);
  SplitInHalf(Coffee, Targets);
  IterReset(Coffee);
  IterReset(Targets);
  Acc := 0;
  while not IterEndOfLst(Coffee) do
  begin
    Temperature := IterNext(Coffee);
    Target := IterNext(Targets);
    if Temperature^ < Target^ then
      Acc := Acc + Target^ - Temperature^
    else if Temperature^ > Target^ then
      Acc := Acc + (Temperature^ - Target^) * 5;
  end;
  DestroyLnkLst(Targets, DestroyLongIntNode);
  SolvePart3 := Acc;
end;



var
  Coffee : TLnkLst; { of PLongInt }



begin
  Meta.Id := 'FF__2601';
  ReadMetadata(Meta);
  LogStart(Meta);

  CreateLnkLst(Coffee);
  InputToLongIntLst(Coffee);

  LogAnswer(Meta, 1, IntToStr(SolvePart1(Coffee)));
  LogAnswer(Meta, 2, IntToStr(SolvePart2(Coffee)));
  LogAnswer(Meta, 3, IntToStr(SolvePart3(Coffee)));

  DestroyLnkLst(Coffee, DestroyLongIntNode);
end.