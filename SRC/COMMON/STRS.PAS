{
  String manipulation procedures and functions.
}

unit Strs;



interface


{
  ---------------------------------------------------------------------------
  StrEnds
  ---------------------------------------------------------------------------

  Function

    Determines if a string ends with another string.

  Parameters

    Str        The string from which the suffix is searched.

    Suffix     The suffix to search for.

    Returns    True if Str ends with Suffix.

  Remarks

    If the length of either of the strings is zero, return false.

}
function StrEnds(
  Str,
  Suffix : String
) : Boolean;



{
  ---------------------------------------------------------------------------
  IntToStr
  ---------------------------------------------------------------------------

  Function

    Converts an integer into a string.

  Parameters

    Num        The number to convert.

  Remarks

    A convenience function to save a variable when the resulting integer is
    used as a parameter in another function or procedure.
}
function IntToStr(
  Num : LongInt
) : String;



{
  ---------------------------------------------------------------------------
  LeftPad
  ---------------------------------------------------------------------------

  Function

    Justifies a string to the right.

  Parameters

    S          The string to justify.

    Len        The length of the resulting string.

    Filler     The character which to pad with.

  Remarks

    If the string to justify is longer than the wanted length, returns the
    string to justify.
}
function LeftPad(
  S : String;
  Len : Word;
  Filler : Char
) : String;



implementation



function StrEnds(
  Str,
  Suffix : String
) : Boolean;

var
  SuffixLen : Byte;
  SuffixPos : Byte;
  ActualSuffix : String;

begin
  if (Length(Str) = 0) or (Length(Suffix) = 0) then
  begin
    StrEnds := false
  end
  else
  begin
    SuffixLen := Length(Suffix);
    SuffixPos := Length(Str) - SuffixLen + 1;
    ActualSuffix := Copy(Str, SuffixPos, SuffixLen);
    StrEnds := Suffix = ActualSuffix
  end
end;



function IntToStr(
  Num : LongInt
) : String;

var
  S : String;

begin
  Str(Num, S);
  IntToStr := S;
end;



function LeftPad(
  S : String;
  Len : Word;
  Filler : Char
) : String;

var
  T : String;

begin
  T := S;
  while Length(T) < Len do
    T := Filler + T;
  LeftPad := T;
end;



end.