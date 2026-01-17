{$F+}
unit StrsT;

interface



uses
  Strs, Testing;



implementation



function Test_StrBegins_PrefixFound(
  Test : TTestPtr
) : Boolean;

var
  Str, Prefix : String;

begin
  Str := 'Hello, world!';
  Prefix := 'Hello';
  Test_StrBegins_PrefixFound := StrBegins(Str, Prefix);
end;



function Test_StrBegins_PrefixNotFound(
  Test : TTestPtr
) : Boolean;

var
  Str, Prefix : String;

begin
  Str := 'Hello, world!';
  Prefix := 'olleh';
  Test_StrBegins_PrefixNotFound := not StrBegins(Str, Prefix);
end;



function Test_StrBegins_OneCharPrefix(
  Test : TTestPtr
) : Boolean;

var
  Str, Prefix : String;

begin
  Str := 'Hello, world!';
  Prefix := 'H';
  Test_StrBegins_OneCharPrefix := StrBegins(Str, Prefix);
end;



function Test_StrBegins_ZeroCharPrefix(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrBegins_ZeroCharPrefix := not StrBegins('Hello!', '');
end;



function Test_StrBegins_ZeroCharStr(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrBegins_ZeroCharStr := not StrBegins('', 'world');
end;



function Test_StrBegins_ZeroLengths(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrBegins_ZeroLengths := not StrBegins('', '');
end;



function Test_StrEnds_SuffixFound(
  Test : TTestPtr
) : Boolean;

var
  Str, Suffix : String;

begin
  Str := 'Hello, world!';
  Suffix := 'world!';
  Test_StrEnds_SuffixFound:= StrEnds(Str, Suffix);
end;



function Test_StrEnds_SuffixNotFound(
  Test : TTestPtr
) : Boolean;

var
  Str, Suffix : String;

begin
  Str := 'Hello, world!';
  Suffix := '!dlrow';
  Test_StrEnds_SuffixNotFound := not StrEnds(Str, Suffix);
end;



function Test_StrEnds_OneCharSuffix(
  Test : TTestPtr
) : Boolean;

var
  Str, Suffix : String;

begin
  Str := 'Hello, world!';
  Suffix := '!';
  Test_StrEnds_OneCharSuffix := StrEnds(Str, Suffix);
end;



function Test_StrEnds_ZeroCharSuffix(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrEnds_ZeroCharSuffix := not StrEnds('Hello!', '');
end;



function Test_StrEnds_ZeroCharStr(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrEnds_ZeroCharStr := not StrEnds('', 'world');
end;



function Test_StrEnds_ZeroLengths(
  Test : TTestPtr
) : Boolean;

begin
  Test_StrEnds_ZeroLengths := not StrEnds('', '');
end;



function Test_IntToStr_Byte(
  Test : TTestPtr
) : Boolean;

const
  Int : Byte = 67;
  Expected : String = '67';

var
  Got : String;

begin
  Got := IntToStr(Int);
  Test_IntToStr_Byte := Got = Expected;
end;



function Test_IntToStr_LongIntNeg(
  Test : TTestPtr
) : Boolean;

const
  Int : LongInt = -2109876543;
  Expected : String = '-2109876543';

var
  Got : String;

begin
  Got := IntToStr(Int);
  Test_IntToStr_LongIntNeg := Got = Expected;
end;



function Test_StrToInt(
  Test : TTestPtr
) : Boolean;

const
  Str = '1234';
  Expected = 1234;

var
  Got : Integer;

begin
  Got := StrToInt(Str);
  Test_StrToInt := Got = Expected;
end;



function Test_StrToInt_Neg(
  Test : TTestPtr
) : Boolean;

const
  Str = '-2109876543';
  Expected : LongInt = -2109876543;

var
  Got : LongInt;

begin
  Got := StrToInt(Str);
  Test^.ErrorMsg := '';
  Test_StrToInt_Neg := Got = Expected;
end;



function Test_StrToInt_Err(
  Test : TTestPtr
) : Boolean;

const
  Str = '210.012';

var
  Got : Integer;

begin
  Got := StrToInt(Str);
  Test_StrToInt_Err := StrResult = strErrNumFormat;
end;



function Test_LeftPad_Normal(
  Test : TTestPtr
) : Boolean;

const
  Str : String = 'right';
  Filler : Char = '.';
  Len : Byte = 10;
  Expected : String = '.....right';

var
  Got : String;

begin
  Got := LeftPad(Str, Len, Filler);
  Test_LeftPad_Normal := Got = Expected;
end;



function Test_LeftPad_AlreadyAtRightLength(
  Test : TTestPtr
) : Boolean;

const
  Str : String = 'right';
  Filler : Char = '.';
  Len : Byte = 5;
  Expected : String = 'right';

var
  Got : String;

begin
  Got := LeftPad(Str, Len, Filler);
  Test_LeftPad_AlreadyAtRightLength := Got = Expected;
end;



function Test_LeftPad_TooLong(
  Test : TTestPtr
) : Boolean;

const
  Str : String = 'right';
  Filler : Char = '.';
  Len : Byte = 2;
  Expected : String = 'right';

var
  Got : String;

begin
  Got := LeftPad(Str, Len, Filler);
  Test_LeftPad_TooLong := Got = Expected;
end;



function Test_StrCopyChr(
  Test : TTestPtr
) : Boolean;

const
  Str = 'Hello, world!';
  Splitter = ',';
  Expected = 'Hello';

var
  Got : String;

begin
  Got := StrCopyChr(Str, Splitter);
  if Got <> Expected then
    Test^.ErrorMsg := 'Expected "' + Expected + '", got "' + Got + '"';
  Test_StrCopyChr:= Got = Expected;
end;



function Test_StrCopyChr_SplitterNotFound(
  Test : TTestPtr
) : Boolean;

const
  Str = 'Hello, world!';
  Splitter = 'xyz';
  Expected = 'Hello, world!';

var
  Got : String;

begin
  Got := StrCopyChr(Str, Splitter);
  if Got <> Expected then
    Test^.ErrorMsg := 'Expected "' + Expected + '", got "' + Got + '"';
  Test_StrCopyChr_SplitterNotFound:= Got = Expected;
end;



function Test_StrCutChr(
  Test : TTestPtr
) : Boolean;

const
  Str : String = 'Hello, world!';
  Splitter = ', ';
  Expected = 'Hello';
  ExpectedOrig = 'world!';

var
  Got : String;

begin
  Got := StrCutChr(Str, Splitter);
  if (Got <> Expected) or (Str <> ExpectedOrig) then
    Test^.ErrorMsg :=
      'Expected "' + Expected + '" ' +
      'and "' + ExpectedOrig + '", ' +
      + '"got "' + Got + '" ' +
      'and "' + Str + '"';
  Test_StrCutChr := (Got = Expected) and (Str = ExpectedOrig);
end;



function Test_StrCutChr_SplitterNotFound(
  Test : TTestPtr
) : Boolean;

const
  Str : String = 'Hello, world!';
  Splitter = 'xyz';
  Expected = 'Hello, world!';
  ExpectedOrig = '';

var
  Got : String;

begin
  Got := StrCutChr(Str, Splitter);
  if Got <> Expected then
    Test^.ErrorMsg :=
      'Expected "' + Expected + '" ' +
      'and "' + ExpectedOrig + '", ' +
      + '"got "' + Got + '" ' +
      'and "' + Str + '"';
  Test_StrCutChr_SplitterNotFound :=
    (Got = Expected) and (Str = ExpectedOrig);
end;





begin
  RegisterTest(CreateTest(
    'Strs', 'StrBegins', 'Prefix found',
    Test_StrBegins_PrefixFound)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrBegins', 'Prefix not found',
    Test_StrBegins_PrefixNotFound)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrBegins', 'One-char prefix',
    Test_StrBegins_OneCharPrefix)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrBegins', 'Zero-length prefix',
    Test_StrBegins_ZeroCharPrefix)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrBegins', 'Zero-length string',
    Test_StrBegins_ZeroCharStr)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrBegins', 'Zero-length parameters',
    Test_StrBegins_ZeroLengths)
  );


  RegisterTest(CreateTest(
    'Strs', 'StrEnds', 'Suffix found',
    Test_StrEnds_SuffixFound)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrEnds', 'Suffix not found',
    Test_StrEnds_SuffixFound)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrEnds', 'One-char suffix',
    Test_StrEnds_OneCharSuffix)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrEnds', 'Zero-length suffix',
    Test_StrEnds_ZeroCharSuffix)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrEnds', 'Zero-length string',
    Test_StrEnds_ZeroCharStr)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrEnds', 'Zero-length parameters',
    Test_StrEnds_ZeroLengths)
  );


  RegisterTest(CreateTest(
    'Strs', 'IntToStr', 'Converts Byte',
    Test_IntToStr_Byte)
  );
  RegisterTest(CreateTest(
    'Strs', 'IntToStr', 'Converts negative LongInmt',
    Test_IntToStr_LongIntNeg)
  );


  RegisterTest(CreateTest(
    'Strs', 'StrToInt', 'Converts correctly',
    Test_StrToInt)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrToInt', 'Converts negative',
    Test_StrToInt_Neg)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrToInt', 'Reports errors',
    Test_StrToInt_Err)
  );


  RegisterTest(CreateTest(
    'Strs', 'LeftPad', 'Pads correctly',
    Test_LeftPad_Normal)
  );
  RegisterTest(CreateTest(
    'Strs', 'LeftPad', 'Source string at correct length',
    Test_LeftPad_AlreadyAtRightLength)
  );
  RegisterTest(CreateTest(
    'Strs', 'LeftPad', 'Source string too long',
    Test_LeftPad_TooLong)
  );


  RegisterTest(CreateTest(
    'Strs', 'StrCopyChr', 'Splitter found',
    Test_StrCopyChr)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrCopyChr', 'Splitter not found',
      Test_StrCopyChr_SplitterNotFound)
  );


  RegisterTest(CreateTest(
    'Strs', 'StrCutChr', 'Splitter found',
    Test_StrCutChr)
  );
  RegisterTest(CreateTest(
    'Strs', 'StrCutChr', 'Splitter not found',
      Test_StrCutChr_SplitterNotFound)
  );



end.