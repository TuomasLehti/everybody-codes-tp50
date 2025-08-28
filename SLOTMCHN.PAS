{
  A Slot Machine from Everybody Codes Story 2, Quest 1.

  Most of the code is hidden in the implementation section.

}
unit SlotMchn;

interface

{ Hard coded maximum values from parts 2 and 3 define the maximum capacity
  of the grid and the array of coins. Memory is allocated according to the
  actual values from the calling problem, however. }

const
  maxRows = 20;
  maxCols = 39;
  maxSlots = 20;
  maxCoins = 100;
  maxCoinLen = 20;

{ Actual values deduced from the actual input. }

var
  NumRows : Byte;
  NumCols : Byte;
  NumSlots : Byte;
  NumCoins : Byte;

{ Parses the EC input and initializes the slot machine. Each input has
  different amounts rows and columns and coins, which must be provided
  through parameters. }

procedure Parse(
  inputFnm : String
);

{ Plays a round on the slot machine. CoinIdx is the index of a coin. Slot
  is the slot in which the coin in question is inserted. Returns the score
  of this insertion. }

function Play(
  CoinIdx : Byte;
  Slot : Byte
) : Integer;

implementation



type
  TRow = String[maxCols];
  TMachine = array[1..maxRows] of TRow;
  TCoin = String[maxCoinLen];
  TCoins = array[1..maxCoins] of TCoin;



var
  Machine : TMachine;
  Coins : TCoins;



procedure Parse;

type
  TState = (sMachine, sCoins);

var
  EcInp : Text;
  Line : String;
  State : TState;
  Idx : Byte;

begin
  Assign(EcInp, inputFnm);
  Reset(EcInp);
  State := sMachine;
  Idx := 0;
  while not Eof(EcInp) do
  begin
    ReadLn(EcInp, Line);
    Idx := Idx + 1;

    if (State = sMachine) and (Idx = 1) then
    begin
      NumCols := Length(Line);
      NumSlots := (NumCols div 2) + 1;
    end;

    if Line = '' then
    begin
      NumRows := Idx;
      State := sCoins;
      Idx := 0;
    end

    else if State = sMachine then
      Machine[Idx] := Line

    else
      Coins[Idx] := Line;
  end;
  NumCoins := Idx;
  Close(EcInp);
end;


function Play(CoinIdx, Slot : Byte) : Integer;
var
  X, Y, BehaviourIdx, FinalSlot : Byte;
  Coin : String;
  Score : Integer;
begin
  Coin := Coins[CoinIdx];
  X := Slot * 2 - 1;
  BehaviourIdx := 0;
  for Y := 1 to numRows + 1 do
  begin
    if Machine[Y][X] = '*' then
    begin
      BehaviourIdx := BehaviourIdx + 1;
      if Coin[BehaviourIdx] = 'R' then
        if X = numCols then
          X := X - 1
        else
          X := X + 1
      else
        if X = 1 then
          X := X + 1
        else
          X := X - 1;
    end;
  end;
  Score := ((X + 1) div 2) * 2 - Slot;
  if (Score < 0) then
    Score := 0;
  Play := Score;
end;

end.