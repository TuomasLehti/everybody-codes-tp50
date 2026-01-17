unit Present;


interface


uses
  Strs;


type
  TPresent = record
    Width, Height, Length : Integer;
  end;



procedure InpToPresent(
  Inp : String;
  var Pr : TPresent
);



function WrappingNeeded(
  Pr : TPresent
) : LongInt;



function RibbonNeeded(
  Pr : TPresent
) : LongInt;



implementation



function Min(
  A, B : LongInt
) : LongInt;

begin
  if A <= B then
    Min := A
  else
    Min := B;
end;



function Smallest(
  A, B, C : LongInt
) : LongInt;

begin
  Smallest := Min(Min(A, B), C);
end;



procedure InpToPresent(
  Inp : String;
  var Pr : TPresent
);

begin
  with Pr do
  begin
    Length := StrToInt(StrCutChr(Inp, 'x'));
    Width := StrToInt(StrCutChr(Inp, 'x'));
    Height := StrToInt(StrCutChr(Inp, 'x'));
  end;
end;



function WrappingNeeded(
  Pr : TPresent
) : LongInt;

var
  SideArea, TopArea, FrontArea : LongInt;

begin

  with Pr do
  begin
    SideArea := Length * Height;
    TopArea := Width * Length;
    FrontArea := Height * Width;
  end;

  WrappingNeeded :=
    2 * SideArea
    + 2 * TopArea
    + 2 * FrontArea
    + Smallest(SideArea, TopArea, FrontArea);
end;



function RibbonNeeded(
  Pr : TPresent
) : LongInt;

var
  SidePerim, TopPerim, FrontPerim : Integer;
  S : LongInt;
  Volume : LongInt;

begin

  with Pr do
  begin
    SidePerim := Length + Length + Width + Width;
    TopPerim:= Width + Width + Height + Height;
    FrontPerim := Height + Height + Length + Length;
    Volume := Length * Width * Height;
  end;

  RibbonNeeded :=
    Smallest(SidePerim, TopPerim, FrontPerim)
    + Volume;

end;


end.