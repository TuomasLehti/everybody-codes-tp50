{
  Testing for TRect.
}

{$F+}

program RectT;



uses
  Structs, Strs, Testing;


{$I SRC\AOC\2015\06\RECT.PAS}



function Test_RangeOverlap(
  Test : TTestPtr
) : Boolean;

begin
  Test_RangeOverlap :=
    not RangesOverlapping(0, 4, 6, 10)
    and not RangesOverlapping(12, 16, 6, 10)
    and RangesOverlapping(0, 8, 6, 10)
    and RangesOverlapping(8, 16, 6, 10)
    and RangesOverlapping(0, 16, 6, 10)
    and RangesOverlapping(6, 10, 0, 16);
end;



function Test_RangeOverlap_Touching(
  Test : TTestPtr
) : Boolean;

begin
  Test_RangeOverlap_Touching :=
    not RangesOverlapping(0, 4, 5, 10)
    and RangesOverlapping(0, 5, 5, 10)
    and not RangesOverlapping(5, 10, 0, 4)
    and RangesOverlapping(5, 10, 0, 5);
end;



function Test_RangeOverlap_Thin(
  Test : TTestPtr
) : Boolean;

begin
  Test_RangeOverlap_Thin :=
    not RangesOverlapping(4, 4, 5, 10)
    and RangesOverlapping(5, 5, 5, 10)
    and RangesOverlapping(10, 10, 5, 10)
    and not RangesOverlapping(11, 11, 5, 10);
end;



function Test_NotOverlapping(
  Test : TTestPtr
) : Boolean;

