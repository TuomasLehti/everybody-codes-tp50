{
  Tests for the Structs unit.
}
{$F+}

unit StructsT;


interface


uses
  Testing, Structs, Strs;



implementation



function Test_CreateLnkLst(
  Test : TTestPtr
) : Boolean;

var
  LnkLst : TLnkLst;
  Res : Boolean;

begin
  CreateLnkLst(LnkLst);
  Res := (LnkLst.Head = nil) and (LnkLst.Tail = nil);
  if not Res then
    Test^.ErrorMsg := 'Linked list not initialized properly';
  Test_CreateLnkLst := Res;
end;




function Test_LnkLstIsEmpty(
  Test : TTestPtr
) : Boolean;

var
  LnkLst : TLnkLst;
  Res : Boolean;

begin
  CreateLnkLst(LnkLst);
  Res := LnkLstIsEmpty(LnkLst);
  if not Res then
    Test^.ErrorMsg := 'Newly created linked list is not empty';
  Test_LnkLstIsEmpty := Res;
end;



type
  LongIntPtr = ^LongInt;



procedure LongIntPtrDestroyer(
  var Ptr : Pointer
);

var
  Num : LongIntPtr;

begin
  Num := Ptr;
  Dispose(Num);
end;



function Test_LnkLstAppendPop(
  Test : TTestPtr
) : Boolean;

const
  Nums : array[1..5] of LongInt = (1, 2, 3, 5, 8);

var
  LnkLst : TLnkLst;
  I : Byte;
  Num : LongIntPtr;
  Res : Boolean;
  StartMemAvail : LongInt;

begin
  StartMemAvail := MemAvail;

  CreateLnkLst(LnkLst);

  for I := 1 to 5 do
  begin
    New(Num);
    Num^ := Nums[I];
    AppendToLnkLst(LnkLst, Num);
  end;

  Num := nil;

  for I := 1 to 5 do
  begin
    Num := PopFromLnkLst(LnkLst);
    if Num^ <> Nums[I] then
    begin
    Test_LnkLstAppendPop := false;
      Test^.ErrorMsg :=
        'Value at index '
        + IntToStr(I)
        + ' not '
        + IntToStr(Nums[I])
        + '.';
      Exit;
    end;
    Dispose(Num);
  end;

  if MemAvail <> StartMemAvail then
  begin
    Test_LnkLstAppendPop := false;
    Test^.ErrorMsg := 'Memory leak';
    Exit;
  end;

  Test_LnkLstAppendPop := true;

end;



function Test_LnkLstPushPop(
  Test : TTestPtr
) : Boolean;

const
  Nums : array[1..5] of LongInt = (1, 2, 3, 5, 8);

var
  LnkLst : TLnkLst;
  I : Byte;
  Num : LongIntPtr;
  Res : Boolean;
  StartMemAvail : LongInt;

begin
  StartMemAvail := MemAvail;

  CreateLnkLst(LnkLst);

  for I := 1 to 5 do
  begin
    New(Num);
    Num^ := Nums[I];
    PushToLnkLst(LnkLst, Num);
  end;

  Num := nil;

  for I := 5 downto 1 do
  begin
    Num := PopFromLnkLst(LnkLst);
    if Num^ <> Nums[I] then
    begin
    Test_LnkLstPushPop := false;
      Test^.ErrorMsg :=
        'Value at index '
        + IntToStr(I)
        + ' not '
        + IntToStr(Nums[I])
        + '.';
      Exit;
    end;
    Dispose(Num);
  end;

  if MemAvail <> StartMemAvail then
  begin
    Test_LnkLstPushPop := false;
    Test^.ErrorMsg := 'Memory leak';
    Exit;
  end;

  Test_LnkLstPushPop := true;
end;



function Test_LnkLstPop_LastNode(
  Test : TTestPtr
) : Boolean;

var
  LnkLst : TLnkLst;
  Num : LongIntPtr;

begin
  CreateLnkLst(LnkLst);
  New(Num);
  Num^ := 84;
  AppendToLnkLst(LnkLst, Num);
  New(Num);
  Num^ := 42;
  AppendToLnkLst(LnkLst, Num);

  Num := PopFromLnkLst(LnkLst);
  Dispose(Num);
  Num := PopFromLnkLst(LnkLst);
  Dispose(Num);

  if not LnkLstIsEmpty(LnkLst) then
  begin
    Test_LnkLstPop_LastNode := false;
    Test^.ErrorMsg := 'List not marked as empty after last node is popped.';
    Exit;
  end;

  Test_LnkLstPop_LastNode := true

end;



function Test_LnkLstDestroy(
  Test : TTestPtr
) : Boolean;

const
  Nums : array[1..5] of LongInt = (1, 2, 3, 5, 8);

var
  LnkLst : TLnkLst;
  I : Byte;
  Num : LongIntPtr;
  Res : Boolean;
  StartMemAvail : LongInt;

