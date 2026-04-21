{$F+}


unit Md5T;



interface



uses
  Strs, Testing, Md5;



implementation



function Test_PadMsg_Empty(
  Test : TTestPtr
) : Boolean;

const
  Expected : TMd5Msg = (
    $80, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
  );

var
  Msg : TMd5Msg;
  I : Byte;

begin
  Msg[0] := 0;

  PadMsg(Msg);

  for I := 0 to 63 do
  begin
    If Msg[I] <> Expected[I] then
    begin
      Test^.ErrorMsg :=
        'Blocks differ at idx '
        + IntToStr(I) + '.';
      Test_PadMsg_Empty := false;
      Exit;
    end;
  end;

  Test_PadMsg_Empty := true;
end;



function Test_PadMsg_Hello(
  Test : TTestPtr
) : Boolean;

const
  Msg : TMd5Msg = (
    Ord('H'), Ord('e'), Ord('l'), Ord('l'), Ord('o'), $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
  );

  Expected : TMd5Msg = (
    Ord('H'), Ord('e'), Ord('l'), Ord('l'), Ord('o'), $80, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    40, $00, $00, $00, $00, $00, $00, $00
  );

var
  I : Byte;

begin
  PadMsg(Msg);

  for I := 0 to 63 do
  begin
    If Msg[I] <> Expected[I] then
    begin
      Test^.ErrorMsg :=
        'Blocks differ at idx '
        + IntToStr(I) + '.';
      Test_PadMsg_Hello := false;
      Exit;
    end;
  end;

  Test_PadMsg_Hello := true;
end;


function Test_PadMsg_TooLong(
  Test : TTestPtr
) : Boolean;

const
  Msg : TMd5Msg = (
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01
  );

  Expected : TMd5Msg = (
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $80,
    $B8, $01, $00, $00, $00, $00, $00, $00
  );

var
  I : Byte;

begin
  PadMsg(Msg);

  for I := 0 to 63 do
  begin
    If Msg[I] <> Expected[I] then
    begin
      Test^.ErrorMsg :=
        'Blocks differ at idx '
        + IntToStr(I) + '.';
      Test_PadMsg_TooLong := false;
      Exit;
    end;
  end;

  Test_PadMsg_TooLong := true;
end;



function Test_Md5_IntToHexStr(
  Test : TTestPtr
) : Boolean;

const
  Num = $00000000;

begin
  Test_Md5_IntToHexStr :=
    (IntToHexStr($00000000) = '00000000')
    and (IntToHexStr($01234567) = '01234567')
    and (IntToHexStr($89ABCDEF) = '89ABCDEF');
  Test^.ErrorMsg := IntToHexStr($01234567);

end;



function Test_Md5_LeftRotate(
  Test : TTestPtr
) : Boolean;

const
  NumCases = 2;

type
  TLongIntArr = array[1..NumCases] of LongInt;

const
  Cases : TLongIntArr = (
    $01020304,
    $12345678
  );

  Expecteds : TLongIntArr = (
    $10203040,
    $23456781
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumCases do
  begin
    Res := Res and (LeftRotate(Cases[I], 4) = Expecteds[I]);
    if not Res then
    begin
      Test^.ErrorMsg :=
        IntToHexStr(Cases[I])
        + ' : ' + IntToHexStr(LeftRotate(Cases[I], 4))
        + ' =/= ' + IntToHexStr(Expecteds[I]);
      Exit;
    end;
  end;
  Test_Md5_LeftRotate := true;
end;



function Test_Md5_CountMd5_Prepadded(
  Test : TTestPtr
) : Boolean;

const
  Msg: TMd5Msg = (
    $80, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
  );

  Expected = 'D41D8CD98F00B204E9800998ECF8427E';

var
  Got : String;

begin
  Got := CountMd5(Msg);
  Test_Md5_CountMd5_Prepadded := Got = Expected;
  if Got <> Expected then Test^.ErrorMsg := Got;
end;



function Test_Md5_CountMd5(
  Test : TTestPtr
) : Boolean;

const
  NumCases = 3;

type
  TStringArr = array[1..NumCases] of String;

const
  Cases : TStringArr = (
    '',
    'hello',
    'abcdef609043'
  );

  Expecteds : TStringArr = (
    'D41D8CD98F00B204E9800998ECF8427E',
    '5D41402ABC4B2A76B9719D911017C592',
    '000001DBBFA3A5C83A2D506429C7B00E'
  );

var
  I : Byte;
  Res : Boolean;
  Msg : TMd5Msg;
  Hash : String;

begin
  Res := true;
  for I := 1 to NumCases do
  begin
    StrToMd5Msg(Cases[I], Msg);
    Hash := CountMd5(Msg);
    Res := Res and (Hash = Expecteds[I]);
    if not Res then
    begin
      Test^.ErrorMsg :=
        Cases[I]
        + ' : Got ' + Hash
        + ' =/= Expected ' + Expecteds[I];
      Test_Md5_CountMd5 := false;
      Exit;
    end;
  end;
  Test_Md5_CountMd5 := true;
end;


begin
  RegisterTest(CreateTest(
    'Md5', 'PadMsg', 'Empty message',
    Test_PadMsg_Empty
  ));
  RegisterTest(CreateTest(
    'Md5', 'PadMsg', 'Hello-message',
    Test_PadMsg_Hello
  ));
  RegisterTest(CreateTest(
    'Md5', 'PadMsg', 'Too long message',
    Test_PadMsg_TooLong
  ));


  RegisterTest(CreateTest(
    'Md5', 'IntToHexStr', '',
    Test_Md5_IntToHexStr
  ));
  RegisterTest(CreateTest(
    'Md5', 'LeftRotate', '',
    Test_Md5_LeftRotate
  ));

  RegisterTest(CreateTest(
    'Md5', 'CountMd5', 'Pre-padded',
    Test_Md5_CountMd5_Prepadded
  ));

  RegisterTest(CreateTest(
    'Md5', 'CountMd5', '',
    Test_Md5_CountMd5
  ));

end.