type
  TDirs = array[0..3999] of Char;

  TArr100 = array[1..100] of Word;

  Parr100 = ^TArr100;

  TArr4000 = array[0..3999] of Byte;

  PArr4000 = ^TArr4000;

var
  T : File;
  C : Char;
  P, PP, Pt2 : Word;
  Wall : PArr100;
  Laser, Robot : PArr4000;
  Max, MaxIdx : Word;
  Dirs : TDirs;


procedure Part3(
  Dirs : TDirs
);

var
  Idx, Xdi, TileIdx : Word;
  TilePos : PArr100;
  TileWarmth : PArr100;
  LaserPos : Byte;

begin
  New(TilePos);
  New(TileWarmth);
  for Idx := 1 to 100 do
  begin
    TilePos^[Idx] := Idx;
    TileWarmth^[Idx] := 0;
  end;

  LaserPos := 1;
  for Idx := 0 to 3999 do
  begin

    if Dirs[Idx] = '<' then
      if LaserPos = 1 then
        LaserPos := 100
      else
        Dec(LaserPos)
    else
      if LaserPos = 100 then
        LaserPos := 1
      else
        Inc(LaserPos);

    Xdi := 3999 - Idx;
    for TileIdx := 1 to 100 do
      if Dirs[Xdi] = '<' then
        if TilePos^[TileIdx] = 1 then
          TilePos^[TileIdx] := 100
        else
          Dec(TilePos^[TileIdx])
      else
        if TilePos^[TileIdx] = 100 then
          TilePos^[TileIdx] := 1
        else
          Inc(TilePos^[TileIdx]);

    for TileIdx := 1 to 100 do
      if TilePos^[TileIdx] = LaserPos then
        Inc(TileWarmth^[TileIdx])


  end;

  Max := 0;
  MaxIdx := 0;
  for TileIdx := 1 to 100 do
    if TileWarmth^[TileIdx] > Max then
    begin
      Max := TileWarmth^[TileIdx];
      MaxIdx := TileIdx;
    end;

  Writeln('Part 3: ', Max, ' * ', MaxIdx, ' = ' , Max * MaxIdx);

  Dispose(TilePos);
  Dispose(TileWarmth);
end;



begin
  Assign(T, 'METADATA\FF__\26\02\INPUT02.TXT');
  Reset(T, 1);
  BlockRead(T, Dirs, 4000);
  Close(T);

  New(Laser);
  P := 1;
  for PP := 0 to 3999 do
  begin
    if Dirs[PP] = '<' then
      if P = 1 then
        P := 100
      else
        Dec(P)
    else
      if P = 100 then
        P := 1
      else
        Inc(P);
    Laser^[PP] := P;
  end;

  New(Wall);
  for P := 1 to 100 do
    Wall^[P] := 0;
  for P := 0 to 3999 do
    Inc(Wall^[Laser^[P]]);

  New(Robot);
  P := 1;
  for PP := 3999 downto 0 do
  begin
    if Dirs[PP] = '<' then
      if P = 1 then
        P := 100
      else
        Dec(P)
    else
      if P = 100 then
        P := 1
      else
        Inc(P);
    Robot^[3999 - PP] := P;
  end;

  Pt2 := 0;
  for P := 0 to 3999 do
    if Laser^[P] = Robot^[P] then
      Inc(Pt2);

  Part3(Dirs);

  Max := 0;
  MaxIdx := 0;
  for P := 1 to 100 do
    if Wall^[P] > Max then
    begin
      Max := Wall^[P];
      MaxIdx := P;
    end;

  Writeln('Part 1: ', Max * MaxIdx);
  Writeln('Part 2: ', Pt2);

  Dispose(Robot);
  Dispose(Laser);
  Dispose(Wall);
end.