{ This program solves part 3 of quest 2 of Everybody Codes event 2.

  TODO: Clean up the code.

  TODO: More and clearer comments.

  TODO: Speed up the boolean buffer. This implementation is slow, because it
        writes and reads from disk four times per bolt. This is slow even
        if a ram disk is used. }

program Part3;

uses Crt;

const
  maxBalloons = 256;
  maxRepeats = 100000;
  maxTotBalloons = maxBalloons * maxRepeats;

{
  --- Boolean buffer stuff ---

  This algorigthm requires that we keep track of popped balloons. At the
  start of the part 3 there are 256 balloons which are repeated 100,000
  times, which makes up a circle of nearly 26 million balloons. This clearly
  exceeds the amount of base memory in a PC, which is why the boolean array
  is swapped to disk.

  The number of booleans this implementation is restricted to is a little
  over 2 billion, the exact value being the maximum value a LongInt can
  store. This is plenty for this purpose, since 2 billion > 26 million.
}

const
  bufSize = 256;
  numBufs = (maxBalloons * maxRepeats) div bufSize div 2 div 8 + 1;
  bufFnm = 'D:\SWAP.TMP';

type
  TBoolBuf = array[0..bufSize - 1] of Byte;

var
  BoolBuf : TBoolBuf;
  CurBufNo : LongInt;

procedure IdxBreakDown(
  BoolIdx : LongInt;
  var BufIdx : LongInt;
  var ByteIdx : Word;
  var BitIdx : Byte
);

begin
  ByteIdx := (BoolIdx div 8) mod bufSize;
  BufIdx := (BoolIdx div 8) div bufSize;
  BitIdx := BoolIdx mod 8;
end;


procedure TestIdxBreakDown;
var
  BoolIdx, BufIdx : LongInt;
  ByteIdx : Word;
  BitIdx : Byte;
begin
  for BoolIdx := 4088 to 4104 do begin
    IdxBreakDown(BoolIdx, BufIdx, ByteIdx, BitIdx);
    WriteLn('idx: ', BoolIdx, ' -> ', 'buf: ', BufIdx, ' byte: ', ByteIdx, ' bit: ', BitIdx);
  end;
  Readln;
  Halt;
end;



function FExists(
  var F : file
) : Boolean;

begin
  {$I-}
  Reset(F);
  {$I+}
  FExists := IOResult = 0;
end;



procedure InitBuffer;

var
  I : LongInt;
  Buf : TBoolBuf;
  F : file;

begin
  WriteLn(numBufs);
  for I := 0 to bufSize - 1 do
    Buf[I] := 0;

  Assign(F, bufFnm);
  Rewrite(F, 1);
  for I := 0 to numBufs - 1 do
    BlockWrite(F, Buf, SizeOf(Buf));
  Close(F);

  CurBufNo := -1;
end;



procedure WriteBuffer(
  BufIdx : LongInt;
  BoolBuf : TBoolBuf
);

var
  Swap : file;
  BufPos : LongInt;

begin
  Assign(Swap, bufFnm);
  if not FExists(Swap) then
    InitBuffer;
  Reset(Swap, 1);
  BufPos := BufIdx * BufSize;
  Seek(Swap, BufPos);
  BlockWrite(Swap, BoolBuf, SizeOf(TBoolBuf));
  Close(Swap);
end;


procedure TestWriteBuffer;
var
  B : LongINt;
  F : file;
begin
  Assign(F, 'W.TMP');
  Reset(F, 1);
  Seek(F, 0);
  B := $12345678;
  BlockWrite(F, B, SizeOf(B));
  BlockWrite(F, B, SizeOf(B));
  B := $87654321;
  Seek(F, 0);
  BlockWrite(F, B, SizeOf(B));
  Seek(F, 4);
  BlockWrite(F, B, SizeOf(B));
  Close(F);
  Halt;
end;



procedure ReadBuffer(
  BufIdx : LongInt;
  var BoolBuf : TBoolBuf
);

var
  Swap : file;
  BufPos : LongInt;
  E : Word;

begin
  Assign(Swap, bufFnm);
  if not FExists(Swap) then
    InitBuffer;
  Reset(Swap, 1);
  BufPos := BufIdx * BufSize;
  Seek(Swap, BufPos);
  BlockRead(Swap, BoolBuf, SizeOf(BoolBuf), E);
{  if IOResult > 0 then
  begin
    WriteLn('BufIdx : ', BufIdx);
    WriteLn('BufPos : ', BufPos);
    WriteLn('E : ', E);
  end;}
  Close(Swap);
end;



procedure SwitchBuffer(
  var OldBufIdx : LongInt;
  NewBufIdx : LongInt;
  var BoolBuf : TBoolBuf
);

begin
  if OldBufIdx > -1 then
    WriteBuffer(OldBufIdx, BoolBuf);
  ReadBuffer(NewBufIdx, BoolBuf);
  OldBufIdx := NewBufIdx;
end;



