{$F+}
unit StrsT;

interface



uses
  Strs, Testing;



implementation



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





begin
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
end.