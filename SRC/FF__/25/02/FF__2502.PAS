{@
------------------------------------------------------------------------
Ff__2502 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2015, second puzzle.

Usage

  FF__2502

See

  https://flipflop.slome.org/2025/1
}

program Ff__2501;



uses
  Strs, Logging, Metadata;



type
  TState = (start, up, down);



  TFib = array[0..1023] of Word;




procedure PreCountFib(
  var Fib : TFib
);

var
  Idx : Word;

begin
  Fib[0] := 0;
  Fib[1] := 1;
  for Idx := 2 to 1023 do
    Fib[Idx] := Fib[Idx - 1] + Fib[Idx - 2];
end;


var
  Meta : TMetadata;
  T : Text;
  C : Char;
  H, H2, H3 : LongInt;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;
  State : TState;
  Amount, FibIdx : Word;
  Fib : TFib;


begin
  Meta.ID := 'FF__2502';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);

  AnsPt1 := 0;
  AnsPt2 := 0;
  AnsPt3 := 0;
  H := 0;
  H2 := 0;
  H3 := 0;
  State := start;
  PreCountFib(Fib);

  while not InpEof do
  begin
    C := ReadInpChar;

    { Part 1. }

    if C = '^' then
      Inc(H)
    else if C = 'v' then
      Dec(H);
    if H > AnsPt1 then
      AnsPt1 := H;

    { Parts 2 and 3. }

    if State = start then
    begin
      FibIdx := 1;
      Amount := 1;
      if C = '^' then
      begin
        State := up;
        H2 := H2 + Amount;
      end;
      if C = 'v' then
      begin
        State := down;
        H2 := H2 - Amount;
      end;
    end
    else if State = up then
    begin
      if C = '^' then
      begin
        Inc(Amount);
        Inc(FibIdx);
        H2 := H2 + Amount;
      end
      else if C = 'v' then
      begin
        H3 := H3 + Fib[FibIdx];
{        Writeln(Amount, ' up -> ', Fib[FibIdx], ' -> ', H3);}
        State := down;
        Amount := 1;
        FibIdx := 1;
        H2 := H2 - Amount;
      end;
    end
    else if State = down then
    begin
      if C = 'v' then
      begin
        Inc(Amount);
        Inc(FibIdx);
        H2 := H2 - Amount;
      end
      else if C = '^' then
      begin
        H3 := H3 - Fib[FibIdx];
{        Writeln(Amount, ' down -> ', Fib[FibIdx], ' -> ', H3);}
        State := up;
        Amount := 1;
        FibIdx := 1;
        H2 := H2 + Amount;
      end;
    end;
    if H2 > AnsPt2 then
      Anspt2 := H2;
    if H3 > AnsPt3 then
      AnsPt3 := H3;
  end;

  if State = down then
  begin
    H3 := H3 - Fib[FibIdx];
{    Writeln(Amount, ' down -> ', H3);}
  end
  else
  begin
    H3 := H3 + Fib[FibIdx];
{    Writeln(Amount, ' down -> ', H3);}
  end;
  if H3 > AnsPt3 then
    AnsPt3 := H3;

  CloseInput;

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
  LogAnswer(Meta, 3, IntToStr(AnsPt3));

end.