{
  ---------------------------------------------------------------------------
  UInt512T - unit
  ---------------------------------------------------------------------------

  Function

    Tests for the UInt512 unit.
}
unit UInt512T;



{$F+}



interface



uses
  Testing, UInt512, Strs;



implementation



function Test_ZeroUInt512(
  Test : TTestPtr
) : Boolean;

var
  Int : TUint512;
  Idx : Byte;

begin
  ZeroUInt512(Int);
  for Idx := 0 to 63 do
    if Int[Idx] > 0 then
    begin
      Test_ZeroUInt512 := false;
      Test^.ErrorMsg := 'Byte ' + IntToStr(Idx) + ' not zero.';
      Exit;
    end;
  Test_ZeroUInt512 := true;
end;



function Test_IntToUInt512(
  Test : TTestPtr
) : Boolean;

var
  BI : TUint512;
  S : ShortInt;
  B : Byte;
  I : Integer;
  W : Word;
  L : LongInt;
  R : Boolean;

begin
  L := 33554431;
  IntToUInt512(L, BI);
  R := (BI[0] = 255) and (BI[1] = 255) and (BI[2] = 255) and (BI[3] = 1);

  W := 32767;
  IntToUInt512(W, BI);
  R := R and (BI[0] = 255) and (BI[1] = 127) and (BI[2] = 0) and (BI[3] = 0);

  I := 16383;
  IntToUInt512(I, BI);
  R := R and (BI[0] = 255) and (BI[1] = 63) and (BI[2] = 0) and (BI[3] = 0);

  B := 255;
  IntToUInt512(B, BI);
  R := R and (BI[0] = 255) and (BI[1] = 0) and (BI[2] = 0) and (BI[3] = 0);

  S := 127;
  IntToUInt512(S, BI);
  R := R and (BI[0] = 127) and (BI[1] = 0) and (BI[2] = 0) and (BI[3] = 0);

  Test_IntToUInt512 := R;
end;



function Test_AddUInt512s(
  Test : TTestPtr
) : Boolean;

var
  One, Other, Result : TUInt512;
  Idx : Byte;

begin
  for Idx := 0 to 63 do
  begin
    One[Idx] := Idx;
    Other[Idx] := Idx;
  end;
  AddUInt512s(One, Other, Result);
  for Idx := 0 to 63 do
    if Result[Idx] <> Idx * 2 then
    begin
      Test^.ErrorMsg := 'Error at idx ' + IntToStr(Idx);
      Test_AddUInt512s := false;
      Exit;
    end;
  Test_AddUInt512s := true;
end;



function Test_AddUInt512s_Carry(
  Test : TTestPtr
) : Boolean;

var
  One, Other, Result : TUInt512;
  Idx : Byte;

begin
  for Idx := 0 to 62 do
    One[Idx] := 255;
  One[63] := 0;
  ZeroUInt512(Other);
  Other[0] := 1;

  AddUInt512s(One, Other, Result);
  for Idx := 0 to 62 do
    if Result[Idx] <> 0 then
    begin
      Test^.ErrorMsg := 'Error at idx ' + IntToStr(Idx);
      Test_AddUInt512s_Carry := false;
      Exit;
    end;
  if Result[63] <> 1 then
  begin
    Test^.ErrorMsg := 'Error at idx 63.';
    Test_AddUInt512s_Carry := false;
    Exit;
  end;
  Test_AddUInt512s_Carry := true;
end;



function Test_MultUInt512s_Simple(
  Test : TTestPtr
) : Boolean;

var
  One, Other, Result : TUInt512;
  Idx : Byte;

begin
  ZeroUInt512(One);
  ZeroUInt512(Other);
  ZeroUInt512(Result);
  for Idx := 0 to 63 do
    One[Idx] := 2;
  Other[0] := 2;
  MultUInt512s(One, Other, Result);
  for Idx := 0 to 63 do
    if Result[Idx] <> 4 then
    begin
      Test_MultUInt512s_Simple := false;
      Test^.ErrorMsg := 'Error at index ' + IntToStr(Idx);
      Exit;
    end;
  Test_MultUInt512s_Simple := true;
