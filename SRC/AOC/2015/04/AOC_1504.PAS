{

  A solver for Advent of Code 2015, day 4.

  This solver was written 21.4.2026.

}
program AoC_1504;



uses
  Md5,
  Metadata, Strs, Logging;


var
  Meta : TMetaData;
  Salt, Hash, MsgStr : String;
  Msg : TMd5Msg;
  AnsPt1, AnsPt2 : LongInt;
  I : LongInt;

begin
  Meta.Id := 'AOC_1504';
  ReadMetadata(Meta);
  LogStart(Meta);

  OpenInput(Meta, 1);
  Salt := ReadInpStr;

  I := 0;
  AnsPt1 := -1;
  AnsPt2 := -1;
  repeat
    MsgStr := Salt + IntToStr(I);
    StrToMd5Msg(MsgStr, Msg);
    Hash := CountMd5(Msg);
    if (I mod 1000) = 0 then
      SLog(logInfo, IntToStr(I) + ' hashes tried');
    if (StrBegins(Hash, '00000')) and (AnsPt1 = -1) then
    begin
      AnsPt1 := I;
      LogAnswer(Meta, 1, IntToStr(AnsPt1));
    end;
    if (StrBegins(Hash, '000000')) and (AnsPt2 = -1) then
    begin
      AnsPt1 := I;
      LogAnswer(Meta, 2, IntToStr(AnsPt1));
    end;
    Inc(I);
  until ((AnsPt1 > -1) and (AnsPt2 > -1));
  CloseInput;
end.