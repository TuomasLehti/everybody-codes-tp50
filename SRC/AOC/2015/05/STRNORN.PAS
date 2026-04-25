{
  An include file for Advent of Code 2015, day 5.

  Contains the functions and procedures for defining if a string is
  naughty or nice. This way they can be accessed by the actual solver,
  and a testing program to test their correctness without the need to
  use a Unit.

  No separate documentation is provided for these functions. They are quite
  self-explanatory after all, and everything is described thoroughly in
  the puzzle description.

  STRNORN stands for String Naughty Or Nice, btw.
}



function ContainsAtLeastThreeWovels(
  S : String
) : Boolean;

const
  Wovels = 'aeiou';

var
  I, NumWovels : Byte;

begin
  NumWovels := 0;
  for I := 1 to Length(S) do
  begin
    if Pos(Copy(S, I, 1), Wovels) > 0 then
      Inc(NumWovels);
    if NumWovels = 3 then
    begin
      ContainsAtLeastThreeWovels := true;
      Exit;
    end;
  end;
  ContainsAtLeastThreeWovels := false;
end;



function ContainsAtLeastOneDoubleLetter(
  S : String
) : Boolean;

var
  I : Byte;

begin
  for I := 1 to Length(S) - 1 do
    if Copy(S, I, 1) = Copy(S, I+1, 1) then
    begin
      ContainsAtLeastOneDoubleLetter := true;
      Exit;
    end;
  ContainsAtLeastOneDoubleLetter := false;
end;



function DoesntContainForbiddenPairs(
  S : String
) : Boolean;

begin
  DoesntContainForbiddenPairs :=
    (Pos('ab', S) = 0)
    and (Pos('cd', S) = 0)
    and (Pos('pq', S) = 0)
    and (Pos('xy', S) = 0);
end;



function IsNicePt1(
  S : String
) : Boolean;

begin
  IsNicePt1 :=
    ContainsAtLeastThreeWovels(S)
    and ContainsAtLeastOneDoubleLetter(S)
    and DoesntContainForbiddenPairs(S);
end;



function ContainsPairTwiceNotOverlapping(
  S : String
) : Boolean;

var
  I : Byte;
  Pair, Rest : String;

begin
  for I := 1 to Length(S) - 2 do
  begin
    Pair := Copy(S, I, 2);
    Rest := Copy(S, I + 2, Length(S));
    if Pos(Pair, Rest) > 0 then
    begin
      ContainsPairTwiceNotOverlapping := true;
      Exit;
    end;
  end;
  ContainsPairTwiceNotOverlapping := false;
end;



function ContainsTriplet(
  S : String
): Boolean;

var
  I : Byte;

begin
  for I := 1 to Length(S) - 2 do
    if S[I] = S[I + 2] then
    begin
      ContainsTriplet := true;
      Exit;
    end;
  ContainsTriplet := false;
end;



function IsNicePt2(
  S : String
) : Boolean;

begin
  IsNicePt2 :=
    ContainsPairTwiceNotOverlapping(S)
    and ContainsTriplet(S);
end;



