{
  A program to do things with directories recursively.
}

{$F+}

program Dirs;



uses
  Dos, Strs;



type



  {
    There are several commands to run, and they require the directory tree
    to be traversed in different order.

    Commands which construct a directory tree must traverse the directory
    tree so that the directories are constructed before their subdirs. In
    this program this approach is called top-down.

    Commands which destruct a directory tree must start their traversal
    from the bottom so that the directories don't contain any subdirectories
    once it's time to remove them. This is called bottom-up.

    If the traversal method doesn't matter, a method must still be chosen,
    but the choice can be arbitrary.

    In every case the files in a directory are processed before the subdirs.
  }
  TRecursionMode = (bottomUp, topDown);



  {
    A runner is a procedure which gets run for every file entry, whether
    an actual file or a directory.

    A file entry of a directory can be a volume label entry in the root
    directory, or a dot entry, which means that the entry is "." or "..",
    which are used in relative paths.

    Volume label entries or dot entries will not be passed to the runner.
    That means that you can test the directoryness of an entry by checking
    the Attr-field of the FData-record.
  }
  TRunner = procedure(
    FData : SearchRec;
    CurPath : String;
    DestPath : String
  );


  {
    This record contains the parameters given to the program, and data
    deduced from them.
  }
  TParams = record
    Runner : TRunner;
    RecMode : TRecursionMode;
    SrcPath, DestPath : String;
    Mask : String;
  end;



{
  Checks if a file or a directory exists.
}
function FExists(
  Fnm : String
) : Boolean;

var
  FData : SearchRec;

begin
  FindFirst(Fnm, AnyFile, FData);
  FExists := DosError = 0;
end;


{
  Copies a file from one directory to another.
}
procedure FCopy(
  SrcFnm : String;
  DestFnm : String
);

const
  BufSize = 32768;

type
  TBuffer = array[1..BufSize] of Byte;
  PBuffer = ^TBuffer;

var
  Src, Dest : File;
  Buf : PBuffer;
  Amt : Word;

begin
  GetMem(Buf, BufSize);
  Assign(Src, SrcFnm);
  Reset(Src, 1);
  Assign(Dest, DestFnm);
  Rewrite(Dest, 1);

  BlockRead(Src, Buf^, BufSize, Amt);
  while Amt > 0 do
  begin
    BlockWrite(Dest, Buf^, Amt);
    BlockRead(Src, Buf^, BufSize, Amt);
  end;

  Close(Dest);
  Close(Src);
  FreeMem(Buf, BufSize);
end;



{
  Checks if a directory name is a dot directory name. Dot directories are
  "." and "..", and their purpose is to refer to the current directory or
  the parent directory of the current directory.
}
function IsDotFnm(
  Fnm : String
) : Boolean;

begin
  IsDotFnm := (Fnm = '.') or (Fnm = '..');
end;



{
  A runner for listing files.
}
procedure DirRunner(
  FData : SearchRec;
  CurPath : String;
  DestPath : String
);

begin
  if not ((FData.Attr and Directory) = Directory) then
    Writeln(FExpand(CurPath + FData.Name));
end;


{
  A runner for deleting files.
}
procedure DelRunner(
  FData : SearchRec;
  CurPath : String;
  DestPath : String
);

var
  F : File;

begin
  if not ((FData.Attr and Directory) = Directory) then
  begin
    Writeln('del ' + FExpand(CurPath + FData.Name));
    Assign(F, CurPath + FData.Name);
    Erase(F);
  end;
end;



{
  A runner for removing directories.
}
procedure RmdirRunner(
  FData : SearchRec;
  CurPath : String;
  DestPath : String
);

begin
  if (FData.Attr and Directory) = Directory then
  begin
    Writeln('rmdir ' + FExpand(CurPath + FData.Name));
    RmDir(FExpand(CurPath + FData.Name));
  end;
end;



{
  A runner for copying files. This runner also makes the directories needed
  to mirror the source directory.
}
procedure CopyRunner(
  FData : SearchRec;
  CurPath : String;
  DestPath : String
);

var
  Path, SrcFnm, DestFnm : String;

