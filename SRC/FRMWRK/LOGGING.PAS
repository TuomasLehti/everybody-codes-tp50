{
  This unit provides logging functionality.

  More information can be found from DOCS\FRMWRK.TXT.
}

{$F+}
unit Logging;



interface



uses
  Crt, Dos, Strs, CmdLine;



type



{
  ---------------------------------------------------------------------------
  TLogLvl
  ---------------------------------------------------------------------------

  Function

    An enumerated type to define the logging level.

  Values

    - `logDebug`: Messages logging the internal workings and state
      of a solver belong to this group. This should be used if
      a real debugger is not available, or if the use of a real
      debugger is impractical, for instance in a loop with hundreds
      and thousands of repetitions.

    - `logInfo`: Messages logging the normal flow of the program.
      Results and timings of a solver belong here. This should also
      be used for logging the progress of a lengthy process every n
      iterations, so that it can be determined, how far along the
      solver was when it crashed.

    - `logWarn`: Warning messages should be logged, when an
      unexpected state is encountered, The solver has the means to
      continue executing, but the following progress might be
      nonsense. Typical warning message contitions are missing
      input files, wrong answers to the puzzles and failed unit
      tests.

    - `logError`: Error messages should be logged, when the
      continuation of execution is in jeopardy.

}
  TLogLvl = (
    logDebug,
    logInfo,
    logWarn,
    logError
  );



{
  ---------------------------------------------------------------------------
  TLogOutputMode - enum
  ---------------------------------------------------------------------------

  Function

    What should be logged.

  Remarks

    Users wish as what they want to be logged. TLoggers can fulfill this
    wish or disregard it.

    - logOutputQuiet: Quiet mode. Only warnings and errors should be logged.

    - logOutputNormal: Normal mode. Everything except debug messages should
      be logged.

    - logOutputVerbose: Verbose mode. Everything should be logged.

}
  TLogOutputMode = (
    logOutputQuiet,
    logOutputNormal,
    logOutputVerbose
  );



{
  ---------------------------------------------------------------------------
  TLogEvent
  ---------------------------------------------------------------------------

  Function

    A record to pass a logging message to procedures and functions.

  Fields

    Lvl        The logging level.

    Msg        The message to be logged.

  Remarks

    Using a record leaves room for future expansion. This record
    might have more fields in the future, but the existing logger
    procedures' signatures won't need to be updated. They just
    don't act on the new information.

}
  TLogEvent = record
    Lvl : TLogLvl;
    Msg : String;
  end;



{
  ---------------------------------------------------------------------------
  TLogger
  ---------------------------------------------------------------------------

  Function

    A prototype procedure to log a message.

  Parameters

    Event      The event to be logged.

  Remarks

    A TLogger implementation should log the given message with the given
    level. A TLogger can be registered with the RegisterLogger-procedure.
}
  TLogger = procedure(
    Event : TLogEvent
  );



{
  ---------------------------------------------------------------------------
  GetLogOutputMode
  ---------------------------------------------------------------------------

  Function

    Returns the users wish on the amount of logging output.

  Parameters

    Returns    The amount of logging wanted.

}
function GetLogOutputMode
: TLogOutputMode;



{
  ---------------------------------------------------------------------------
  RegisterLogger
  ---------------------------------------------------------------------------

  Function

    Registers a logger.

  Parameters

    Logger     The logger to be registered.

  Remarks

    A maximum of 8 loggers can be present at a time. If the user tries to
    register more than that, an error message is printed.

}
procedure RegisterLogger(
  Logger : TLogger
);



{
  ---------------------------------------------------------------------------
  UnregisterAllLoggers
  ---------------------------------------------------------------------------

  Function

    Removes all loggers.

}
procedure UnregisterAllLoggers;



