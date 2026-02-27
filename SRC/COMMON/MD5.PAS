{
  An implementation of the Md5 algorithm. This implementation contains
  shortcuts.
}

unit Md5;



interface


{
  Converts a LongInt to a hexadecimal string.
}
function LongIntToHexStr(
  I : LongInt
) : String;



function LongIntToBinStr(
  I : LongInt
) : String;



{
  Performs the calculation 2 to the power of Amt.
}
function Pow2(
  Amt : Byte
) : LongInt;



{
  Performs a logical left rotation of Num.
}
function RotateLeft(
  Num : LongInt;
  Amt : Byte
) : LongInt;



implementation



function LongIntToHexStr(
  I : LongInt
) : String;

const
  HexDigits : String = '0123456789ABCDEF';

begin
  LongIntToHexStr :=
    HexDigits[((I and $F0000000) SHR 28) + 1]
    + HexDigits[((I and $0F000000) SHR 24) + 1]
    + HexDigits[((I and $00F00000) SHR 20) + 1]
    + HexDigits[((I and $000F0000) SHR 16) + 1]
    + HexDigits[((I and $0000F000) SHR 12) + 1]
    + HexDigits[((I and $00000F00) SHR 8) + 1]
    + HexDigits[((I and $000000F0) SHR 4) + 1]
    + HexDigits[(I and $0000000F) + 1];
end;



function LongIntToBinStr(
  I : LongInt
) : String;

var
  Idx : Byte;
  Pow : LongInt;
  Res : String;

begin
  Res := '';
  for Idx := 31 downto 0 do
  begin
    Pow := Pow2(Idx);
    if (I and Pow) = Pow then
      Res := Res + '1'
    else
      Res := Res + '0';
    if (Idx > 0) and ((Idx MOD 4) = 0) then
      Res := Res + '_';
  end;
  LongIntToBinStr := Res;
end;



function Pow2(
  Amt : Byte
) : LongInt;

const
  UInt64One : LongInt = $00000001;

begin
  Pow2 := UInt64One SHL Amt
end;



function RotateLeft(
  Num : LongInt;
  Amt : Byte
) : LongInt;

var
  TopBitMask, TopBits : LongInt;

begin
  TopBitMask := (Pow2(Amt) - 1) SHL (32 - Amt);
  TopBits := Num AND TopBitMask;
  RotateLeft := Num SHL Amt + (TopBits SHR (32 - Amt));
end;



end.