const
  One : TRect = ( Lit : false; W : 10; N : 10; E : 20; S : 20 );

  NumOthers = 8;

  Others : array[1..NumOthers] of TRect = (
    ( Lit : false;   W : 0;    N : 0;    E : 5;    S : 5  ),
    ( Lit : false;   W : 10;   N : 0;    E : 20;   S : 5  ),
    ( Lit : false;   W : 25;   N : 0;    E : 30;   S : 5  ),

    ( Lit : false;   W : 0;    N : 10;   E : 5;    S : 20 ),
    ( Lit : false;   W : 25;   N : 10;   E : 30;   S : 20 ),

    ( Lit : false;   W : 0;    N : 25;   E : 5;    S : 30 ),
    ( Lit : false;   W : 10;   N : 25;   E : 20;   S : 30 ),
    ( Lit : false;   W : 25;   N : 25;   E : 30;   S : 30 )
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumOthers do
  begin
    Res := Res and Overlap(One, Others[I]) = false;
    if not Res then
    begin
      Test^.ErrorMsg := 'Error at idx ' + IntToStr(I);
      Test_NotOverlapping := false;
      Exit;
    end;
  end;
  Test_NotOverlapping := true;
end;



function Test_Overlapping(
  Test : TTestPtr
) : Boolean;

const
  One : TRect = ( Lit : false; W : 10; N : 10; E : 20; S : 20 );

  NumOthers = 18;

  Others : array[1..NumOthers] of TRect = (

    { north side }

    ( Lit : false;   W : 0;    N : 0;    E : 15;   S : 15 ),
    ( Lit : false;   W : 0;    N : 0;    E : 25;   S : 15 ),
    ( Lit : false;   W : 15;   N : 0;    E : 25;   S : 15 ),
    ( Lit : false;   W : 11;   N : 0;    E : 19;   S : 15 ),

    { east side }

    ( Lit : false;   W : 15;   N : 0;    E : 25;   S : 15 ),
    ( Lit : false;   W : 15;   N : 0;    E : 25;   S : 25 ),
    ( Lit : false;   W : 15;   N : 15;   E : 25;   S : 25 ),
    ( Lit : false;   W : 15;   N : 11;   E : 25;   S : 19 ),

    { south side }

    ( Lit : false;   W : 0;    N : 15;   E : 15;   S : 25 ),
    ( Lit : false;   W : 0;    N : 15;   E : 25;   S : 25 ),
    ( Lit : false;   W : 15;   N : 15;   E : 25;   S : 25 ),
    ( Lit : false;   W : 11;   N : 15;   E : 19;   S : 25 ),

    { west side }

    ( Lit : false;   W : 0;    N : 0;    E : 15;   S : 15 ),
    ( Lit : false;   W : 0;    N : 0;    E : 15;   S : 25 ),
    ( Lit : false;   W : 0;    N : 15;   E : 15;   S : 25 ),
    ( Lit : false;   W : 0;    N : 11;   E : 15;   S : 19 ),

    { totally outside / inside }

    ( Lit : false;   W : 0;    N : 0;    E : 25;   S : 25 ),
    ( Lit : false;   W : 11;   N : 11;   E : 19;   S : 19 )
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumOthers do
  begin
    Res := Res and Overlap(One, Others[I]);
    if not Res then
    begin
      Test^.ErrorMsg := 'Error at idx ' + IntToStr(I);
      Test_Overlapping := false;
      Exit;
    end;
  end;
  Test_Overlapping := true;
end;



function Test_SplitN(
  Test : TTestPtr
) : Boolean;

var
  Splittee, Splitted : PRect;
  Res : Boolean;

begin
  New(Splittee);

  with Splittee^ do
  begin
    W := 1;
    N := 1;
    E := 100;
    S := 100;
  end;

  SplitN(Splittee, 50, Splitted);

  Res :=

    (Splittee^.W = 1)
    and (Splittee^.N = 50)
    and (Splittee^.E = 100)
    and (Splittee^.S = 100)

    and (Splitted^.W = 1)
    and (Splitted^.N = 1)
    and (Splitted^.E = 100)
    and (Splitted^.S = 49);

  if not Res then
    Test^.ErrorMsg := RectToStr(Splittee^) + ' ' + RectToStr(Splitted^);

  Test_SplitN := Res;

  Dispose(Splittee);
  Dispose(Splitted);

end;


function CreatePRect(W_, N_, E_, S_ : Word) : PRect;

var
  Rect : PRect;

begin
  New(Rect);
  with Rect^ do
  begin
    Lit := false;
    W := W_;
    N := N_;
    E := E_;
    S := S_;
  end;
  CreatePRect := Rect;
end;



function CmpRect(
  Rect : PRect;
  Lit_ : Boolean;
  W_, N_, E_, S_ : Word
) : Boolean;

begin
  with Rect^ do
    CmpRect :=
      (Lit = Lit_)
      and (W = W_) and (N = N_)
      and (E = E_) and (S = S_);
end;



function CmpRects(
  Rect, Other : PRect
) : Boolean;

begin
  with Rect^ do
    CmpRects :=
      (Lit = Other^.Lit)
      and (W = Other^.W) and (N = Other^.N)
      and (E = Other^.E) and (S = Other^.S);
end;



function RectLstContains(
  Rects : TLnkLst;
  Rect : PRect
) : Boolean;

var
  R : PRect;

begin
  IterReset(Rects);
  while not IterEndOfLst(Rects) do
  begin
    R := IterNext(Rects);
    Writeln(RectToStr(R^));
    if CmpRects(Rect, R) then
    begin
      RectLstContains := true;
      Exit;
    end;
  end;
  RectLstContains := false;
end;



function Test_Split(
  Test : TTestPtr
) : Boolean;

var
  Rects : TLnkLst;
  Rect, Inst, I : PRect;

begin
  CreateLnkLst(Rects);

  Rect := CreatePRect(0, 0, 999, 999);
  Inst := CreatePRect(100, 100, 199, 199);

  Split(Rect, on, Inst, Rects);

  WriteLn('rects:');
  while not LnkLstIsEmpty(Rects) do
  begin
    I := PopFromLnkLst(Rects);
    WriteLn(RectToStr(I^));
  end;

  WriteLn('rect:');
  WriteLn(RectToStr(Rect^));


  Dispose(Inst);
  Dispose(Rect);
  DestroyLnkLst(Rects, DestroyRect);
end;



begin
  RegisterTest(CreateTest(
    'Rect', 'RangesOverlapping', '',
    Test_RangeOverlap
  ));
  RegisterTest(CreateTest(
    'Rect', 'RangesOverlapping', 'touching test',
    Test_RangeOverlap_Touching
  ));
  RegisterTest(CreateTest(
    'Rect', 'RangesOverlapping', 'thin test',
    Test_RangeOverlap_Thin
  ));

  RegisterTest(CreateTest(
    'Rect', 'Overlap', 'Not overlapping',
    Test_NotOverlapping
  ));
  RegisterTest(CreateTest(
    'Rect', 'Overlap', 'Overlapping',
    Test_Overlapping
  ));

  RegisterTest(CreateTest(
    'Rect', 'SplitN', 'Splitting',
    Test_SplitN
  ));

  RegisterTest(CreateTest(
    'Rect', 'Split', 'Splitting',
    Test_Split
  ));

  RunAllTests;
end.