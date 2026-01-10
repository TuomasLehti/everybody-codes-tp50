{
  This unit provides logging functionality.

  The default behaviour is to log to a file, whose name is hard-coded,
  and to the screen. This is very likely to change in the near future, so
  don't depend on it.

  Additional loggers can be added with the RegisterLogger-procedure. Up to
  six additional loggers (eight total) can be registered. Loggers can't
  be unregistered at this time.

  Everything will be logged, no verbose or quiet flags implemented yet.
  These will eventually be implemented.
}

{$F+}
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

    logDebug:

      Messages logging the internal workings and state of a solver. Could be
      used to log the progress of a long process.

    logInfo:

      Messages logging the normal flow of the program.

    logWarn:

      Warnings. Something has gone wrong, but the solver will try to
      continue executing.

    logError:

      Unrecoverable errors. A crash is very likely.

  }
  TLogLvl = (logDebug, logInfo, logWarn, logError);



  TLogEvent = record
    Lvl : TLogLvl;
    Msg : String;
  end;



  TLogger = procedure(
    Event : TLogEvent
  );



procedure RegisterLogger(
  Logger : TLogger
);



function GetIsoTimeStamp
: String;



procedure Log(
  Level : TLogLvl;
  Msg : String
);



implementation



type
  TLoggerArr = array[1..8] of TLogger;



var
  Loggers : TLoggerArr;
  NumLoggers : Byte;




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
  Level : TLogLvl;
  Msg : String
);

var
  Event : TLogEvent;
  I : Byte;

begin
  Event.Lvl := Level;
  Event.Msg := Msg;
  for I := 1 to numLoggers do
    Loggers[I](Event);
end;



procedure ScreenLog(
  Event : TLogEvent
);

begin
  case Event.Lvl of
    logDebug : Write(ansFgDkGry);
    logInfo  : Write(ansFgGry);
    logWarn  : Write(ansFgYel);
    logError : Write(ansFgRed);
    else       Write(ansReset);
  end;
  Write(GetIsoTimeStamp, '  ', Event.Msg);
  WriteLn(ansReset);
end;



procedure FileLog(
  Event : TLogEvent
);

  function LvlToChr(Lvl : TLogLvl) : Char;
  begin
    case Lvl of
      logDebug : LvlToChr := 'D';
      logInfo  : LvlToChr := 'I';
      logWarn  : LvlToChr := 'W';
      logError : LvlToChr := 'E';
      else       LvlToChr := '?';
    end;
  end;

const
  LogFnm = 'LOGG.LOG';

var
  Logg : Text;

begin
  Assign(Logg, LogFnm);
  {$I-} Append(Logg); {$I+}
  if IOResult > 0 then Rewrite(Logg);
  WriteLn(Logg,
    GetIsoTimeStamp, '|',
    LvlToChr(Event.Lvl), '|',
    Event.Msg
  );
  Close(Logg);
end;



procedure RegisterLogger(
  Logger : TLogger
);

begin
  if NumLoggers < 8 then
  begin
    NumLoggers := NumLoggers + 1;
    Loggers[NumLoggers] := Logger;
  end
  else
    Writeln('Unable to register logger.');
end;



begin
  NumLoggers := 0;
  RegisterLogger(ScreenLog);
  RegisterLogger(FileLog);
end.