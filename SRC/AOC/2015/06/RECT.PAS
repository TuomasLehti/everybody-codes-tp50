


type
  TInstType = (on, off, toggle);



  TRect = record
    Lit : Boolean;
    Brightness : Word;
    W, N, E, S : Word;
  end;



  PRect = ^TRect;



procedure DestroyRect(
  var Data : Pointer
);

var
  Rect : PRect absolute Data;

begin
  Dispose(Rect);
end;



function RectToStr(
  Rect : TRect
) : String;

begin
  if Rect.Lit then
  RectToStr :=
    'ON  (' + IntToStr(Rect.W) + ',' + IntToStr(Rect.N) + ')'
    + '-(' + IntToStr(Rect.E) + ',' + IntToStr(Rect.S) + ')'
  else
  RectToStr :=
    'OFF (' + IntToStr(Rect.W) + ',' + IntToStr(Rect.N) + ')'
    + '-(' + IntToStr(Rect.E) + ',' + IntToStr(Rect.S) + ')';
end;



{
  Do ranges A-B and C-D overlap?)

  A   B
  |---|
        |---|
        C   D

  ===============================

              A   B
              |---|
        |---|
        C   D
}
function RangesOverlapping(
  A, B, C, D : Word
) : Boolean;

begin
  RangesOverlapping := not((B < C) or (A > D));
end;



function Overlap(
  One, Other : TRect
) : Boolean;

begin
  Overlap :=
    RangesOverlapping(One.W, One.E, Other.W, Other.E)
    and RangesOverlapping(One.N, One.S, Other.N, Other.S);
end;


{
  Splitting the northern part off of Rect.

  Rect is the rectangle which is examined at the moment. It will be
  modified so that it doesn't have the splitted part any more and it
  will at the end become the part of the original rectangle to which
  the instruction will be applied.

  SplitY is the y coordinate of the north edge of the rectangle from
  the instruction.

  Splitted will be the part which is split from Rect. It will be
  created here.
}
procedure SplitN(
  var Rect : PRect;
  SplitY : Word;
  var Splitted : PRect
);

begin
  New(Splitted);
  Splitted^.W := Rect^.W;
  Splitted^.N := Rect^.N;
  Splitted^.E:= Rect^.E;
  Splitted^.S:= SplitY - 1;
  Splitted^.Lit := Rect^.Lit;
  Splitted^.Brightness := Rect^.Brightness;
  Rect^.N := SplitY;
end;



procedure SplitS(
  var Rect : PRect;
  SplitY : Word;
  var Splitted : PRect
);

begin
  New(Splitted);
  Splitted^.W := Rect^.W;
  Splitted^.N := SplitY + 1;
  Splitted^.E:= Rect^.E;
  Splitted^.S:= Rect^.S;
  Splitted^.Lit := Rect^.Lit;
  Splitted^.Brightness := Rect^.Brightness;
  Rect^.S := SplitY;
end;



procedure SplitW(
  var Rect : PRect;
  SplitX : Word;
  var Splitted : PRect
);

begin
  New(Splitted);
  Splitted^.W := Rect^.W;
  Splitted^.N := Rect^.N;
  Splitted^.E:= SplitX - 1;
  Splitted^.S:= Rect^.S;
  Splitted^.Lit := Rect^.Lit;
  Splitted^.Brightness := Rect^.Brightness;
  Rect^.W := SplitX;
end;



procedure SplitE(
  var Rect : PRect;
  SplitX : Word;
  var Splitted : PRect
);

begin
  New(Splitted);
  Splitted^.W := SplitX + 1;
  Splitted^.N := Rect^.N;
  Splitted^.E:= Rect^.E;
  Splitted^.S:= Rect^.S;
  Splitted^.Lit := Rect^.Lit;
  Splitted^.Brightness := Rect^.Brightness;
  Rect^.E := SplitX;
end;



procedure Split(
  var Rect : PRect;
  InstType : TInstType;
  Inst : PRect;
  var Rects : TLnkLst { of TRect }
);

var
  Splitted : PRect;

begin
  if (Inst^.N > Rect^.N) and (Inst^.N <= Rect^.S) then
  begin
    SplitN(Rect, Inst^.N, Splitted);
    AppendToLnkLst(Rects, Splitted);
  end;
  if (Inst^.S < Rect^.S) and (Inst^.S >= Rect^.N) then
  begin
    SplitS(Rect, Inst^.S, Splitted);
    AppendToLnkLst(Rects, Splitted);
  end;
  if (Inst^.W > Rect^.W) and (Inst^.W <= Rect^.E) then
  begin
    SplitW(Rect, Inst^.W, Splitted);
    AppendToLnkLst(Rects, Splitted);
  end;
  if (Inst^.E < Rect^.E) and (Inst^.E >= Rect^.W) then
  begin
    SplitE(Rect, Inst^.E, Splitted);
    AppendToLnkLst(Rects, Splitted);
  end;
end;


