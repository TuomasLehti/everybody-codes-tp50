{
  Tests for the Md5 unit.
}

{$F+}

unit Md5T;



interface


uses
  Strs, Testing, Md5;



implementation



function Test_LongInt_Wraps(
  Test : TTestPtr
) : Boolean;

begin
  Test_LongInt_Wraps :=
    (($FFFFFFFF + 1) = 0)
    and (($7FFFFFFF + 1) = $80000000);
end;



function Test_LongInt_BitwiseAnd(
  Test : TTestPtr
) : Boolean;

begin
  Test_LongInt_BitwiseAnd :=
    ($80000000 AND $FFFFFFFF) = $80000000;
end;



function Test_LongInt_BitwiseOr(
  Test : TTestPtr
) : Boolean;

begin
  Test_LongInt_BitwiseOr :=
    ($80000000 OR $F0000000) = $F0000000;
end;



function Test_LongInt_BitwiseXor(
  Test : TTestPtr
) : Boolean;

begin
  Test_LongInt_BitwiseXor:=
    ($AAAAAAAA XOR $55555555) = $FFFFFFFF;
end;



function Test_LongInt_BitwiseNot(
  Test : TTestPtr
) : Boolean;

begin
  Test_LongInt_BitwiseNot :=
    (NOT $00000000) = $FFFFFFFF;
end;



function Test_Md5_Pow2(
  Test : TTestPtr
) : Boolean;

const
  Expecteds : array[0..31] of LongInt = (
    $00000001,
    $00000002,
    $00000004,
    $00000008,
    $00000010,
    $00000020,
    $00000040,
    $00000080,
    $00000100,
    $00000200,
    $00000400,
    $00000800,
    $00001000,
    $00002000,
    $00004000,
    $00008000,
    $00010000,
    $00020000,
    $00040000,
    $00080000,
    $00100000,
    $00200000,
    $00400000,
    $00800000,
    $01000000,
    $02000000,
    $04000000,
    $08000000,
    $10000000,
    $20000000,
    $40000000,
    $80000000
  );

var
  I : Byte;

begin
  for I := 0 to 31 do
    if Pow2(I) <> Expecteds[I] then
    begin
      Test_Md5_Pow2 := false;
      Test^.ErrorMsg :=
        'Pow2(' + IntToStr(I) + '): '
        + 'Expected ' + LongIntToHexStr(Expecteds[I]) + ', ' +
        + ' got ' + LongIntToHexStr(Pow2(I));
    end;
end;



function Test_Md5_LongIntToHexStr(
  Test : TTestPtr
) : Boolean;

begin
  Test_Md5_LongIntToHexStr :=
    (LongIntToHexStr($12345678) = '12345678')
    and (LongIntToHexStr($90ABCDEF) = '90ABCDEF');
end;



function Test_Md5_RotateLeft(
  Test : TTestPtr
) : Boolean;

begin
  Test_Md5_RotateLeft :=
    (RotateLeft($00000001, 1) = $00000002)
    and (RotateLeft($00000001, 2) = $00000004)
    and (RotateLeft($F00000F0, 4) = $00000F0F)
end;



begin
  RegisterTest(CreateTest(
    'Md5', 'LongInt', 'LongInt wraps like uint32',
    Test_LongInt_Wraps
  ));
  RegisterTest(CreateTest(
    'Md5', 'LongInt', 'Bitwise and handles sign bit',
    Test_LongInt_BitwiseAnd
  ));
  RegisterTest(CreateTest(
    'Md5', 'LongInt', 'Bitwise or handles sign bit',
    Test_LongInt_BitwiseOr
  ));
  RegisterTest(CreateTest(
    'Md5', 'LongInt', 'Bitwise xor handles sign bit',
    Test_LongInt_BitwiseXor
  ));
  RegisterTest(CreateTest(
    'Md5', 'LongInt', 'Bitwise not handles sign bit',
    Test_LongInt_BitwiseNot
  ));

  RegisterTest(CreateTest(
    'Md5', 'LongIntToHexStr', 'Converts correctly',
    Test_Md5_LongIntToHexStr
  ));
  RegisterTest(CreateTest(
    'Md5', 'Pow2', 'Power of 2 calculations',
    Test_Md5_Pow2
  ));
  RegisterTest(CreateTest(
    'Md5', 'RotateLeft', 'Rotates correctly',
    Test_Md5_RotateLeft
  ));


end.