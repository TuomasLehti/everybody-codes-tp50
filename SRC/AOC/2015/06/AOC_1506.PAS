{

  A solver for Advent of Code 2015, day 6.

  This solver was written 2.5.2026.

  Remarks

    Must be run stand-alone, not enough heap when run from inside the
    Turbo Pascal environment.

  Todo

    Ends in a runtime error, there's something wrong with the freeing
    of the linked list.

}



{$F+}
{$M 16384,0,655300}



program AoC_1506;



uses
  Geom, Structs,
  Metadata, Strs, Logging;



{$I SRC\AOC\2015\06\RECT.PAS}



procedure Parse(
  S : String;
  var InstType : TInstType;
  var Rect : PRect
);

begin
  if StrBegins(S, 'turn') then
    Delete(S, 1, 5);

  if StrBegins(S, 'on') then
  begin
    InstType := on;
    Delete(S, 1, 3);
  end

  else if StrBegins(S, 'off') then
  begin
    InstType := off;
    Delete(S, 1, 4);
  end

  else if StrBegins(S, 'toggle') then
  begin
    InstType := toggle;
    Delete(S, 1, 7);
  end

  else
  begin
    SLog(logWarn, 'Unknown instruction type: ' + StrCopyChr(S, ' '));
    SLog(logWarn, 'S: ' + S);
  end;

  Rect^.W := StrToInt(StrCutChr(S, ','));
  Rect^.N := StrToInt(StrCutChr(S, ' '));

  Delete(S, 1, Length('through '));
  Rect^.E := StrToInt(StrCutChr(S, ','));
  Rect^.S := StrToInt(S);

end;





var
  Meta : TMetaData;
  Area, Widht, Height, AnsPt1, AnsPt2 : LongInt;
  Str : String;

  InstType : TInstType;

  Rects : TLnkLst; { of TRect }
  Rect, Inst : PRect;

  CountInsts, Sz : Word;


procedure Print;
var I : TNodePtr; P : PRect;
begin
  I := Rects.Head;
  while I <> nil do
  begin
    P := I^.Data;
    WriteLn(RectToStr(P^));
    I := I^.Next;
  end;
end;


function Size : LongInt;
var I : TNodePtr; S : LongInt;
begin
  S := 0;
  I := Rects.Head;
  while I <> nil do
  begin
    Inc(S);
    I := I^.Next;
  end;
  Size := S;
end;


begin
  Meta.Id := 'AOC_1506';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);

  CreateLnkLst(Rects);
  New(Rect);
  Rect^.Lit := false;
  Rect^.Brightness := 0;
  Rect^.W := 0;
  Rect^.N := 0;
  Rect^.E := 999;
  Rect^.S := 999;
  AppendToLnkLst(Rects, Rect);

  AnsPt1 := 0;
  AnsPt2 := 0;
  CountInsts := 0;

  New(Inst);
  while not InpEof do
  begin
    Str := ReadInpStr;
    Parse(Str, InstType, Inst);

    Inc(CountInsts);
    Writeln('Inst ', CountInsts, ': ', RectToStr(Inst^));

{    Writeln('before');
    Print;}
    IterReset(Rects);
    while not IterEndOfLst(Rects) do
    begin
      Rect := IterNext(Rects);
      if Overlap(Rect^, Inst^) then
      begin
        Split(Rect, InstType, Inst, Rects);
        if InstType = on then
        begin
          Rect^.Lit := true;
          Inc(Rect^.Brightness);
        end
        else if InstType = off then
        begin
          Rect^.Lit := false;
          if Rect^.Brightness > 0 then
            Dec(Rect^.Brightness);
        end
        else
        begin
          Rect^.Lit := not Rect^.Lit;
          Rect^.Brightness := Rect^.Brightness + 2;
        end;
      end;
    end;
{    Writeln('after');
    Print;
    ReadlN;}

  end;

  CountInsts := 0;
  Sz := Size;
  IterReset(Rects);
  AnsPt2 := 0;
  while not IterEndOfLst(Rects) do
  begin
    Inc(CountInsts);
    if CountInsts mod 100 = 0 then Writeln(CountInsts, '/', Sz);
    Rect := IterNext(Rects);

{    WriteLn(RectToStr(Rect^));}

    with Rect^ do
    begin
      Widht := E - W + 1;
      Height := S - N + 1;
      Area := Widht * Height;
      if Lit then
        AnsPt1 := AnsPt1 + Area;
      AnsPt2 := AnsPt2 + Area * Brightness;
    end;
  end;

{  Dispose(Rect);
  Dispose(Inst);}
  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));

  DestroyLnkLst(Rects, DestroyRect16);
  CloseInput;
end.