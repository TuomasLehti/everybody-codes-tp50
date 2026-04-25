{$F+}



program StrNOrNT;



uses
  Testing;



{$I SRC\AOC\2015\05\STRNORN.PAS}



function Test_ThreeWovels(
  Test : TTestPtr
) : Boolean;

const
  NumPassers = 3;
  Passers : array[1..NumPassers] of String = (
    'aei', 'xazegov', 'aeiouaeiouaeiou'
  );

  NumFailers = 3;
  Failers : array[1..NumFailers] of String = (
    'bcd', 'bicod', 'aa'
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumPassers do
  begin
    Res := Res and ContainsAtLeastThreeWovels(Passers[I]);
    if not Res then
    begin
      Test_ThreeWovels := false;
      Test^.ErrorMsg := 'Fails at ' + Passers[I];
      Exit;
    end;
  end;
  for I := 1 to NumFailers do
  begin
    Res := Res and (not ContainsAtLeastThreeWovels(Failers[I]));
    if not Res then
    begin
      Test_ThreeWovels := false;
      Test^.ErrorMsg := 'Fails at ' + Failers[I];
      Exit;
    end;
  end;
  Test_ThreeWovels := Res;
end;



function Test_DoubleLetter(
  Test : TTestPtr
) : Boolean;

const
  NumPassers = 3;
  Passers : array[1..NumPassers] of String = (
    'xx', 'abcdde', 'aabbccdd'
  );

  NumFailers = 3;
  Failers : array[1..NumFailers] of String = (
    'bcd', 'bicod', 'a'
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumPassers do
  begin
    Res := Res and ContainsAtLeastOneDoubleLetter(Passers[I]);
    if not Res then
    begin
      Test_DoubleLetter := false;
      Test^.ErrorMsg := 'Fails at ' + Passers[I];
      Exit;
    end;
  end;
  for I := 1 to NumFailers do
  begin
    Res := Res and (not ContainsAtLeastOneDoubleLetter(Failers[I]));
    if not Res then
    begin
      Test_DoubleLetter := false;
      Test^.ErrorMsg := 'Fails at ' + Failers[I];
      Exit;
    end;
  end;
  Test_DoubleLetter := Res;
end;



function Test_ForbiddenPairs(
  Test : TTestPtr
) : Boolean;

const
  NumPassers = 3;
  Passers : array[1..NumPassers] of String = (
    'a', 'aa', 'aacfgg'
  );

  NumFailers = 5;
  Failers : array[1..NumFailers] of String = (
    'ab', 'cd', 'pq', 'xy', 'ahpcxydpdc'
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumPassers do
  begin
    Res := Res and DoesntContainForbiddenPairs(Passers[I]);
    if not Res then
    begin
      Test_ForbiddenPairs := false;
      Test^.ErrorMsg := 'Fails at ' + Passers[I];
      Exit;
    end;
  end;
  for I := 1 to NumFailers do
  begin
    Res := Res and (not DoesntContainForbiddenPairs(Failers[I]));
    if not Res then
    begin
      Test_ForbiddenPairs := false;
      Test^.ErrorMsg := 'Fails at ' + Failers[I];
      Exit;
    end;
  end;
  Test_ForbiddenPairs := Res;
end;



function Test_Part1(
  Test : TTestPtr
) : Boolean;

const
  NumPassers = 2;
  Passers : array[1..NumPassers] of String = (
    'ugknbfddgicrmopn', 'aaa'
  );

  NumFailers = 3;
  Failers : array[1..NumFailers] of String = (
    'jhzalrnumimnmhp', 'haegwjzuvuyypxyu', 'dvszwmarrgswjxmb'
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumPassers do
  begin
    Res := Res and IsNicePt1(Passers[I]);
    if not Res then
    begin
      Test_Part1 := false;
      Test^.ErrorMsg := 'Fails at ' + Passers[I];
      Exit;
    end;
  end;
  for I := 1 to NumFailers do
  begin
    Res := Res and (not IsNicePt1(Failers[I]));
    if not Res then
    begin
      Test_Part1 := false;
      Test^.ErrorMsg := 'Fails at ' + Failers[I];
      Exit;
    end;
  end;
  Test_Part1 := Res;
end;



function Test_TwoPairs(
  Test : TTestPtr
) : Boolean;

const
  NumPassers = 2;
  Passers : array[1..NumPassers] of String = (
    'xyxy', 'aabcdefgaa'
  );

  NumFailers = 1;
  Failers : array[1..NumFailers] of String = (
    'aaa'
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumPassers do
  begin
    Res := Res and ContainsPairTwiceNotOverlapping(Passers[I]);
    if not Res then
    begin
      Test_TwoPairs := false;
      Test^.ErrorMsg := 'Fails at ' + Passers[I];
      Exit;
    end;
  end;
  for I := 1 to NumFailers do
  begin
    Res := Res and (not ContainsPairTwiceNotOverlapping(Failers[I]));
    if not Res then
    begin
      Test_TwoPairs := false;
      Test^.ErrorMsg := 'Fails at ' + Failers[I];
      Exit;
    end;
  end;
  Test_TwoPairs := Res;
end;



function Test_Triplet(
  Test : TTestPtr
) : Boolean;

const
  NumPassers = 4;
  Passers : array[1..NumPassers] of String = (
    'xyx', 'abcdefeghi', 'aaa', 'baaa'
  );

  NumFailers = 2;
  Failers : array[1..NumFailers] of String = (
    'abcde', 'cd'
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumPassers do
  begin
    Res := Res and ContainsTriplet(Passers[I]);
    if not Res then
    begin
      Test_Triplet := false;
      Test^.ErrorMsg := 'Fails at ' + Passers[I];
      Exit;
    end;
  end;
  for I := 1 to NumFailers do
  begin
    Res := Res and (not ContainsTriplet(Failers[I]));
    if not Res then
    begin
      Test_Triplet := false;
      Test^.ErrorMsg := 'Fails at ' + Failers[I];
      Exit;
    end;
  end;
  Test_Triplet := Res;
end;



function Test_Part2(
  Test : TTestPtr
) : Boolean;

const
  NumPassers = 2;
  Passers : array[1..NumPassers] of String = (
    'qjhvhtzxzqqjkmbp', 'xxyxx'
  );

  NumFailers = 2;
  Failers : array[1..NumFailers] of String = (
    'uurcxstgmygtbstg', 'ieodomkazucvgmuy'
  );

var
  I : Byte;
  Res : Boolean;

begin
  Res := true;
  for I := 1 to NumPassers do
  begin
    Res := Res and IsNicePt2(Passers[I]);
    if not Res then
    begin
      Test_Part2 := false;
      Test^.ErrorMsg := 'Fails at ' + Passers[I];
      Exit;
    end;
  end;
  for I := 1 to NumFailers do
  begin
    Res := Res and (not IsNicePt2(Failers[I]));
    if not Res then
    begin
      Test_Part2 := false;
      Test^.ErrorMsg := 'Fails at ' + Failers[I];
      Exit;
    end;
  end;
  Test_Part2 := Res;
end;



begin

  RegisterTest(CreateTest(
    'AOC 2015', 'day 5', 'three wovels rule',
    Test_ThreeWovels
  ));
  RegisterTest(CreateTest(
    'AOC 2015', 'day 5', 'double letter rule',
    Test_DoubleLetter
  ));
  RegisterTest(CreateTest(
    'AOC 2015', 'day 5', 'forbidden pairs rule',
    Test_ForbiddenPairs
  ));
  RegisterTest(CreateTest(
    'AOC 2015', 'day 5', 'part 1 test input',
    Test_Part1
  ));

  RegisterTest(CreateTest(
    'AOC 2015', 'day 5', 'two pairs rule',
    Test_TwoPairs
  ));
  RegisterTest(CreateTest(
    'AOC 2015', 'day 5', 'triplet rule',
    Test_Triplet
  ));
  RegisterTest(CreateTest(
    'AOC 2015', 'day 5', 'part 2 test input',
    Test_Part2
  ));


  RunAllTests;
  UnregisterAllTests;
end.

