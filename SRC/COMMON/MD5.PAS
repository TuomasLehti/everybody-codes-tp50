{
  A simplified implementation of the MD5 algorithm for use in the first
  few years of Advent of Code.

  The biggest limitation is that the length of the message is limited to
  55 bytes.
}

unit Md5;



interface



uses
  Logging;



const



  bitsPerBlock = 512;



  bytesPerBlock = bitsPerBlock / 8;



type


{
  The message to be hashed is divided into 64-byte (512-bit) blocks.
}
    TMd5Msg = array[0..63] of Byte;

{
  ---------------------------------------------------------------------------
  IntToHexStr - function
  ---------------------------------------------------------------------------

  Function

    Returns a hexadecimal representation of an integer.

  Parameters

    Num        The number to be converted.

    Returns    The hex string.

  Remarks

    No prefix or suffix markings such as 0x or $ are returned.
}
function IntToHexStr(
  Num : LongInt
) : String;



{
  ---------------------------------------------------------------------------
  LeftRotate - function
  ---------------------------------------------------------------------------

  Function

    Bitwise rotate left operation on an LongInt.

  Parameters

    Num        The LongInt to rotate.

    Amt        The number of bits to rotate by.

    Returns    The rotated LongInt.
}
function LeftRotate(
  Num : LongInt;
  Amt : Byte
) : LongInt;



{
  ---------------------------------------------------------------------------
  StrToMd5Msg - procedure
  ---------------------------------------------------------------------------

  Function

    Converts a string to a Md5 message.

  Parameters

    S          The string to convert.

    Msg        The message.

  Remarks

    See PadMsg procedure.
}
procedure StrToMd5Msg(
  S : String;
  var Msg : TMd5Msg
);


{
  ---------------------------------------------------------------------------
  PadMsg
  ---------------------------------------------------------------------------

  Function

    Pads a message.

  Parameters

    Msg        The bytes of the message to be padded as a null-terminated
               array of bytes.

  Remarks

    The length of the message must be at most 55 bytes, not including the
    null terminator. Messages longer than this will be truncated and an
    error message will be logged.
}
procedure PadMsg(
  var Msg : TMd5Msg
);



{
  ---------------------------------------------------------------------------
  CountMd5 - function
  ---------------------------------------------------------------------------

  Function

    Counts the MD5 hash of a message.

  Parameters

    Msg        The message to be hashed.

    Returns    The hash.
}
function CountMd5(
  Msg : TMd5Msg
) : String;



implementation



function IntToHexStr(
  Num : LongInt
) : String;

{ Not a string because we need 0-indexing. }

const
  HexDigits : array[0..15] of Char = '0123456789ABCDEF';

var
  B : array[0..4] of Byte absolute Num;
  Res : String;

begin
  Res :=
    HexDigits[(B[3] and $F0) shr 4]
    + HexDigits[(B[3] and $0F)]
    + HexDigits[(B[2] and $F0) shr 4]
    + HexDigits[(B[2] and $0F)]
    + HexDigits[(B[1] and $F0) shr 4]
    + HexDigits[(B[1] and $0F)]
    + HexDigits[(B[0] and $F0) shr 4]
    + HexDigits[(B[0] and $0F)];
  IntToHexStr := Res;
end;



procedure SwitchEndianness(
  var Num : LongInt
);

var
  TmpNum : LongInt;
  TmpBytes : array[0..4] of Byte absolute TmpNum;
  NumBytes : array[0..4] of Byte absolute Num;

begin
  TmpNum := Num;
  NumBytes[0] := TmpBytes[3];
  NumBytes[1] := TmpBytes[2];
  NumBytes[2] := TmpBytes[1];
  NumBytes[3] := TmpBytes[0];
end;



procedure StrToMd5Msg(
  S : String;
  var Msg : TMd5Msg
);

var
  I, Amt : Byte;
  Buf : array[0..15] of LongInt absolute Msg;

begin
  for I := 1 to Length(S) do
    Msg[I - 1] := Ord(S[I]);
  Msg[Length(S)] := 0;
  PadMsg(Msg);
end;



procedure PadMsg(
  var Msg : TMd5Msg
);

var
  I, Len : Byte;

