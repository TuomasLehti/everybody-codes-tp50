{
  Tests for METADATA.PAS.
}



{$F+}



unit MetadatT;



interface



uses
  Strs, Testing, Metadata;



implementation


function Test_OpenFile(
  Test : TTestPtr
) : Boolean;

type
  TBuf = array[1..16] of Byte;

const
  Fnm = 'TMP\TEST.TMP';
  Data : TBuf = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);

  procedure CreateTestFile;
  var
    F : File;
  begin
    Assign(F, Fnm);
    Rewrite(F);
    BlockWrite(F, Data, SizeOf(Data));
    Close(F);
  end;

  procedure EraseTestFile;
  var
    F : File;
  begin
    Assign(F, Fnm);
    Erase(F);
  end;

var
  Idx : Byte;
  Res : Boolean;
  C : Char;

begin
  CreateTestFile;
  OpenFile(Fnm);
  Res := true;
  for Idx := 1 to 16 do
  begin
    C := ReadInpChar;
    Res := Res and (C = Chr(Data[Idx]));
    if not Res then
    begin
      Test^.ErrorMsg :=
        'Error at idx ' + IntToStr(Idx)
        + ': expected ' + IntToStr(Data[Idx])
        + ', got ' + IntToStr(Ord(C));
      Test_OpenFile := false;
      Exit;
    end;
  end;
  EraseTestFile;
end;



procedure CreateTestFile(
  Fnm, Contents : String
);

var
  F : File;

begin
  Assign(F, Fnm);
  Rewrite(F, 1);
  if Length(Contents) > 1 then
    BlockWrite(F, Contents[1], Length(Contents));
  Close(F);
end;



procedure EraseTestFile(
  Fnm : String
);

var
  F : File;

begin
  Assign(F, Fnm);
  Erase(F);
end;



type
  TExpected = array[1..4] of String;


function RunTest(
  Contents : String;
  ExpectedNumLines : Byte;
  ExpectedLines : TExpected;
  var Msg : String
) : Boolean;

const
  TestFnm = 'TMP\TEST.TMP';

var
  Idx : Byte;
  Got : String;
  Res : Boolean;

begin
  CreateTestFile(TestFnm, Contents);
  OpenFile(TestFnm);

  Res := true;
  for Idx := 1 to ExpectedNumLines do
  begin
    if InpEof then
    begin
      Msg := Msg + 'Unexpected end of file at round ' + IntToStr(Idx);
      RunTest := false;
      EraseTestFile(TestFnm);
      Exit;
    end;

    Got := ReadInpStr;
    Res := Res and (Got = ExpectedLines[Idx]);
    if not Res then
    begin
      Msg := Msg + ': '
        + 'Error at line ' + IntToStr(Idx) + ':' + #13 + #10 +
        + 'Expected "' + ExpectedLines[Idx] + '"' + #13 + #10 +
        + 'Got "' + Got + '"';
      RunTest := false;
      EraseTestFile(TestFnm);
      Exit;
    end;
  end;

  if not InpEof then
  begin
    Msg := Msg + 'All lines not read';
    RunTest := false;
    EraseTestFile(TestFnm);
    Exit;
  end;

  RunTest := true;
  EraseTestFile(TestFnm);
end;



function Test_ReadInpChr_EmptyFile(
  Test : TTestPtr
) : Boolean;

const
  Fnm = 'TMP\TEST.TMP';
  Contents = '';

var
  C : Char;

