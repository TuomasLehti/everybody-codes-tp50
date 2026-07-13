{@
------------------------------------------------------------------------
Ff__2603 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2026, third puzzle.

Usage

  FF__2603

See

  https://flipflop.slome.org/2026/3
}


program Ff__2603;



uses
  Strs, Logging, Metadata, Structs;


function PwdHas(
  Pwd, Chrs : String
) : Boolean;
var
  Idx : Byte;
begin
  for Idx := 1 to Length(Pwd) do
    if Pos(Copy(Pwd, Idx, 1), Chrs) > 0 then
    begin
      PwdHas := true;
      Exit;
    end;
  PwdHas := false;
end;



function CountScorePt1(
  Pwd : String
) : Word;

var
  Score : Byte;

begin
  Score := 0;
  if PwdHas(Pwd, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') then
    Inc(Score);
  if PwdHas(Pwd, 'abcdefghijklmnopqrstuvwxyz') then
    Inc(Score);
  if PwdHas(Pwd, '0123456789') then
    Inc(Score);
  CountScorePt1 := Score;
end;



function CountScorePt2(
  Pwd : String
) : Word;

  function LongestRun(
    Pwd : String
  ) : Byte;
  var
    Idx, Run, MaxRun : Byte;
  begin
    MaxRun := 0;
    Run := 1;
    for Idx := 1 to Length(Pwd) - 1 do
    begin
      if Pwd[Idx] = Pwd[Idx + 1] then
        Inc(Run)
      else
      begin
        if Run > MaxRun then
          MaxRun := Run;
        Run := 1;
      end;
    end;
    if Run > MaxRun then
      MaxRun := Run;
    LongestRun := MaxRun;
  end;

var
  Score : Byte;
  MaxRun : Byte;

begin
  Score := CountScorePt1(Pwd);

  if (PwdHas(Pwd, '7')) and (not PwdHas(Pwd, '012345689')) then
    Score := Score + 7;
  MaxRun := LongestRun(Pwd);
  if MaxRun >= 3 then
    Score := Score + MaxRun * MaxRun;
  if
    (Pos('red', Pwd) > 0)
    or (Pos('green', Pwd) > 0)
    or (Pos('blue', Pwd) > 0)
  then
    Score := Score * 3;

  CountScorePt2 := Score;
end;



var
  Meta : TMetaData;
  Pwd,
  MaxPwdPt1, MaxPwdPt2 : String;
  MaxScorePt1, MaxScorePt2, MaxScorePt3,
  ScorePt1, ScorePt2 : Word;

const
  AddedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

var
  AddedScores : array[1..Length(AddedChars)] of Word;
  AddIdx : Byte;
  AddedPwd : String;


begin
  Meta.Id := 'FF__2603';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);
  MaxScorePt1 := 0;
  MaxScorePt2 := 0;
  for AddIdx := 1 to Length(AddedChars) do
    AddedScores[AddIdx] := 0;
  while not InpEof do
  begin
    Pwd := ReadInpStr;

    ScorePt1 := Length(Pwd) * CountScorePt1(Pwd);
    if ScorePt1 > MaxScorePt1 then
    begin
      MaxScorePt1 := ScorePt1;
      MaxPwdPt1 := Pwd;
    end;

    ScorePt2 := Length(Pwd) * CountScorePt2(Pwd);
    if ScorePt2 > MaxScorePt2 then
    begin
      MaxScorePt2 := ScorePt2;
      MaxPwdPt2 := Pwd;
    end;

    for AddIdx := 1 to Length(AddedChars) do
    begin
      AddedPwd := Pwd + Copy(AddedChars, AddIdx, 1);
      AddedScores[AddIdx] := AddedScores[AddIdx]
        + Length(AddedPwd) * CountScorePt2(AddedPwd);
    end;

  end;
  CloseInput;

  MaxScorePt3 := 0;
  for AddIdx := 1 to Length(AddedChars) do
    if AddedScores[AddIdx] > MaxScorePt3 then
      MaxScorePt3 := AddedScores[AddIdx];

  LogAnswer(Meta, 1, MaxPwdPt1);
  LogAnswer(Meta, 2, MaxPwdPt2);
  LogAnswer(Meta, 3, IntToStr(MaxScorePt3));

end.