procedure SetBool(
  Idx : LongInt;
  B : Boolean
);

var
  BufIdx : LongInt;
  ByteIdx : Word;
  BitIdx : Byte;

begin
  IdxBreakDown(Idx, BufIdx, ByteIdx, BitIdx);
  if BufIdx <> CurBufNo then
    SwitchBuffer(CurBufNo, BufIdx, BoolBuf);
  BoolBuf[ByteIdx] := BoolBuf[ByteIdx] or (1 shl BitIdx);
end;



function GetBool(
  Idx : LongInt
) : Boolean;

var
  BufIdx : LongInt;
  ByteIdx : Word;
  BitIdx : Byte;

begin
  IdxBreakDown(Idx, BufIdx, ByteIdx, BitIdx);
  if BufIdx <> CurBufNo then
    SwitchBuffer(CurBufNo, BufIdx, BoolBuf);
  GetBool := (BoolBuf[ByteIdx] and (1 shl BitIdx)) = (1 shl BitIdx);
end;


{
  --- Actual Algoritghm For Solving Part 3 ---
}

var
  numBalloons : Integer;
  numRepeats : LongInt;
  totBalloons : LongInt;

var
  Balloons : array[0..maxBalloons - 1] of Char;



procedure ReadBalloons(
  InputFnm : String
);

var
  EcInput : Text;
  I : Integer;

begin
  Assign(EcInput, InputFnm);
  Reset(EcInput);
  for I := 0 to numBalloons - 1 do
    Read(EcInput, Balloons[I]);
  Close(EcInput);
end;



function GetBalloon(
  Idx : LongInt
) : Char;

begin
  GetBalloon := Balloons[Idx mod numBalloons];
end;



{
  This procedure contains the algorithm which solves part 2 (and 3).

  This algorigthm uses two indexes to keep track of where the bolt is
  pointing. The left index starts at the top of the circle of balloons,
  which is the beginning of the array of balloons, if they would be arranged
  in a straiggt line.

  The right index starts at the bottom of the circle, which is the half way
  point in the case of the straight array. At the start there is always an
  even number of balloons.

  In this algorithm the right index is doubled. When the circle has an odd
  number of balloons, the bolt points between two balloons at the bottom.
  This means, that if the double index is odd, the bolt points between
  balloons, and if the double index is even, the bolt points at the balloon
  whose index is the double index divided by two -- the result of that
  division should always be a whole number.

  The algorighm keeps track of balloons which have been popped. Only
  right half of the balloons is needed, because the first balloon of
  the left half is always going to be popped.
}

function SolvePart2(
  numBs : LongInt;
  numRs : LongInt;
  InputFnm : String
) : LongInt;

const
  BOLTS : String = 'RGB';

var
  LIdx, RIdxDbl, BoltIdx : LongInt;
  BalloonsLeft : LongInt;
  I : Integer;
  Buf : file;
  HalfWidth : LongInt;

begin
  InitBuffer;
  numBalloons := numBs;
  numRepeats := numRs;
  totBalloons := numBalloons * numRepeats;
  HalfWidth := totBalloons div 2;
  ReadBalloons(InputFnm);

  LIdx := 0;
  RIdxDbl := (totBalloons div 2) * 2;
  BalloonsLeft := totBalloons;
  BoltIdx := 0;

  while (BalloonsLeft > 0) do
  begin

    { The bolt flies through the top balloon if they are the same color.
      We must find out if the balloon at the bottom pops also. }

    if GetBalloon(LIdx) = BOLTS[BoltIdx mod 3 + 1] then
    begin

      { If the number of remaining balloons is odd, the bolt flies through
        between two balloons. In all other cases the bottom balloon pops:

        If it is the same color as the bolt, the bolt flies through it,
        and because there aren't any more balloons in the bolt's trajectory,
        the bottom balloon pops.

        If it is different color as the bolt, the bottom balloon pops. }

      if (RIdxDbl mod 2) = 0 then
      begin
        SetBool((RIdxDbl div 2) - HalfWidth, true);
        BalloonsLeft := BalloonsLeft - 1;
        RIdxDbl := RIdxDbl + 2;
      end
      else
        RIdxDbl := RIdxDbl + 1;

    end
    else
      RIdxDbl := RIdxDbl + 1;

    { The balloon at the top always pops. }

    BalloonsLeft := BalloonsLeft - 1;

    LIdx := LIdx + 1;
    if LIdx >= HalfWidth then
      while GetBool(LIdx - HalfWidth) do
        LIdx := LIdx + 1;

    BoltIdx := BoltIdx + 1;

    if (BoltIdx mod 10000) = 0 then
      WriteLn(BoltIdx, ' ', (BalloonsLeft / totBalloons) * 100 : 2 : 2);

  end;

  SolvePart2 := BoltIdx;

end;



var
  I : Integer;

begin
  WriteLn(
    SolvePart2(256, 100000, 'PART3.TXT')
  );
  Close(Output);
end.
