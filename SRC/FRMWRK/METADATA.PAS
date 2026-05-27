{

  Handles data about the puzzles:


    Reading the input to memory.


      The time taken by Input/Output operations may be significant when
      using floppy disks. Therefore the reading of the puzzle input is
      done beforehand, before any solving takes place. This way the times
      for IO and solving are separated and can be compared between
      different computers.

      The input buffering has a lenient mode. The starting state is not
      lenient, so when errors are encountered, the program execution is
      halted with an appropriate error message. By chancing the lenient
      mode on the program execution continues and the error can be queried
      by InpResult function.


    Log certain timestamps in our own way.

}
unit Metadata;



interface



uses
  Dos, Logging, Strs;



type

  TMetadata = record
    Id,
    SiteName,
    EventName,
    PuzzleName : String;
    NumParts : Byte;
    InputFilename,
    ExpectedAnswer : array[1..3] of String;
  end;




function IdToPath(
  Id : String
) : String;



procedure ReadMetadata(
  var Metadata : TMetadata
);



var
  InpLenient : Boolean;

const
  inpOk = 0;
  inpErrUnexpectedEof = 1;

function InpResult
: Integer;



procedure OpenFile(
  Fnm : String
);



procedure OpenInput(
  Metadata : TMetadata;
  Part : Byte
);



{
  ---------------------------------------------------------------------------
  ReadInpChar
  ---------------------------------------------------------------------------

  Function

    Reads a single character from the puzzle input.

  Parameters

    Returns    The next character from the puzzle input.

  Remarks

    If there are no more characters to read, stops the program execution.
    If the lenient mode is enabled, returns a null character and sets
    InpError to 1.
}
function ReadInpChar
: Char;



{
  ---------------------------------------------------------------------------
  ReadInpStr
  ---------------------------------------------------------------------------

  Function

    Reads a string from the puzzle input.

  Parameters

    Returns    The string.

  Remarks

    The strings in the buffer should be newline-terminated. There should
    be a newline character or character pair at the end of each string,
    even the last one. If the last newline marker is missing, this
    function still behaves correctly, however.

    This function recognizes following newline markers: CR, LF, CR/LF
    and even LF/CR.

    If there are no more strings to read, stops the program execution.
    If the lenient mode is enabled, returns en empty string and sets
    InpError to 1.

}
function ReadInpStr
: String;



{
  ---------------------------------------------------------------------------
  InpEof - function
  ---------------------------------------------------------------------------

  Function

    Checks the status of the puzzle input reader pointer.

  Parameters

    Returns    True if the pointer points past the end of the input.

}
function InpEof
: Boolean;



function InpEol
: Boolean;



procedure CloseInput;


procedure LogStart(
  Meta : TMetadata
);


procedure LogAnswer(
  Meta : TMetadata;
  PtIdx : Byte;
  Ans : String
);


implementation

procedure LogIoFinish(
  Meta : TMetadata
);

var
  Event : TLogEvent;

begin
  Event.Lvl := logDebug;
  Event.Msg := Meta.Id + '|' + 'finish-io';
  FileLog(Event);

  Event.Msg := 'Finished reading input';
  ScreenLog(Event);
end;




function FExists(
  Filename : String
) : Boolean;

var
  F : File;

begin
  {$I-}
  Assign(F, Filename);
  Reset(F);
  Close(F);
  FExists := IOResult = 0;
  {$I+}
end;



procedure ReadMetadata(
  var Metadata : TMetadata
);

var
  Filename, Line : String;
  MetadataFile : Text;
  I, Err : Integer;

begin
  Filename := 'METADATA\' + IdToPath(Metadata.Id) + '\METADATA.INI';
  SLog(logDebug, 'Read metadata ' + Filename);
  if not (FExists(Filename)) then
  begin
    SLog(logError, 'Standard metadata file not found');
    Exit;
  end;
  Assign(MetadataFile, Filename);
  Reset(MetadataFile);
  while not Eof(MetadataFile) do
  begin
    ReadLn(MetadataFile, Line);
    if StrBegins(Line, 'SITE_NAME=') then
      Metadata.SiteName := Copy(Line, 11, Length(Line) - 10);
    if StrBegins(Line, 'EVENT_NAME=') then
      Metadata.EventName := Copy(Line, 12, Length(Line) - 11);
    if StrBegins(Line, 'PUZZLE_NAME=') then
      Metadata.PuzzleName:= Copy(Line, 13, Length(Line) - 12);
    if StrBegins(Line, 'NUM_PARTS=') then
    begin
      Val(Copy(Line, 11, Length(Line) - 10), I, Err);
      Metadata.NumParts := I;
    end;
    if StrBegins(Line, 'INPUT_PT') then
    begin
      Val(Copy(Line, 9, 1), I, Err);
      Metadata.InputFilename[I] := Copy(Line, 11, Length(Line) - 10);
    end;
    if StrBegins(Line, 'ANSWER_PT') then
    begin
      Val(Copy(Line, 10, 1), I, Err);
      Metadata.ExpectedAnswer[I] := Copy(Line, 12, Length(Line) - 11);
    end;
  end;
  Close(MetadataFile);
end;



function IdToPath(
  Id : String
) : String;

begin
  if Length(Id) < 8 then
  begin
    SLog(logWarn, 'Malformed id: ' + Id);
    Exit;
  end;
  IdToPath :=
    Copy(Id, 1, 4) + '\' +
    Copy(Id, 5, 2) + '\' +
    Copy(Id, 7, 2);
end;



type



  TAocInp = array[1..64000] of Char;



  TAocInpPtr = ^TAocInp;



  TAocInpRec = record
    Inp : TAocInpPtr;
    Size : Word;
    Pos : Word;
  end;



  TEolChr = (eolNone, eolCr, eolLf, eolCrLf, eolLfCr);