begin
  StartMemAvail := MemAvail;

  CreateLnkLst(LnkLst);

  for I := 1 to 5 do
  begin
    New(Num);
    Num^ := Nums[I];
    PushToLnkLst(LnkLst, Num);
  end;

  DestroyLnkLst(LnkLst, LongIntPtrDestroyer);

  if not LnkLstIsEmpty(LnkLst) then
  begin
    Test_LnkLstDestroy := false;
    Test^.ErrorMsg := 'Doesn''t return to an empty state.';
    Exit;
  end;

  if MemAvail <> StartMemAvail then
  begin
    Test_LnkLstDestroy := false;
    Test^.ErrorMsg := 'Memory leak';
    Exit;
  end;

  Test_LnkLstDestroy := true;
end;



function Test_LnkLstIter_AtEndAtStart(
  Test : TTestPtr
) : Boolean;

var
  Lst : TLnkLst;

begin
  CreateLnkLst(Lst);
  if not IterEndOfLst(Lst) then
  begin
    Test_LnkLstIter_AtEndAtStart := false;
    Test^.ErrorMsg := 'Not at end at start.';
  end;
  Test_LnkLstIter_AtEndAtStart := true;
end;



function Test_LnkLstIter_AtStartAfterFirstPush(
  Test : TTestPtr
) : Boolean;

var
  Lst : TLnkLst;
  Num : LongIntPtr;

begin
  Test^.ErrorMsg := '';
  CreateLnkLst(Lst);
  New(Num);
  Num^ := 42;
  PushToLnkLst(Lst, Num);

  if Lst.Iter <> Lst.Head then
  begin
    Test^.ErrorMsg := 'Not at start after first push.';
  end;

  DestroyLnkLst(Lst, LongIntPtrDestroyer);
  Test_LnkLstIter_AtStartAfterFirstPush := Test^.ErrorMsg = '';
end;



function Test_LnkLstIter_AtStartAfterFirstAppend(
  Test : TTestPtr
) : Boolean;

var
  Lst : TLnkLst;
  Num : LongIntPtr;

begin
  Test^.ErrorMsg := '';
  CreateLnkLst(Lst);
  New(Num);
  Num^ := 42;
  AppendToLnkLst(Lst, Num);

  if Lst.Iter <> Lst.Head then
  begin
    Test^.ErrorMsg := 'Not at start after first append.';
  end;

  DestroyLnkLst(Lst, LongIntPtrDestroyer);
  Test_LnkLstIter_AtStartAfterFirstAppend := Test^.ErrorMsg = '';
end;



function Test_LnkLstIter_IteratesCorrectly(
  Test : TTestPtr
) : Boolean;

const
  Nums : array[1..5] of LongInt = (1, 2, 3, 5, 8);


var
  Lst : TLnkLst;
  I : Byte;
  Num : LongIntPtr;

begin
  CreateLnkLst(Lst);
  for I := 1 to 5 do
  begin
    New(Num);
    Num^ := Nums[I];
    AppendToLnkLst(Lst, Num);
  end;

  for I := 1 to 5 do
  begin
    Num := IterNext(Lst);
    if Num^ <> Nums[I] then
    begin
    Test_LnkLstIter_IteratesCorrectly := false;
      Test^.ErrorMsg :=
        'Value at index '
        + IntToStr(I)
        + ' not '
        + IntToStr(Nums[I])
        + '.';
      Exit;
    end;
  end;

  if not IterEndOfLst(Lst) then
  begin
    Test_LnkLstIter_IteratesCorrectly := false;
    Test^.ErrorMsg := 'Did not reach the end of the list.';
    Exit;
  end;

  DestroyLnkLst(Lst, LongIntPtrDestroyer);
  Test_LnkLstIter_IteratesCorrectly := true;
end;


procedure Register_LnkLstTests;

begin
  RegisterTest(CreateTest(
    'Structs', 'LnkLst', 'CreateLnkLst',
    Test_CreateLnkLst
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst', 'LnkLstIsEmpty',
    Test_LnkLstIsEmpty
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst', 'Append & Pop',
    Test_LnkLstAppendPop
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst', 'Push & Pop',
    Test_LnkLstPushPop
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst', 'Pop last node',
    Test_LnkLstPop_LastNode
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst', 'DestroyLnkLst',
    Test_LnkLstDestroy
  ));
end;



procedure Register_LnkLstIterTests;

begin
  RegisterTest(CreateTest(
    'Structs', 'LnkLst.Iterator', 'Starts at end of list',
    Test_LnkLstIter_AtEndAtStart
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst.Iterator', 'At start after first push',
    Test_LnkLstIter_AtStartAfterFirstPush
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst.Iterator', 'At start after first append',
    Test_LnkLstIter_AtStartAfterFirstAppend
  ));
  RegisterTest(CreateTest(
    'Structs', 'LnkLst.Iterator', 'Iterates correctly',
    Test_LnkLstIter_IteratesCorrectly
  ));
end;


begin
  Register_LnkLstTests;
  Register_LnkLstIterTests;
end.