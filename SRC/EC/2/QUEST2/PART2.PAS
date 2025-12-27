program Part2;

const
  maxBalloons = 256;
  maxRepeats = 100;
  maxTotBalloons = maxBalloons * maxRepeats;

var
  numBalloons : Integer;
  numRepeats : Integer;
  totBalloons : INteger;

var
  Balloons : array[0..maxBalloons - 1] of Char;

type
  TPopped = array[0..maxTotBalloons] of Boolean;
  PPopped = ^TPopped;

var
  Popped : PPopped;



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

  The algorighm keeps track of balloons which have been popped.
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

begin
  New(Popped);
  numBalloons := numBs;
  numRepeats := numRs;
  totBalloons := numBalloons * numRepeats;
  ReadBalloons(InputFnm);

  for LIdx := 0 to totBalloons - 1 do
    Popped^[LIdx] := false;

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
        Popped^[RIdxDbl div 2] := true;
        BalloonsLeft := BalloonsLeft - 1;
        RIdxDbl := RIdxDbl + 2;
      end
      else
        RIdxDbl := RIdxDbl + 1;

    end
    else
      RIdxDbl := RIdxDbl + 1;

    { The balloon at the top always pops. }

    Popped^[LIdx] := true;
    BalloonsLeft := BalloonsLeft - 1;

    LIdx := LIdx + 1;
    while Popped^[LIdx] do
      LIdx := LIdx + 1;

    BoltIdx := BoltIdx + 1;

  end;

  Dispose(Popped);
  SolvePart2 := BoltIdx;

end;



begin
  WriteLn('Everybody Codes');
  WriteLn('Story 2: The Entertainment Hub');
  WriteLn('Quest 2: The Pocket-Money Popper');
  WriteLn(
    'Part 2: ',
    SolvePart2(256, 100, 'PART2.TXT')
  );
end.