end;



function Test_MultUInt512s_Carry(
  Test : TTestPtr
) : Boolean;

var
  One, Other, Result : TUInt512;

begin
  ZeroUInt512(One);
  ZeroUInt512(Other);
  ZeroUInt512(Result);
  One[0] := 255;
  One[1] := 255;
  Other[0] := 255;
  MultUInt512s(One, Other, Result);
  Test_MultUInt512s_Carry :=
    (Result[0] = 1)
    and (Result[1] = 255)
    and (Result[2] = 254);
end;



function Test_MultUInt512s_TwoDigitCarry(
  Test : TTestPtr
) : Boolean;

var
  One, Other, Result : TUInt512;
  Idx : Byte;

begin
  ZeroUInt512(One);
  ZeroUInt512(Other);
  ZeroUInt512(Result);
  One[0] := 80;
  One[1] := 90;
  Other[0] := 4;
  Other[1] := 3;
  MultUInt512s(One, Other, Result);
  Test_MultUInt512s_TwoDigitCarry :=
    (Result[0] = 64)
    and (Result[1] = 89)
    and (Result[2] = 16)
    and (Result[3] = 1);
end;



function Test_DivUInt512by10(
  Test : TTestPtr
) : Boolean;

var
  One, Quot : TUInt512;
  Rem : Byte;

begin
  ZeroUInt512(One);
  One[0] := 64;
  One[1] := 89;
  One[2] := 16;
  One[3] := 1;

  DivUInt512By10(One, Quot, Rem);

  Test_DivUInt512by10 :=
    (Quot[0] = 32)
    and (Quot[1] = 60)
    and (Quot[2] = 27)
    and (Rem = 0);
end;



function Test_UInt512ToDecStr(
  Test : TTestPtr
) : Boolean;

const
  Expected = '17848640';

var
  Int : TUInt512;

begin
  ZeroUInt512(Int);
  Int[0] := 64;
  Int[1] := 89;
  Int[2] := 16;
  Int[3] := 1;

  if UInt512ToDecStr(Int) <> Expected then
  begin
    Test_UInt512ToDecStr := false;
    Test^.ErrorMsg :=
      'Expected ' + Expected + ', got ' + UInt512ToDecStr(Int) + '.';
  end
  else
    Test_UInt512ToDecStr := true;
end;



begin
  RegisterTest(CreateTest(
    'UInt512', 'ZeroUInt512', 'zeroing',
    Test_ZeroUInt512
  ));
  RegisterTest(CreateTest(
    'UInt512', 'IntToUInt512', 'conversion',
    Test_IntToUInt512
  ));
  RegisterTest(CreateTest(
    'UInt512', 'AddUInt512s', 'basic',
    Test_AddUInt512s
  ));
  RegisterTest(CreateTest(
    'UInt512', 'AddUInt512s', 'carry',
    Test_AddUInt512s_Carry
  ));
  RegisterTest(CreateTest(
    'UInt512', 'MultUInt512s', 'simple',
    Test_MultUInt512s_Simple
  ));
  RegisterTest(CreateTest(
    'UInt512', 'MultUInt512s', 'carry',
    Test_MultUInt512s_Carry
  ));
  RegisterTest(CreateTest(
    'UInt512', 'MultUInt512s', 'two digits with carry',
    Test_MultUInt512s_TwoDigitCarry
  ));
  RegisterTest(CreateTest(
    'UInt512', 'DivUInt512By10', 'divide by 10',
    Test_DivUInt512by10
  ));
  RegisterTest(CreateTest(
    'UInt512', 'UInt512ToDecStr', 'to decimal string',
    Test_UInt512ToDecStr
  ));
end.