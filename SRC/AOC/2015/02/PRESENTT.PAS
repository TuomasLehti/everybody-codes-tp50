{$F+}
program PresentT;



uses
  Testing, Present, Strs;



function TestInpToPresent(
  TestCase : TTestPtr
) : Boolean;

const
  Input = '2x3x4';

var
  Got : TPresent;

begin
  InpToPresent(Input, Got);
  with Got do
  begin
    TestCase^.ErrorMsg :=
      'Expected ' + IntToStr(2) + ' ' + IntToStr(3) + ' ' + IntToStr(4)
      + ', got ' + IntToStr(Length) + ' ' + IntToStr(Width) + ' '
      + IntToStr(Height);
    TestInpToPresent := (Length = 2) and (Width = 3) and (Height = 4);
  end;
end;



function TestWrapping234(
  TestCase : TTestPtr
) : Boolean;

const
  Input = '2x3x4';
  Expected = 58;

var
  Got : LongInt;
  Pr : TPresent;

begin
  InpToPresent(Input, Pr);
  Got := WrappingNeeded(Pr);
  TestCase^.ErrorMsg :=
    'Expected ' + IntToStr(Expected) + ', ' +
    'got ' + IntToStr(Got);
  TestWrapping234 := Expected = Got;
end;



function TestWrapping1110(
  TestCase : TTestPtr
) : Boolean;

const
  Input = '1x1x10';
  Expected = 43;

var
  Got : LongInt;
  Pr : TPresent;

begin
  InpToPresent(Input, Pr);
  Got := WrappingNeeded(Pr);
  TestCase^.ErrorMsg :=
    'Expected ' + IntToStr(Expected) + ', ' +
    'got ' + IntToStr(Got);
  TestWrapping1110 := Expected = Got;
end;



function TestRibbon234(
  TestCase : TTestPtr
) : Boolean;

const
  Input = '2x3x4';
  Expected = 34;

var
  Got : LongInt;
  Pr : TPresent;

begin
  InpToPresent(Input, Pr);
  Got := RibbonNeeded(Pr);
  TestCase^.ErrorMsg :=
    'Expected ' + IntToStr(Expected) + ', ' +
    'got ' + IntToStr(Got);
  TestRibbon234 := Expected = Got;
end;



function TestRibbon1110(
  TestCase : TTestPtr
) : Boolean;

const
  Input = '1x1x10';
  Expected = 14;

var
  Got : LongInt;
  Pr : TPresent;

begin
  InpToPresent(Input, Pr);
  Got := RibbonNeeded(Pr);
  TestCase^.ErrorMsg :=
    'Expected ' + IntToStr(Expected) + ', ' +
    'got ' + IntToStr(Got);
  TestRibbon1110 := Expected = Got;
end;



begin
  RegisterTest(CreateTest(
    'Present', 'InpToPresent', '2x3x4',
    TestInpToPresent
  ));
  RegisterTest(CreateTest(
    'Present', 'WrappingNeeded',
    '2x3x4',
    TestWrapping234
  ));
  RegisterTest(CreateTest(
    'Present', 'WrappingNeeded',
    '1x1x10',
    TestWrapping1110
  ));
  RegisterTest(CreateTest(
    'Present', 'RibbonNeeded',
    '2x3x4',
    TestRibbon234
  ));
  RegisterTest(CreateTest(
    'Present', 'RibbonNeeded',
    '1x1x10',
    TestRibbon1110
  ));

  RunAllTests;
  UnregisterAllTests;
end.