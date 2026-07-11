program FF2505;

uses
  Metadata, Strs;

const
  Filename = 'INPUT05.TXT';

type
  TTunnel = record
    C : Char;
    N : Byte;
    V : Boolean;
  end;

  TTunnels = array[1..255] of TTunnel;

var
  Meta : TMetadata;

procedure ReadTunnel(
  var Tunnels : TTunnels;
  var NumTunnels : Byte
);

var
  S : String;
  I, J : Byte;

begin
  OpenInput(Meta, 1);
  S := ReadInpStr;
  CloseInput;

  NumTunnels := Length(S);

  for I := 1 to NumTunnels do
  begin
    Tunnels[I].C := S[I];
    Tunnels[I].V := false;
  end;

  for I := 1 to NumTunnels do
    for J := 1 to NumTunnels do
      if (Tunnels[I].C = Tunnels[J].C) and (I <> J) then
        Tunnels[I].N := J;
end;

var
  Tunnels : TTunnels;
  NumTunnels : Byte;
  Idx : Byte;
  AnsPt1, AnsPt3 : LongInt;
  AnsPt2 : String;

begin
  Meta.ID := 'FF__2505';
  ReadMetadata(Meta);
  ReadTunnel(Tunnels, NumTunnels);

  Idx := 1;
  AnsPt1 := 0;
  AnsPt3 := 0;
  repeat
    Tunnels[Idx].V := true;
    AnsPt1 := AnsPt1 + Abs(Tunnels[Idx].N - Idx);
    if Tunnels[Idx].C = UpCase(Tunnels[Idx].C) then
      AnsPt3 := AnsPt3 - Abs(Tunnels[Idx].N - Idx)
    else
      AnsPt3 := AnsPt3 + Abs(Tunnels[Idx].N - Idx);
    Idx := Tunnels[Idx].N;
    Tunnels[Idx].V := true;
    Inc(Idx);
  until Idx > NumTunnels;

  AnsPt2 := '';
  for Idx := 1 to NumTunnels do
    if (not Tunnels[Idx].V) and (Pos(Tunnels[Idx].C, AnsPt2) = 0) then
      AnsPt2 := AnsPt2 + Tunnels[Idx].C;

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, AnsPt2);
  LogAnswer(Meta, 3, IntToStr(AnsPt3));
end.