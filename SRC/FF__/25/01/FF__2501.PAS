{@
------------------------------------------------------------------------
Ff__2501 - program
------------------------------------------------------------------------

Function

  Solves Flip Flop Codes, 2015, first puzzle.

Usage

  FF__2501

See

  https://flipflop.slome.org/2025/1
}


program Ff__2501;



uses
  Strs, Logging, Metadata;



var
  Meta : TMetaData;



var
  T : Text;
  S : String;
  L : Byte;
  AnsPt1, AnsPt2, AnsPt3 : LongInt;



begin
  Meta.Id := 'FF__2501';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);
  AnsPt1 := 0;
  AnsPt2 := 0;
  AnsPt3 := 0;
  while not InpEof do
  begin
    S := ReadInpStr;

    { The actual characters don't really matter, the length does. }

    L := Length(S) div 2;

    { The answer to part 1 is just the sum of the lengths. }

    AnsPt1 := AnsPt1 + L;

    { The answer to part 2 is just the sum of even lengths. }

    if (L mod 2) = 0 then
      AnsPt2 := AnsPt2 + L;

    { The answer to part 3 actually depends on the actual characters. }

    if Pos('ne', S) = 0 then
      AnsPt3 := AnsPt3 + L;

  end;
  CloseInput;

  LogAnswer(Meta, 1, IntToStr(AnsPt1));
  LogAnswer(Meta, 2, IntToStr(AnsPt2));
  LogAnswer(Meta, 3, IntToStr(AnsPt3));
end.