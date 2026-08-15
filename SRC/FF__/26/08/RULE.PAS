uses
  UInt512;


type

  TRule = record
    EvolvesTo : String[7];
    Lengths : array[1..21] of TUInt512;
  end;

  PRule = ^TRule;

  TRules = array['A'..'J', 'A'..'J'] of PRule;



procedure NewRules(
  var Rules : TRules
);

var
  First, Second : Char;

begin
  for First := 'A' to 'J' do
    for Second := 'A' to 'J' do
      New(Rules[First, Second]);
end;



procedure DisposeRules(
  var Rules : TRules
);

var
  First, Second : Char;

begin
  for First := 'A' to 'J' do
    for Second := 'A' to 'J' do
      Dispose(Rules[First, Second]);
end;




procedure ClearRules(
  var Rules : TRules
);

var
  First, Second : Char;
  Generation : Byte;

begin
  for First := 'A' to 'J' do
    for Second := 'A' to 'J' do
      with Rules[First, Second]^ do
      begin
        EvolvesTo := '';
        for Generation := 1 to 21 do
          ZeroUInt512(Lengths[Generation]);
      end;
end;



procedure ReadRules(
  Filename : String;
  var Rules : TRules
);

var
  T : Text;
  S, E : String;
  First, Second : Char;

begin
  Assign(T, Filename);
  Reset(T);
  while not Eof(T) do
  begin
    ReadLn(T, S);

    First := S[1];
    Second := S[3];
    Delete(S, 1, 4);
    E := '';
    while Length(S) > 0 do
    begin
      E := E + Copy(S, 1, 1);
      Delete(S, 1, 2);
    end;
    Rules[First, Second]^.EvolvesTo := First + E + Second;
    Rules[Second, First]^.EvolvesTo := Second + E + First;
  end;
  Close(T);
end;



procedure DecUInt512(
  var Acc : TUInt512
);

var
  Idx : Byte;

begin
  for Idx := 0 to 63 do
  begin
    if Acc[Idx] > 0 then
    begin
      Dec(Acc[Idx]);
      Exit;
    end
    else
      Acc[Idx] := 255;
  end;
  WriteLn('UInt512 underflow');
  Halt;
end;



procedure GetLength(
  var Rules : TRules;
  First, Second : Char;
  Generation : Byte;
  var Result : TUInt512
);

var
  Idx : Byte;
  Acc, One, Len : TUInt512;

begin
  IntToUInt512(1, One);
  with Rules[First, Second]^ do
  begin
    if UInt512IsZero(Lengths[Generation]) then
      if Generation = 1 then
      begin
        IntToUInt512(Length(EvolvesTo), Lengths[Generation]);
      end
      else
      begin
        ZeroUInt512(Acc);
        for Idx := 1 to Length(EvolvesTo) - 1 do
        begin
          GetLength(
            Rules,
            EvolvesTo[Idx],
            EvolvesTo[Idx+1],
            Generation-1,
            Len
          );
          DecUInt512(Len);

          AddUInt512s(
            Acc, Len, Acc
          );
        end;
        AddUInt512s(Acc, One, Acc);
        Lengths[Generation] := Acc;
      end;

    Result := Lengths[Generation];
  end;
end;



var
  Rules : TRules;
  I, J: Char;
  Generation : Byte;
  Res : TUInt512;

begin
  NewRules(Rules);
  ClearRules(Rules);
  ReadRules(ParamStr(1), Rules);

  for Generation := 1 to 21 do
  begin
    GetLength(Rules, 'A', 'B', Generation, Res);
    WriteLn(Generation, ': ', UInt512ToDecStr(Res));
  end;
  DisposeRules(Rules);
end.

