{
  ---------------------------------------------------------------------------
  CoordsT - unit
  ---------------------------------------------------------------------------

  Function

    Tests for Coords unit.
}
unit CoordsT;



interface


{$F+}


uses
  Coords, Strs, Testing;


implementation


function TestStrToPLongCoords(
  Test : TTestPtr;
  Str : String;
  ExpX, ExpY : LongInt
) : Boolean;

var
  P : PLongCoords;

begin
  P := StrToPLongCoords(Str);
  if (P^.X <> ExpX) and (P^.Y <> ExpY) then
  begin
    TestStrToPLongCoords := false;
    Test^.ErrorMsg :=
      'Expected ('
      + IntToStr(ExpX) + ',' + IntToStr(ExpY)
      + '), got ('
      + IntToStr(P^.X) + ',' + IntToStr(P^.Y)
      + ').';
  end
  else
  begin
    TestStrToPLongCoords := true;
  end;
  Dispose(P);
end;



function Test_StrToPLongCoords_Origin(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrToPLongCoords_Origin :=
    TestStrToPLongCoords(Test, '0,0', 0, 0)
end;



function Test_StrToPLongCoords_Pos(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrToPLongCoords_Pos :=
    TestStrToPLongCoords(Test, '3,1', 3, 1)
end;



function Test_StrToPLongCoords_Neg(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrToPLongCoords_Neg :=
    TestStrToPLongCoords(Test, '-2,-5', -2, -5)
end;



function TestManhDistOrigin(
  Test : TTestPtr;
  X, Y, ExpDist : LongInt
) : Boolean;

var
  Coords : PLongCoords;

begin
  New(Coords);
  Coords^.X := X;
  Coords^.Y := Y;
  if ManhDistOrigin(Coords) <> ExpDist then
  begin
    TestManhDistOrigin := false;
    Test^.ErrorMsg :=
      'Expected '
      + IntToStr(ExpDist)
      + ', got '
      + IntToStr(ManhDistOrigin(Coords))
      + '.';
  end
  else
  begin
    TestManhDistOrigin := true;
  end;
  Dispose(Coords);
end;



function Test_ManhDistOrigin_FromOrigin(
  Test : TTestPtr
) : Boolean;

begin
  Test_ManhDistOrigin_FromOrigin :=
    TestManhDistOrigin(Test, 0, 0, 0);
end;



function Test_ManhDistOrigin_Pos(
  Test : TTestPtr
) : Boolean;

begin
  Test_ManhDistOrigin_Pos :=
    TestManhDistOrigin(Test, 3, 1, 4);
end;



function Test_ManhDistOrigin_Neg(
  Test : TTestPtr
) : Boolean;

begin
  Test_ManhDistOrigin_Neg :=
    TestManhDistOrigin(Test, -2, -5, 7);
end;



function TestManhDistBetween(
  Test : TTestPtr;
  OneX, OneY, OtherX, OtherY, ExpDist : LongInt
) : Boolean;

var
  One, Other : PLongCoords;

begin
  New(One);
  One^.X := OneX;
  One^.Y := OneY;
  New(Other);
  Other^.X := OtherX;
  Other^.Y := OtherY;
  if ManhDistBetween(One, Other) <> ExpDist then
  begin
    TestManhDistBetween := false;
    Test^.ErrorMsg :=
      'Expected '
      + IntToStr(ExpDist)
      + ', got '
      + IntToStr(ManhDistBetween(One, Other))
      + '.';
  end
  else
  begin
    TestManhDistBetween := true;
  end;
  Dispose(One);
  Dispose(Other);
end;



function Test_ManhDistBetween_PosPos(
  Test : TTestPtr
) : Boolean;

begin
  Test_ManhDistBetween_PosPos :=
    TestManhDistBetween(Test, 3, 1, 4, 2, 2);
end;



function Test_ManhDistBetween_NegNeg(
  Test : TTestPtr
) : Boolean;

begin
  Test_ManhDistBetween_NegNeg:=
    TestManhDistBetween(Test, -3, -1, -4, -2, 2);
end;



function Test_ManhDistBetween_PosNeg(
  Test : TTestPtr
) : Boolean;

begin
  Test_ManhDistBetween_PosNeg :=
    TestManhDistBetween(Test, 5, 1, -5, -1, 12);
end;




begin
  RegisterTest(CreateTest(
    'Coords', 'StrToPLongCoords', 'origin',
    Test_StrToPLongCoords_Origin
  ));
  RegisterTest(CreateTest(
    'Coords', 'StrToPLongCoords', 'positive',
    Test_StrToPLongCoords_Pos
  ));
  RegisterTest(CreateTest(
    'Coords', 'StrToPLongCoords', 'negative',
    Test_StrToPLongCoords_Neg
  ));

  RegisterTest(CreateTest(
    'Coords', 'ManhDistOrigin', 'origin',
    Test_ManhDistOrigin_FromOrigin
  ));
  RegisterTest(CreateTest(
    'Coords', 'ManhDistOrigin', 'positive',
    Test_ManhDistOrigin_Pos
  ));
  RegisterTest(CreateTest(
    'Coords', 'ManhDistOrigin', 'negative',
    Test_ManhDistOrigin_Neg
  ));

  RegisterTest(CreateTest(
    'Coords', 'ManhDistBetween', 'positive and positive',
    Test_ManhDistBetween_PosPos
  ));
  RegisterTest(CreateTest(
    'Coords', 'ManhDistBetween', 'negative and negative',
    Test_ManhDistBetween_NegNeg
  ));
  RegisterTest(CreateTest(
    'Coords', 'ManhDistBetween', 'positive and negative',
    Test_ManhDistBetween_PosNeg
  ));

end.