begin
  if ((FData.Attr and Directory) = Directory)
     and (not IsDotFnm(FData.Name)) then
  begin
    Path := FExpand(DestPath + CurPath + FData.Name + '\');
    Path := Copy(Path, 1, Length(Path) - 1);
    if not FExists(Path) then
    begin
      Writeln('mkdir ' + Path);
      MkDir(Path);
    end
    else
      Writeln('exists ' + Path);

  end
  else
  begin
    SrcFnm := FExpand(CurPath + FData.Name);
    DestFnm := FExpand(DestPath + CurPath + FData.Name);
    Writeln(
      'copy ' + FExpand(CurPath + FData.Name) +
      ' to ' + FExpand(DestPath + CurPath + FData.Name)
    );
    FCopy(SrcFnm, DestFnm);
  end;
end;



{
  Parse the command part of command line arguments.
}
procedure ParseCommand(
  Cmd : String;
  var Params : TParams
);

begin
  if ParamStr(1) = 'DEL' then
  begin
    Params.RecMode := topDown;
    Params.Runner := DelRunner;
  end
  else if ParamStr(1) = 'DIR' then
  begin
    Params.RecMode := topDown;
    Params.Runner := DirRunner;
  end
  else if (ParamStr(1) = 'RD') or (ParamStr(1) = 'RMDIR') then
  begin
    Params.RecMode := bottomUp;
    Params.Runner := RmdirRunner;
  end
  else if ParamStr(1) = 'COPY' then
  begin
    Params.RecMode := topDown;
    Params.Runner := CopyRunner;
  end
  else
  begin
    Writeln('Unknown mode: ', ParamStr(1));
    Halt;
  end;
end;



{
  Returns the index of the rightmost occurrence of SubStr in Str.
}
function PosR(
  SubStr : String;
  Str : String
) : Byte;

var
  Idx : Byte;

begin
  PosR := 0;
  Idx := Length(Str);
  while (Copy(Str, Idx, Length(SubStr)) <> SubStr) and (Idx > 0) do
    Idx := Idx - 1;
  PosR := Idx;
end;



{
  Parse the source part of command line arguments.
  The source can be a file or a file mask with wildcards.
  The source can also be a directory, in which case the mask is
  defaulted to *.*.
}
procedure ParseSource(
  SrcFn : String;
  var Params : TParams
);

var
  DelimPos : Byte;

begin
  if SrcFn = '' then
  begin
    Params.SrcPath := '.\';
    Params.Mask := '*.*';
  end
  else if (Pos('*', SrcFn) > 0) or (Pos('?', SrcFn) > 0) then
  begin
    DelimPos := PosR('\', SrcFn);
    Params.SrcPath := Copy(SrcFn, 1, DelimPos);
    Params.Mask := Copy(SrcFn, DelimPos + 1, Length(SrcFn));
  end
  else
  begin
    if StrEnds(SrcFn, '\') then
      Params.SrcPath := SrcFn
    else
      Params.SrcPath := SrcFn + '\';
    Params.Mask := '*.*';
  end;
end;



{
  Parse the destination path from the command line.
}
procedure ParseDestination(
  DestFnm : String;
  var Params : TParams
);

begin
  if DestFnm = '' then
    Params.DestPath := '.\'
  else
    if StrEnds(DestFnm, '\') then
      Params.DestPath := DestFnm
    else
      Params.DestPath := DestFnm + '\';
end;



{
  Parse the command line arguments.
}
procedure ParseCmdLine(
  var Params : TParams
);

begin
  ParseCommand(ParamStr(1), Params);
  ParseSource(ParamStr(2), Params);
  ParseDestination(ParamStr(3), Params);
end;



{
  A recursive procedure to process files in a directory and its subdirs.
}
procedure Run(
  Params : TParams;
  CurPath : String
);

var
  FData : SearchRec;

begin
  FindFirst(
    CurPath + Params.Mask,
    AnyFile,
    FData
  );
  while DosError = 0 do
  begin
    if not ((FData.Attr and Directory) = Directory) then
      Params.Runner(FData, CurPath, Params.DestPath);
    FindNext(FData);
  end;

  FindFirst(
    CurPath + '*.*',
    AnyFile,
    FData
  );
  while DosError = 0 do
  begin
    if ((FData.attr and Directory) = Directory)
       and (not IsDotFnm(FData.Name)) then
    begin
      if Params.RecMode = topDown then
        Params.Runner(FData, CurPath, Params.DestPath);
      Run(
        Params,
        CurPath + FData.Name + '\'
      );
      if Params.RecMode = bottomUp then
        Params.Runner(FData, CurPath, Params.DestPath);
    end;
    FindNext(FData);
  end;
end;



var
  Params : TParams;



begin
  Writeln('DIRS.EXE 1.0.0');
  Writeln;
  Writeln('Performs functions on a directory recursively.');
  Writeln;
  Writeln('Usage: ');
  Writeln('DIRS <cmd> [source] [dest]');
  Writeln;

  ParseCmdLine(Params);

  Writeln('Source:      ', FExpand(Params.SrcPath));
  Writeln('Mask:        ', Params.Mask);
  Writeln('Destination: ', FExpand(Params.DestPath));
  Writeln;

  Run(Params, Params.SrcPath)
end.