begin
  I := 0;
  while (I < 55) and (Msg[I] <> $00) do
    Inc(I);
  if Msg[I] <> $00 then
    SLog(logError, 'Md5 message too long, truncating');
  Len := I;
  Msg[I] := $80; { 1000_0000 in binary }

  Inc(I);
  while (I < 64) do
  begin
    Msg[I] := 0;
    Inc(I);
  end;

  Msg[56] := (Len * 8) mod 256;
  Msg[57] := (Len * 8) div 256;
  Msg[58] := 0;
  Msg[59] := 0;
  Msg[60] := 0;
  Msg[61] := 0;
  Msg[62] := 0;
  Msg[63] := 0;
end;



function LeftRotate(
  Num : LongInt;
  Amt : Byte
) : LongInt;

begin
  LeftRotate := ((Num shl Amt) or (Num shr (32 - Amt)));
end;



function CountMd5(
  Msg : TMd5Msg
) : String;

{ Initialization of the sine table. }

type
  TKs = array[0..63] of LongInt;

const
  K : TKs = (
    $D76AA478, $E8C7B756, $242070DB, $C1BDCEEE,
    $F57C0FAF, $4787C62A, $A8304613, $FD469501,
    $698098D8, $8B44F7AF, $FFFF5BB1, $895CD7BE,
    $6B901122, $FD987193, $A679438E, $49B40821,
    $F61E2562, $C040B340, $265E5A51, $E9B6C7AA,
    $D62F105D, $02441453, $D8A1E681, $E7D3FBC8,
    $21E1CDE6, $C33707D6, $F4D50D87, $455A14ED,
    $A9E3E905, $FCEFA3F8, $676F02D9, $8D2A4C8A,
    $FFFA3942, $8771F681, $6D9D6122, $FDE5380C,
    $A4BEEA44, $4BDECFA9, $F6BB4B60, $BEBFBC70,
    $289B7EC6, $EAA127FA, $D4EF3085, $04881D05,
    $D9D4D039, $E6DB99E5, $1FA27CF8, $C4AC5665,
    $F4292244, $432AFF97, $AB9423A7, $FC93A039,
    $655B59C3, $8F0CCC92, $FFEFF47D, $85845DD1,
    $6FA87E4F, $FE2CE6E0, $A3014314, $4E0811A1,
    $F7537E82, $BD3AF235, $2AD7D2BB, $EB86D391
  );

{ Initialization of the per-round shift amounts. }

type
  TSs = array[0..63] of Byte;

const
  S : TSs = (
     7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
     5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
     4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
     6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21
  );

{ Initialization of the 128-bit state on which the algorithm operates. }

const
  A0 = $67452301;
  B0 = $EFCDAB89;
  C0 = $98BADCFE;
  D0 = $10325476;

{ The message is handled as sixteen little-endian 32-bit words. }

type
  TChunk = array[0..15] of LongInt;

var
  Chunk : TChunk absolute Msg;
  Round : Byte;
  A, B, C, D, F : LongInt;
  G : Byte;

begin

  A := A0;
  B := B0;
  C := C0;
  D := D0;

  for Round := 0 to 63 do
  begin

    if Round <= 15 then
    begin
      F := (B and C) or ((not B) and D);
      G := Round;
    end
    else if Round <= 31 then
    begin
      F := (D and B) or ((not D) and C);
      G := (5 * Round + 1) mod 16;
    end
    else if Round <= 47 then
    begin
      F := B xor C xor D;
      G := (3 * Round + 5) mod 16;
    end
    else
    begin
      F := C xor (B or (not D));
      G := (7 * Round) mod 16;
    end;
    F := F + A + K[Round] + Chunk[G];
    A := D;
    D := C;
    C := B;
    B := B + LeftRotate(F, S[Round]);

  end;

  {
    Use A, B, C, D instead of A0, B0, C0, D0, because x0 are constants.
    They are true constants, because their state is retained between calls
    to this procedure, if they are variables defined in the const section.
  }

  A := A0 + A;
  B := B0 + B;
  C := C0 + C;
  D := D0 + D;

  {
    So far everything has been big-endian. Switch to little-endian for
    the final hash.
  }

  SwitchEndianness(A);
  SwitchEndianness(B);
  SwitchEndianness(C);
  SwitchEndianness(D);

  CountMd5 :=
    IntToHexStr(A)
    + IntToHexStr(B)
    + IntToHexStr(C)
    + IntToHexStr(D);
end;



end.