{

  Handles data about the puzzles:

  - Reading the input to memory.
  - Log certain timestamps in our own way.

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



procedure OpenInput(
  Metadata : TMetadata
);



function ReadInpChar
: Char;



function ReadInpStr
: String;



function InpEof
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
  Log(logDebug, 'Read metadata ' + Filename);
  if not (FExists(Filename)) then
  begin
    Log(logError, 'Standard metadata file not found');
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
    Log(logWarn, 'Malformed id: ' + Id);
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



var



  AocInp : TAocInpRec;



procedure OpenInput(
  Metadata : TMetadata
);

var
  Fnm : String;
  FData : SearchRec;
  F : File;

begin
  Fnm :=
    'INPUTS\'
    + IdToPath(Metadata.Id)
    + '\INPUT'
    + Copy(Metadata.Id, 7, 2)
    + '.TXT';
  if not FExists(Fnm) then
  begin
    Log(logWarn, Fnm + ' not found');
    Exit;
  end;
  FindFirst(Fnm, AnyFile, FData);
  AocInp.Size := FData.Size;
  if AocInp.Size > 64000 then
  begin
    Log(logWarn, Fnm + ' too big');
    Exit;
  end;
  GetMem(AocInp.Inp, AocInp.Size);
  Assign(F, Fnm);
  Reset(F, 1);
  BlockRead(F, AocInp.Inp^, AocInp.Size);
  Close(F);
  AocInp.Pos := 1;
  LogIoFinish(Metadata);
end;



function ReadInpChar
: Char;

begin
  with AocInp do
  begin
    ReadInpChar := Inp^[Pos];
    Pos := Pos + 1;
  end;
end;



function ReadInpStr
: String;

begin
end;



function InpEof
: Boolean;

begin
  with AocInp do
    InpEof := Pos > Size;
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

  Event.Msg := ansFgGrn +
    Meta.SiteName + ': ' +
    Meta.EventName;
  ScreenLog(Event);
  Event.Msg := ansFgDkGrn +
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
    Event.Msg := ansFgDkRed
  else
    Event.Msg := '';
  Event.Msg := Event.Msg +
    'Part ' + IntToStr(PtIdx) + ': ' +
    Ans + ' ' +
    '(expected ' + Meta.ExpectedAnswer[PtIdx] + ')';
  ScreenLog(Event);
end;

end.