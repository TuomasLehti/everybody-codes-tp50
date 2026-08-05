{
  ---------------------------------------------------------------------------
  UInt512
  ---------------------------------------------------------------------------

  Function

    A 512-bit (64-byte) unsigned integer.
}
unit UInt512;



interface



uses
  Logging, Strs;



type


{
  ---------------------------------------------------------------------------
  TUInt512 - array
  ---------------------------------------------------------------------------

  Function

    A 512-bit (64-byte) unsigned integer.

  Remarks

    Little-endian.
}
  TUInt512 = array[0..63] of Byte;



{
  ---------------------------------------------------------------------------
  ZeroUInt512
  ---------------------------------------------------------------------------

  Function

    Zeroes a TUInt512.

  Parameters

    Int        The integer to be zeroed.
}
procedure ZeroUInt512(
  var Int : TUInt512
);


{
  ---------------------------------------------------------------------------
  IntToUInt512
  ---------------------------------------------------------------------------

  Function

    Converts an integer type to TUInt512.

  Parameters

    Int        Any integer type (ShortInt, Byte, Integer, Word, LongInt).

    Result     The resulting TUInt512.

  Remarks

    Negative values will log an error message and halt the program.
}
procedure IntToUInt512(
  Int : LongInt;
  var Result : TUInt512
);


{
  ---------------------------------------------------------------------------
  AddUInt512s
  ---------------------------------------------------------------------------

  Function

    Adds two UInt512s.

  Parameters

    One        One of UInt512s to be added.

    Other      Other of UInt512s to be added.

    Result     The two UInt512s added together.

  Remarks

    On overflow logs an error and halts.
}
procedure AddUInt512s(
  One, Other : TUInt512;
  var Result : TUInt512
);


{
  ---------------------------------------------------------------------------
  MultUInt512s - procedure
  ---------------------------------------------------------------------------

  Function

    Multiplies two UInt512s.

  Parameters

    One        One of UInt512s to be multiplied.

    Other      Other of UInt512s to be multiplied.

    Result     The two UInt512s multiplied together.

  Remarks

    On overflow logs an error and halts.

}
procedure MultUInt512s(
  One, Other : TUInt512;
  var Result : TUInt512
);



{
  ---------------------------------------------------------------------------
  DivUInt512By10
  ---------------------------------------------------------------------------

  Function

    Divides an TUInt512 by 10.

  Parameters

    Dividend   The integer to be divided.

    Quotient   The result of the integer division.

    Remadinder The remainder of the integer division.

  Remarks

    Used in conversion to decimal string representation.
}
procedure DivUInt512By10(
  Dividend : TUInt512;
  var Quotient : TUInt512;
  var Remainder : Byte
);


{
  ---------------------------------------------------------------------------
  UInt512IsZero
  ---------------------------------------------------------------------------

  Function

    Checks if a TUInt512 is zero.

  Parameters

    Int        The integer to be checked.

  Returns

    True if zero.
}
function UInt512IsZero(
  Int : TUInt512
) : Boolean;



{
  ---------------------------------------------------------------------------
  UInt512ToDecStr
  ---------------------------------------------------------------------------

  Function

    Convers a TUInt512 to decimal string.

  Parameters

    Int        The integer to be converted.

  Returns

    The integer as a decimal number in string format.
}
function UInt512ToDecStr(
  Int : TUInt512
) : String;




implementation



procedure ZeroUInt512(
  var Int : TUInt512
);

var
  Idx : Byte;

begin
  for Idx := 0 to 63 do
    Int[Idx] := 0;
end;




procedure IntToUInt512(
  Int : LongInt;
  var Result : TUInt512
);

begin
  if Int < 0 then
  begin
    SLog(logError, 'Negative TUInt512 not allowed.');
    Halt;
  end;
  ZeroUInt512(Result);
  Result[0] := Int mod 256;
  Result[1] := (Int div 256) mod 256;
  Result[2] := ((Int div 256) div 256) mod 256;
  Result[3] := (((Int div 256) div 256) div 256);
end;



procedure AddUInt512s(
  One, Other : TUInt512;
  var Result : TUInt512
);

var
  Idx, Carry : Byte;
  SumOfDigits : Word;

begin
  Carry := 0;
  for Idx := 0 to 63 do
  begin
    SumOfDigits := One[Idx] + Other[Idx] + Carry;
    Result[Idx] := SumOfDigits mod 256;
    Carry := SumOfDigits div 256;
  end;
  if Carry > 0 then
  begin
    SLog(logError, 'UInt512 overflow.');
    Halt;
  end;
end;



procedure MultUInt512s(
  One, Other : TUInt512;
  var Result : TUInt512
);

var
  Idx, RowIdx, ShiftIdx, Carry : Byte;
  ProdOfDigits : Word;
  Acc, Row : TUint512;

begin
  ZeroUInt512(Acc);
  ZeroUInt512(Row);
  Carry := 0;

  { RowIdx defines which digit of Other is being multiplied.
    It also affects the starting place of the digits in the current
    row. }

  for RowIdx := 0 to 63 do
  begin
    for Idx := 0 to 63 do
    begin
      ProdOfDigits := Carry + One[Idx] * Other[RowIdx];
      Row[Idx] := ProdOfDigits mod 256;
      Carry := ProdOfDigits div 256;
    end;
    if RowIdx > 0 then
      for ShiftIdx := 0 to RowIdx - 1 do
      begin
        for Idx := 63 downto 1 do
          Row[Idx] := Row[Idx - 1];
        Row[0] := 0;
      end;
    AddUInt512s(Acc, Row, Acc);
    ZeroUInt512(Row);
  end;
  Result := Acc;
end;



procedure DivUInt512By10(
  Dividend : TUInt512;
  var Quotient : TUInt512;
  var Remainder : Byte
);

var
  Idx, Rem : Byte;


begin
  ZeroUInt512(Quotient);
  Rem := 0;
  for Idx := 63 downto 0 do
  begin
    Quotient[Idx] := (Dividend[Idx] + Rem * 256) div 10;
    Rem := (Dividend[Idx] + Rem * 256) mod 10;
  end;
  Remainder := Rem;
end;


function UInt512IsZero(
  Int : TUInt512
) : Boolean;

var
  Idx : Byte;

begin
  for Idx := 0 to 63 do
    if Int[Idx] <> 0 then
    begin
      UInt512IsZero := false;
      Exit;
    end;
  UInt512IsZero := true;
end;



function UInt512ToDecStr(
  Int : TUInt512
) : String;

var
  S : String;
  Quot : TUInt512;
  Rem : Byte;

begin
  S := '';
  repeat
    DivUInt512By10(Int, Int, Rem);
    S := IntToStr(Rem) + S;
  until UInt512IsZero(Int);
  UInt512ToDecStr := S;
end;

end.
