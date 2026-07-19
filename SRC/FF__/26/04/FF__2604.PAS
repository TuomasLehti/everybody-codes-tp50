{@
------------------------------------------------------------------------
Ff__2604 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2026, fourth puzzle.

Usage

  FF__2604

See

  https://flipflop.slome.org/2026/4
}


program Ff__2604;



uses
  Strs, Logging, Metadata, Structs;


type
  Str = String[5];
  PString = ^Str;


{$F+}
procedure DestroyPString(
  var Data : Pointer
);

begin
  Dispose(PString(Data));
end;

procedure NopDestroy(
  var Data : Pointer
);

begin
end;
{$F-}


function IsLeftLeaf(
  Row : PString
) : Boolean;

begin
  IsLeftLeaf := Copy(Row^, 1, 2) = 'o-';
end;


function IsRightLeaf(
  Row : PString
) : Boolean;

begin
  IsRightLeaf := Copy(Row^, 4, 2) = '-o';
end;



function IsLeaf(
  Row : PString
) : Boolean;

begin
  IsLeaf := IsLeftLeaf(Row) or IsRightLeaf(Row);
end;



function StalkHasLeaves(
  Stalk : TLnkLst
) : Boolean;

var
  Row : PString;

begin
  IterReset(Stalk);
  while not IterEndOfLst(Stalk) do
  begin
    Row := IterNext(Stalk);
    if IsLeaf(Row) then
    begin
      StalkHasLeaves := true;
      Exit;
    end;
  end;
  StalkHasLeaves := false;
end;


procedure RemoveIter(
  var Stalk : TLnkLst
);

var
  Prev, PrevPrev : TNodePtr;

begin
  Prev := Stalk.Head;
  while (Prev <> nil) and (Prev^.Next <> Stalk.Iter) do
    Prev := Prev^.Next;
  PrevPrev := Stalk.Head;
  while (PrevPrev <> nil) and (PrevPrev^.Next <> Prev) do
    PrevPrev := PrevPrev^.Next;

  DestroyPString(Prev^.Data);
  PrevPrev^.Next := Prev^.Next;
  Dispose(Prev);
  Stalk.Iter := Stalk.Iter^.Next;
end;


procedure PrintStalk(
  Stalk : TLnkLst;
  S : Byte
);

var
  I : TNodePtr;
  P : PString;
  Stack : TLnkLst;
  Tmp : Char;

begin
  CreateLnkLst(Stack);
  I := Stalk.Head;
  while I <> nil do
  begin
    PushToLnkLst(Stack, I^.Data);
    I := I^.Next;
  end;
  IterReset(Stack);
  while not LnkLstIsEmpty(Stack) do
  begin
    P := PopFromLnkLst(Stack);
    Write(P^ : -5);
    if (Stalk.Iter^.Data = P) then
    begin
      Write('  <<');
      if S = 0 then Write('L') else Write('R');
    end;
    Writeln;
  end;
  DestroyLnkLst(Stack, NopDestroy);
end;



var
  Meta : TMetaData;
  Stalk : TLnkLst; { of PString }
  S : PString;
  Height : Word;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;
  CurSide : Byte;
  PrevLeafNode : TNodePtr;


begin
  Meta.Id := 'FF__2604';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);
  CreateLnkLst(Stalk);
  while not InpEof do
  begin
    New(S);
    S^ := ReadInpStr;
    PushToLnkLst(Stalk, S);
  end;
  CloseInput;

  IterReset(Stalk);
  for Height := 0 to 400 do
    S := IterNext(Stalk);

  AnsPt1 := 0;
  while not IterEndOfLst(Stalk) do
  begin
    S := IterNext(Stalk);
    if (Copy(S^, 1, 2) = 'o-') or (Copy(S^, 4, 2) = '-o') then
      Inc(AnsPt1);
  end;

  IterReset(Stalk);
  repeat
    S := IterNext(Stalk);
  until (Copy(S^, 1, 2) = 'o-') or (Copy(S^, 4, 2) = '-o');
  if Copy(S^, 1, 2) = 'o-' then
    CurSide := 0
  else
    CurSide := 1;
  AnsPt2 := 0;
  while not IterEndOfLst(Stalk) do
  begin
    S := IterNext(Stalk);
    if (CurSide = 0) and (Copy(S^, 4, 2) = '-o') then
    begin
      Inc(AnsPt2);
      CurSide := 1;
    end
    else if (CurSide = 1) and (Copy(S^, 1, 2) = 'o-') then
    begin
      Inc(AnsPt2);
      Curside := 0;
    end;
  end;

  AnsPt3 := 0;
  while StalkHasLeaves(Stalk) do
  begin
    IterReset(Stalk);

    repeat
      S := IterNext(Stalk);
    until IsLeaf(S);
    if IsLeftLeaf(S) then
      CurSide := 0
    else
      CurSide := 1;
    RemoveIter(Stalk);

    while not IterEndOfLst(Stalk) do
    begin
      S := IterNext(Stalk);
      if (CurSide = 0) and IsRightLeaf(S) then
      begin
        CurSide := 1;
        RemoveIter(Stalk);
      end
      else if (CurSide = 1) and IsLeftLeaf(S) then
      begin
        Curside := 0;
        RemoveIter(Stalk);
      end;
    end;
    Inc(AnsPt3);
  end;



  DestroyLnkLst(Stalk, DestroyPString);

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
  LogAnswer(Meta, 3, IntToStr(AnsPt3));

end.