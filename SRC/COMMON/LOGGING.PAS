unit Logging;



interface



uses
  Dos, Strs;



const
  ansiEsc =    Chr(27);

  ansReset =   ansiEsc + '[m';
  ansFgBlk =   ansiEsc + '[30m';
  ansFgDkRed = ansiEsc + '[31m';
  ansFgDkGrn = ansiEsc + '[32m';
  ansFgDkYel = ansiEsc + '[33m';
  ansFgDkBlu = ansiEsc + '[34m';
  ansFgDkMag = ansiEsc + '[35m';
  ansFgDkCya = ansiEsc + '[36m';
  ansFgGry   = ansiEsc + '[37m';

  ansFgDkGry = ansiEsc + '[1;30m';
  ansFgRed =   ansiEsc + '[1;31m';
  ansFgGrn =   ansiEsc + '[1;32m';
  ansFgYel =   ansiEsc + '[1;33m';
  ansFgBlu =   ansiEsc + '[1;34m';
  ansFgMag =   ansiEsc + '[1;35m';
  ansFgCya =   ansiEsc + '[1;36m';
  ansFgWht =   ansiEsc + '[1;37m';

  ansBgDkBlk = ansiEsc + '[40m';
  ansBgDkRed = ansiEsc + '[41m';
  ansBgDkGrn = ansiEsc + '[42m';
  ansBgDkYel = ansiEsc + '[43m';
  ansBgDkBlu = ansiEsc + '[44m';
  ansBgDkMag = ansiEsc + '[45m';
  ansBgDkCya = ansiEsc + '[46m';
  ansBgDkWht = ansiEsc + '[47m';



type

{
  Log levels.
  logSolve : When a solver starts it should log at the first possible moment.
  lofWarn: When something goes wrong.
  logInto: When everything is flowing normally.
  logDebug: Debug information, not necessarily always shown.
}
  TLogLevel = (logSolve, logWarn, logInfo, logDebug);



function GetIsoTimeStamp : String;



procedure Log(Level : TLogLevel; Msg : String);



implementation



function GetIsoTimeStamp : String;

var
  Year, Month, Day, DayOfWeek,
  Hour, Minute, Second, Second100 : Word;

begin
  GetTime(Hour, Minute, Second, Second100);
  GetDate(Year, Month, Day, DayOfWeek);
  GetIsoTimeStamp :=
    LeftPad(IntToStr(Year), 4, '0') + '-' +
    LeftPad(IntToStr(Month), 2, '0') + '-' +
    LeftPad(IntToStr(Day), 2, '0') + 'T' +
    LeftPad(IntToStr(Hour), 2, '0') + ':' +
    LeftPad(IntToStr(Minute), 2, '0') + ':' +
    LeftPad(IntToStr(Second), 2, '0') + '.' +
    LeftPad(IntToStr(Second100), 2, '0');
end;



procedure Log(
  Level : TLogLevel;
  Msg : String
);

begin
  case Level of
    logSolve : Write(ansFgBlu);
    logDebug : Write(ansFgDkGry);
    logWarn  : Write(ansFgRed);
    logInfo  : Write(ansFgGry);
    else       Write(ansReset);
  end;
  Write(GetIsoTimeStamp, '  ', Msg);
  WriteLn(ansReset);
end;