{
  ---------------------------------------------------------------------------
  GetIsoTimeStamp
  ---------------------------------------------------------------------------

  Function

    Returns the current date and time in the ISO 8601 format.

  Parameters

    Returns    The current date and time, format "yyyy-mm-ddThh:mm:ss.ss".
}
function GetIsoTimeStamp
: String;



{
  ---------------------------------------------------------------------------
  Log
  ---------------------------------------------------------------------------

  Function

    Logs a message to all registered loggers.

  Parameters

    Event      The event to be logged.

}
procedure Log(
  Event : TLogEvent
);



{
  ---------------------------------------------------------------------------
  SLog
  ---------------------------------------------------------------------------

  Function

    Logs a simple message using all registered loggers.

  Parameters

    Level      The logging level.

    Msg        The message to be logger.

  Remarks

    A convenience method for creating a logging event with minimal
    information and logging it to all registered logger.

}
procedure SLog(
  Level : TLogLvl;
  Msg : String
);


{
  ---------------------------------------------------------------------------
  ScreenLog
  ---------------------------------------------------------------------------

  Function

    Logs to the screen.

  Parameters

    Event      The logging event.

  Remarks

    Logs to the screen.

    Coloring is hard-coded by logging level for now: dark gray for debug,
    light gray for info, light yellow for warning and light red for error.

    If the selected logging level is quiet, only logs warnings and errors.
    If the selected logging level is not defined, logs everything but the
    debug messages. If the selected logging level is verbose, logs
    everything. (The logging level can be selected by a command line
    switches /Q and /V.)

}
procedure ScreenLog(
  Event : TLogEvent
);



{
  ---------------------------------------------------------------------------
  FileLog
  ---------------------------------------------------------------------------

  Function

    Logs to a file.

  Parameters

    Event      The logging event.

  Remarks

    The file name should be provided by the command line switch /L. If the
    file already exists, log messages are appended to the end of it.

}
procedure FileLog(
  Event : TLogEvent
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



function QuietMode
: Boolean;

begin
  QuietMode := SwitchExists('Q');
end;



function VerboseMode
: Boolean;

begin
  VerboseMode := SwitchExists('V');
end;



function GetLogOutputMode
: TLogOutputMode;

begin
  if QuietMode then
    GetLogOutputMode := logOutputQuiet
  else if VerboseMode then
    GetLogOutputMode := logOutputVerbose
  else
    GetLogOutputMode := logOutputNormal;
end;



function GetLogFilename
: String;

begin
  GetLogFilename := GetSwitch('L');
end;



procedure Log(
  Event : TLogEvent
);

var
  I : Byte;

begin
  for I := 1 to numLoggers do
    Loggers[I](Event);
end;



procedure SLog(
  Level : TLogLvl;
  Msg : String
);

var
  Event : TLogEvent;
  I : Byte;

begin
  Event.Lvl := Level;
  Event.Msg := Msg;
  Log(Event);
end;



procedure ScreenLog(
  Event : TLogEvent
);

begin
  case Event.Lvl of
    logDebug : TextColor(DarkGray);
    logInfo  : TextColor(LightGray);
    logWarn  : TextColor(Yellow);
    logError : TextColor(LightRed);
    else       Write(LightGray);
  end;
  if (
    ((Event.Lvl = logDebug) and (GetLogOutputMode = logOutputVerbose))
    or ((Event.Lvl = logInfo) and (not (GetLogOutputMode = logOutputQuiet)))
    or (Event.Lvl = logWarn) or (Event.Lvl = logError)
  ) then
    Writeln(GetIsoTimeStamp, '  ', Event.Msg);
  TextColor(LightGray);
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

var
  Logg : Text;

begin
  if GetLogFileName = '' then Exit;
  Assign(Logg, GetLogFilename);
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



procedure UnregisterAllLoggers;

var
  Idx : Byte;

begin
  NumLoggers := 0;
end;



begin
  NumLoggers := 0;
  RegisterLogger(ScreenLog);
  RegisterLogger(FileLog);
end.