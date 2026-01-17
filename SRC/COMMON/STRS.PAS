{
  String manipulation procedures and functions.
}

unit Strs;



interface



const
  strOk = 0;
  strErrNumFormat = 1;

var
  StrResult : ShortInt;



{
  ---------------------------------------------------------------------------
  StrBegins
  ---------------------------------------------------------------------------

  Function

    Determines if a string begins with another string.

  Parameters

    Str        The string from which the prefix is searched.

    Suffix     The prefix to search for.

    Returns    True if Str begins with Suffix.

  Remarks

    If the length of either of the strings is zero, return false.

}
function StrBegins(
  Str,
  Prefix : String
) : Boolean;



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
  StrToInt
  ---------------------------------------------------------------------------

  Function

    Converts a string into an integer.

  Parameters

    Str        The string to convert.

  Remarks

    A convenience function to save a variable when the resulting string is
    used as a parameter in another function or procedure.

    Logs an error message if the conversion doesn't succeed. The result of
    the conversion is returned in the StrResult variable.
}

function StrToInt(
  Str : String
) : LongInt;



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



{
  ---------------------------------------------------------------------------
  StrCopyChr
  ---------------------------------------------------------------------------

  Function

    Copies a substring from the beginning of the original string.

  Parameters

    Src        The original string.

    Splitter   A string which marks the end of the substring.

    Returns    The substring.

  Remarks

    The length of the substring is defined by the position of the splitter.
    The original string doesn't change.

    If the splitter is not found inside the original string, returns the
    original string.
}
function StrCopyChr(
  Src : String;
  Splitter : String
) : String;



{
  ---------------------------------------------------------------------------
  StrCutChr
  ---------------------------------------------------------------------------

  Function

    Cuts a substring from the beginning of the original string.

  Parameters

    Src        The original string.

    Splitter   A string which marks the end of the substring.

    Returns    The substring.

  Remarks

    The length of the substring is defined by the position of the splitter.
    The substring and the splitter are removed from the original string.

    If the splitter is not found inside the original string, returns the
    original string, and the original string is emptied.
}

function StrCutChr(
  var Src : String;
  Splitter : String
) : String;



implementation



function StrBegins(
  Str,
  Prefix : String
) : Boolean;

begin
  if (Length(Str) = 0) or (Length(Prefix) = 0) then
  begin
    StrBegins := false
  end
  else
  begin
    StrBegins := Prefix = Copy(Str, 1, Length(Prefix));
  end
end;



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



function StrToInt(
  Str : String
) : LongInt;

var
  I : LongInt;
  E, Ee : Integer;

begin
  Val(Str, I, E);
  if E > 0 then
  begin
{    Log(logWarn, 'Number format error in "' + Str + '" at ' + IntToStr(E));}
    Writeln('Number format error in "' + Str + '" at ' + IntToStr(E));
    StrResult := strErrNumFormat;
  end;
  StrToInt := I;
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



function StrCopyChr(
  Src : String;
  Splitter : String
) : String;

var
  Idx : Byte;

begin
  Idx := Pos(Splitter, Src);
  if Idx <= 0 then
    Idx := Length(Src) + 1;
  StrCopyChr := Copy(Src, 1, Idx - 1);
end;



function StrCutChr(
  var Src : String;
  Splitter : String
) : String;

var
  Res : String;

begin
  Res := StrCopyChr(Src, Splitter);
  Delete(Src, 1, Length(Res) + Length(Splitter));
  StrCutChr := Res;
end;


end.