const


  Lf = #10;
  Cr = #13;



var



  AocInp : TAocInpRec;



  EolChr : TEolChr;



  InpErr : Integer;



function InpResult
: Integer;

begin
  InpResult := InpErr;
  InpErr := inpOk;
end;



procedure DetectEolChr;

begin
  with AocInp do
    for Pos := 1 to Size do
      if Inp^[Pos] = Lf then
        if (Pos < Size) and (Inp^[Pos + 1] = Cr) then
        begin
          EolChr := eolLfCr;
          Exit;
        end
        else
        begin
          EolChr := eolLf;
          Exit;
        end
      else if Inp^[Pos] = Cr then
        if (Pos < Size) and (Inp^[Pos + 1] = Lf) then
        begin
          EolChr := eolCrLf;
          Exit;
        end
        else
        begin
          EolChr := eolCr;
          Exit;
        end;
end;



procedure OpenFile(
  Fnm : String
);

var
  F : File;
  FData : SearchRec;

begin
  if not FExists(Fnm) then
  begin
    SLog(logWarn, Fnm + ' not found');
    Exit;
  end;
  FindFirst(Fnm, AnyFile, FData);
  AocInp.Size := FData.Size;
  if AocInp.Size > 64000 then
  begin
    SLog(logWarn, Fnm + ' too big');
    Exit;
  end;
  GetMem(AocInp.Inp, AocInp.Size);
  Assign(F, Fnm);
  Reset(F, 1);
  BlockRead(F, AocInp.Inp^, AocInp.Size);
  Close(F);
  DetectEolChr;
  AocInp.Pos := 1;
end;



procedure OpenInput(
  Metadata : TMetadata;
  Part : Byte
);

var
  Fnm : String;

begin
  Fnm :=
    'INPUTS\'
    + IdToPath(Metadata.Id)
    + '\INPUT'
    + Copy(Metadata.Id, 7, 2)
    + '.TXT';
  Fnm := Metadata.InputFilename[Part];
  OpenFile(Fnm);
  LogIoFinish(Metadata);
end;



function ReadInpChar
: Char;

begin
  if InpEof then
  begin
    SLog(logError, 'Tried to read past the end of the input');
    if not InpLenient then
      Halt
    else
    begin
      ReadInpChar := #0;
      InpErr := inpErrUnexpectedEof;
      Exit;
    end;
  end;
  with AocInp do
  begin
    ReadInpChar := Inp^[Pos];
    Pos := Pos + 1;
  end;
end;



function ReadInpStr
: String;

var
  Start : Word;
  Len : Byte;
  Res : String;

begin

  if InpEof then
  begin
    SLog(logError, 'Tried to read past the end of the input');
    if not InpLenient then
      Halt
    else
    begin
      ReadInpStr := '';
      InpErr := inpErrUnexpectedEof;
      Exit;
    end;
  end;

  { Assuming that the buffer pointer points to the beginning of the string. }

  Start := AocInp.Pos;
  while (not InpEof) and (not InpEol) do
    AocInp.Pos := AocInp.Pos + 1;

  { Pos now points to the first newline char. If it points to Start, there
    is an empty string, which these four lines handle correctly. }

  Len := AocInp.Pos - Start;
  Move(AocInp.Inp^[Start], Res[1], Len);
  Res[0] := Chr(Len);
  ReadInpStr := Res;

  { No need to skip newline chars if we've reached the end of the buffer. }

  if InpEof then Exit;

  { Skip the newline character(s). There it at least one NL char, and two
    of the possible four NL char combinations have two NL chars. }

  Inc(AocInp.Pos);
  if (EolChr = eolCrLf) or (EolChr = eolLfCr) then
    Inc(AocInp.Pos);

end;



function InpEof
: Boolean;

begin
  with AocInp do
    InpEof := Pos > Size;
end;



function InpEol
: Boolean;

begin
  with AocInp do
    InpEol := (Inp^[Pos] = #13) or (Inp^[Pos] = #10) or (InpEof);
end;


procedure CloseInput;

begin
  FreeMem(AocInp.Inp, AocInp.Size);
end;



procedure LogStart(
  Meta : TMetadata
);

var
  Event : TLogEvent;

begin
  with Event do
  begin
    Lvl := logInfo;
    Msg := Meta.Id + '|' + 'start'
  end;
  FileLog(Event);

  Event.Msg := {ansFgGrn +}
    Meta.SiteName + ': ' +
    Meta.EventName;
  ScreenLog(Event);
  Event.Msg := {ansFgDkGrn +}
    'Day ' + Copy(Meta.Id, 7, 2) + ': ' +
    Meta.PuzzleName;
  ScreenLog(Event);
end;



procedure LogAnswer(
  Meta : TMetadata;
  PtIdx : Byte;
  Ans : String
);

var
  Event : TLogEvent;
  PtIdxStr : String;

begin
  Event.Lvl := logInfo;
  if Ans = Meta.ExpectedAnswer[PtIdx] then
    Event.Lvl := logInfo
  else
    Event.Lvl := logWarn;
  Event.Msg :=
    Meta.Id + '|' +
    'finish-pt' + IntToStr(PtIdx) + '|' +
    Ans + '|' +
    Meta.ExpectedAnswer[PtIdx];
  FileLog(Event);

  if Event.Lvl = logWarn then
    {Event.Msg := ansFgDkRed}
  else
    Event.Msg := '';
  Event.Msg := Event.Msg +
    'Part ' + IntToStr(PtIdx) + ': ' +
    Ans + ' ' +
    '(expected ' + Meta.ExpectedAnswer[PtIdx] + ')';
  ScreenLog(Event);
end;



begin
  InpLenient := false;
end.