{
  Testing is a framework to unit test units.

  Testing is based on tester functions, whose prototype is TTestFunc.
  The framework runs a selection of tests (for now the only option is to run
  all the tests) and logs the results based on the boolean return falue of
  the tester function.

  If the test doesn't pass, the tester function can add a short explanation
  of eg. the expected and actual value in the test case record it receives
  as a parameter.

  Other information inside the test case record includes the unit name, the
  name of to routine to be tested, and the name of the test. They can be
  thought as a three-level structure.

  All test cases must be registered with the RegisterTest-procedure. They can
  then be run by RunAllTests-procedure. UnregisterAllTests-procedure must be
  run when exiting the program to prevent memory leaks.
}

{$F+}
unit Testing;



interface



uses
  Logging;



type

  TTestPtr = ^TTest;



  TTestFunc = function(TestCase : TTestPtr) : Boolean;



  TTest = record
    UnitName,
    ProcName,
    TestName,
    ErrorMsg : String;
    TestFunc : TTestFunc;
  end;



procedure RegisterTest(
  TestPtr : TTestPtr
);



function CreateTest(
  UnitName,
  ProcName,
  TestName : String;
  TestFunc : TTestFunc
) : TTestPtr;



procedure UnregisterAllTests;



procedure RunAllTests;



implementation



const
  maxNumTests = 4096;



type
  TTests = array[1..maxNumTests] of TTestPtr;



var
  NumTests : Word;
  Tests : TTests;



procedure RegisterTest(TestPtr : TTestPtr);

begin
  NumTests := NumTests + 1;
  Tests[NumTests] := TestPtr;
end;



function CreateTest(
  UnitName,
  ProcName,
  TestName : String;
  TestFunc : TTestFunc
) : TTestPtr;

var
  Test : TTestPtr;

begin
  New(Test);
  Test^.UnitName := UnitName;
  Test^.ProcName := ProcName;
  Test^.TestName := TestName;
  Test^.TestFunc := TestFunc;
  CreateTest := Test;
end;



procedure UnregisterAllTests;

var
  I : Word;

begin
  for I := 1 to NumTests do
    Dispose(Tests[I]);
end;



procedure RunAllTests;

var
  I : Word;
  Name : String;

begin
  Log(logInfo, 'Running all tests');
  for I := 1 to NumTests do
  with Tests[I]^ do
  begin
    Name := UnitName + '.' + ProcName + ': ' + TestName;
    if Tests[I]^.TestFunc(Tests[I]) then
      Log(logInfo, Name + ' passed')
    else
    begin
      Log(logWarn, Name + ' failed');
      Log(logWarn, ErrorMsg);
    end;
  end;
end;



procedure InitializeTestArray;

var
  I : Word;

begin
  for I := 1 to 4096 do
    Tests[I] := nil;
end;



begin
  InitializeTestArray;
  NumTests := 0;
end.