begin
  CreateTestFile(Fnm, Contents);
  OpenFile(Fnm);

  InpLenient := true;
  C := ReadInpChar;

  Test_ReadInpChr_EmptyFile :=
    (C = #0)
    and (InpResult = inpErrUnexpectedEof)
    and (InpResult = inpOk);

  EraseTestFile(Fnm);
end;



function Test_ReadInpStr_EmptyFile(
  Test : TTestPtr
) : Boolean;

const
  Fnm = 'TMP\TEST.TMP';
  Contents = '';

begin
  CreateTestFile(Fnm, Contents);
  OpenFile(Fnm);

  Test_ReadInpStr_EmptyFile := InpEof and InpEol;

  EraseTestFile(Fnm);
end;



function Test_ReadInpStr_OneLiner(
  Test : TTestPtr
) : Boolean;

const
  Contents = 'AA';
  ContentsLf = 'AA' + #10;
  ContentsCr = 'AA' + #13;
  ContentsLfCr = 'AA' + #10 + #13;
  ContentsCrLf = 'AA' + #13 + #10;
  Expected : TExpected = ('AA', '', '', '');

var
  Msg : String;
  Res : Boolean;

begin
  Msg := '';

  Res := RunTest(Contents, 1, Expected, Msg);
  if not Res then
  begin
    Test^.ErrorMsg := 'oneliner ' + Msg;
    Exit;
  end;

  Res := RunTest(ContentsLf, 1, Expected, Msg);
  if not Res then
  begin
    Test^.ErrorMsg := 'oneliner LF ' + Msg;
    Exit;
  end;

  Res := RunTest(ContentsCr, 1, Expected, Msg);
  if not Res then
  begin
    Test^.ErrorMsg := 'oneliner CR ' + Msg;
    Exit;
  end;

  Res := RunTest(ContentsLfCr, 1, Expected, Msg);
  if not Res then
  begin
    Test^.ErrorMsg := 'oneliner LF/CR ' + Msg;
    Exit;
  end;

  Res := RunTest(ContentsCrLf, 1, Expected, Msg);
  if not Res then
  begin
    Test^.ErrorMsg := 'oneliner CR/LF' + Msg;
    Exit;
  end;

  Test_ReadInpStr_OneLiner := Res;
end;



function Test_ReadInpStr_TwoLiner(
  Test : TTestPtr
) : Boolean;

const
  Fnm = 'TMP\TEST.TMP';

  function RunTest(Contents : String) : Boolean;
  begin
    CreateTestFile(Fnm, Contents);
    OpenFile(Fnm);

    RunTest :=
      (ReadInpStr = 'AA')
      and (ReadInpStr = 'BB')
      and InpEof and InpEol;

    EraseTestFile(Fnm);
  end;

const
  ContentsCr = 'AA' + #13 + 'BB' + #13;
  ContentsLf = 'AA' + #10 + 'BB' + #10;
  ContentsCrLf = 'AA' + #13 + #10 + 'BB' + #13 + #10;
  ContentsLfCr = 'AA' + #10 + #13 + 'BB' + #10 + #13;

begin
  Test_ReadInpStr_TwoLiner :=
    RunTest(ContentsCr)
    and RunTest(ContentsLf)
    and RunTest(ContentsCrLf)
    and RunTest(ContentsLfCr);
end;



function Test_ReadInpStr_EmptyLiner(
  Test : TTestPtr
) : Boolean;

const
  Fnm = 'TMP\TEST.TMP';

  function RunTest(Contents : String) : Boolean;
  begin
    CreateTestFile(Fnm, Contents);
    OpenFile(Fnm);

    RunTest :=
      (ReadInpStr = 'AA')
      and (ReadInpStr = '')
      and (ReadInpStr = 'BB')
      and InpEof and InpEol;

    EraseTestFile(Fnm);
  end;

const
  ContentsCr = 'AA' + #13 + #13 + 'BB';
  ContentsLf = 'AA' + #10 + #10 + 'BB' + #10;
  ContentsCrLf = 'AA' + #13 + #10 + #13 + #10 + 'BB' + #13 + #10;
  ContentsLfCr = 'AA' + #10 + #13 + #10 + #13 + 'BB' + #10 + #13;

begin
  Test_ReadInpStr_EmptyLiner :=
    RunTest(ContentsCr)
    and RunTest(ContentsLf)
    and RunTest(ContentsCrLf)
    and RunTest(ContentsLfCr);
end;



begin
  RegisterTest(CreateTest(
    'Metadata', 'OpenFile', 'File opened',
    Test_OpenFile)
  );


  RegisterTest(CreateTest(
    'Metadata', 'ReadInpChr', 'Empty file',
    Test_ReadInpChr_EmptyFile)
  );
  RegisterTest(CreateTest(
    'Metadata', 'ReadInpStr', 'Empty file',
    Test_ReadInpStr_EmptyFile)
  );

  RegisterTest(CreateTest(
    'Metadata', 'ReadInpStr', 'Oneliner',
    Test_ReadInpStr_OneLiner)
  );

  RegisterTest(CreateTest(
    'Metadata', 'ReadInpStr', 'Twoliner',
    Test_ReadInpStr_TwoLiner)
  );
  RegisterTest(CreateTest(
    'Metadata', 'ReadInpStr', 'Twoliner with empty line in between',
    Test_ReadInpStr_EmptyLiner)
  );
end.